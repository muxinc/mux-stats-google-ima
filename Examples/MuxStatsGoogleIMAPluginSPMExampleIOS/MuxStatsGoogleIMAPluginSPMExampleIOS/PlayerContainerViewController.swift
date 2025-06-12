//
//  PlayerContainerViewController.swift
//  MuxStatsGoogleIMAPluginSPMExampleIOS
//

import AVFoundation
import AVKit
import UIKit

import GoogleInteractiveMediaAds
import MuxStatsGoogleIMAPlugin
import MUXSDKStats
import MuxCore

class PlayerContainerViewController: UIViewController {

    // Default URLs

    var adTagURLString =
    "https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/"
    + "single_ad_samples&sz=640x480&cust_params=sample_ct%3Dlinear&ciu_szs=300x250%2C728x90&"
    + "gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&impl=s&correlator="

    var contentURLString = "https://stream.mux.com/a4nOgmxGWg6gULfcBbAa00gXyfcwPnAFldF8RdsNyk8M.m3u8"

    // Google IMA

    var imaAdsSDKSettings: IMASettings {
        IMASettings()
    }
    lazy var adsLoader = IMAAdsLoader(
        settings: imaAdsSDKSettings
    )
    var adsManager: IMAAdsManager?

    var contentPlayhead: IMAAVPlayerContentPlayhead?

    // Mux Data

    var playerBinding: MUXSDKPlayerBinding?

    var adsListener: MUXSDKIMAAdsListener?

    var environmentKey: String = ProcessInfo.processInfo.environmentKey ?? ""

    var playerName: String {
        title ?? "adplayer"
    }

    // Player

    lazy var contentPlayer = AVPlayer(
        url: URL(
            string: contentURLString
        )!
    )
    lazy var playerViewController = AVPlayerViewController()

    // MARK: View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black
        self.view.accessibilityIdentifier = "AVPlayerView"
    }

    func setupPlayer() {
        // MARK: Setup Content Player
        playerViewController.player = contentPlayer

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(Self.handleContentDidFinishPlaying(_:)),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: contentPlayer.currentItem)

        // MARK: Setup Google IMA Ads
        contentPlayhead = IMAAVPlayerContentPlayhead(
            avPlayer: contentPlayer
        )

        adsLoader = IMAAdsLoader(settings: IMASettings())
        adsLoader.delegate = self

        // MARK: Setup Mux Data
        let customerPlayerData = MUXSDKCustomerPlayerData()
        customerPlayerData.environmentKey = environmentKey

        let customerVideoData = MUXSDKCustomerVideoData()
        if let title {
            customerVideoData.videoTitle = title
        }

        let customerData = MUXSDKCustomerData()
        customerData.customerPlayerData = customerPlayerData
        customerData.customerVideoData = customerVideoData

        guard let playerBinding = MUXSDKStats.monitorAVPlayerViewController(
            playerViewController,
            withPlayerName: playerName,
            customerData: customerData
        ) else {
            return
        }

        self.playerBinding = playerBinding

        // MARK: Setup Mux Data IMA Plugin
        adsListener = MUXSDKIMAAdsListener(
            playerBinding: playerBinding,
            monitoringAdsLoader: adsLoader
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showContentPlayer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        MUXSDKStats.destroyPlayer(
            playerName
        )
        hideContentPlayer()
        contentPlayer.replaceCurrentItem(with: nil)
        super.viewWillDisappear(animated)
    }

    // MARK: Show and hide content player

    func showContentPlayer() {
        self.addChild(playerViewController)
        playerViewController.view.frame = self.view.bounds
        self.view.insertSubview(playerViewController.view, at: 0)
        playerViewController.didMove(toParent:self)
    }

    func hideContentPlayer() {
        // The whole controller needs to be detached so that
        // it doesn't capture  events from the remote.
        playerViewController.willMove(toParent:nil)
        playerViewController.view.removeFromSuperview()
        playerViewController.removeFromParent()
    }

    // MARK: Handlers

    func playButtonPressed() {
        setupPlayer()
        requestAds()
    }

    @objc func handleContentDidFinishPlaying(
        _ notification: Notification
    ) {
        adsLoader.contentComplete()
    }

    func requestAds() {
        // Create ad display container for ad rendering.
        let adDisplayContainer = IMAAdDisplayContainer(
            adContainer: self.view,
            viewController: self
        )

        // Create an ad request with our ad tag, display
        // container, and optional user context.
        let request = IMAAdsRequest(
            adTagUrl: adTagURLString,
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: contentPlayhead,
            userContext: nil
        )

        adsLoader.requestAds(with: request)

        // Notify Mux Data about request
        adsListener?.clientAdRequest(request)
    }

    // MARK: deinit

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - IMAAdsLoaderDelegate

extension PlayerContainerViewController: IMAAdsLoaderDelegate {
    func adsLoader(
        _ loader: IMAAdsLoader,
        adsLoadedWith adsLoadedData: IMAAdsLoadedData
    ) {
        guard let loadedAdsManager = adsLoadedData.adsManager else {
            return
        }

        loadedAdsManager.delegate = self

        // MARK: Monitor the IMAAdsManager with Mux
        // note - do this *after* setting your delegate but
        // *before* calling `IMAAdsManager:initialize:with`
        adsListener?.monitorAdsManager(loadedAdsManager)

        let renderingSettings = IMAAdsRenderingSettings()
        renderingSettings.enablePreloading = true;
        loadedAdsManager.initialize(
            with: renderingSettings
        )

        adsManager = loadedAdsManager
    }

    func adsLoader(
        _ loader: IMAAdsLoader,
        failedWith adErrorData: IMAAdLoadingErrorData
    ) {
        showContentPlayer()
        contentPlayer.play()
    }
}

// MARK: - IMAAdsManagerDelegate

extension PlayerContainerViewController: IMAAdsManagerDelegate {

    func adsManager(
        _ adsManager: IMAAdsManager,
        didReceive event: IMAAdEvent
    ) {
        // Play each ad once it has been loaded
        if event.type == IMAAdEventType.LOADED {
            adsManager.start()
        }
    }

    func adsManager(
        _ adsManager: IMAAdsManager,
        didReceive error: IMAAdError
    ) {

        showContentPlayer()
        contentPlayer.play()

        if let message = error.message {
            print("AdsManager error: \(message)")
        }
    }

    func adsManagerDidRequestContentPause(
        _ adsManager: IMAAdsManager
    ) {

        // Pause the content for the SDK to play ads.
        playerViewController.player?.pause()

        hideContentPlayer()
    }

    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager) {

        // Resume the content since the SDK is done playing
        // ads (at least for now).

        showContentPlayer()
        contentPlayer.play()
    }
}
