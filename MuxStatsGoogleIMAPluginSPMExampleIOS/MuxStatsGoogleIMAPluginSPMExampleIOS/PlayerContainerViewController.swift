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
    static let adTagURLString =
      "https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/"
      + "single_ad_samples&sz=640x480&cust_params=sample_ct%3Dlinear&ciu_szs=300x250%2C728x90&"
      + "gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&impl=s&correlator="

    var imaAdsSDKSettings: IMASettings {
        IMASettings()
    }
    lazy var adsLoader = IMAAdsLoader(
        settings: imaAdsSDKSettings
    )
    var adsManager: IMAAdsManager?

    var contentPlayhead: IMAAVPlayerContentPlayhead?

    static let contentURL = URL(
        string: "https://stream.mux.com/qxb01i6T202018GFS02vp9RIe01icTcDCjVzQpmaB00CUisJ4.m3u8"
    )!
    var contentPlayer = AVPlayer(
        url: PlayerContainerViewController.contentURL
    )
    lazy var playerViewController = AVPlayerViewController()

    var imaListener: MuxImaListener?

    // MARK: View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black
        self.view.accessibilityIdentifier = "AVPlayerView"

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
        guard let environmentKey = ProcessInfo.processInfo.environmentKey else {
            return
        }

        let customerPlayerData = MUXSDKCustomerPlayerData()
        customerPlayerData.environmentKey = environmentKey

        let customerVideoData = MUXSDKCustomerVideoData()
        customerVideoData.videoTitle = "Mux Data IMA SDK Example Preroll"

        let customerData = MUXSDKCustomerData()
        customerData.customerPlayerData = customerPlayerData
        customerData.customerVideoData = customerVideoData

        guard let playerBinding = MUXSDKStats.monitorAVPlayerViewController(
            playerViewController,
            withPlayerName: "adplayer",
            customerData: customerData
        ) else {
            return
        }

        // MARK: Setup Mux Data IMA Plugin
        imaListener = MuxImaListener(
            playerBinding: playerBinding,
            monitoringAdsLoader: adsLoader
        )
    }
    
    override func viewWillAppear() {
        super. viewWillAppear(animated)
       showContentPlayer()
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
            adTagUrl: PlayerContainerViewController.adTagURLString,
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: contentPlayhead,
            userContext: nil
        )

        adsLoader.requestAds(with: request)

        // Notify Mux Data about request
        imaListener?.clientAdRequest(request)
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
        // note - do this *after* setting your delegate but *before*
        imaListener?.monitorAdsManager(loadedAdsManager)
        
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
