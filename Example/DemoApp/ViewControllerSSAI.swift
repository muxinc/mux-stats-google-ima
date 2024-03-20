//
//  ViewController.swift
//  DemoApp
//
//  Created by Emily Dixon on 11/30/22.
//  Copyright © 2022 Dylan Jhaveri. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Mux_Stats_Google_IMA
import MUXSDKStats
import GoogleInteractiveMediaAds

class ViewControllerSSAI: UIViewController, IMAAdsLoaderDelegate,  IMAStreamManagerDelegate {
    
    
    private let DEMO_PLAYER_NAME = "adplayer"
    private let MUX_DATA_ENV_KEY = "rhhn9fph0nog346n4tqb6bqda"
    
    private let SSAI_ASSET_TAG_BUCK = "c-rArva4ShKVIAkNfy6HUQ"
    
    
    // Player / Player State
    private var player: AVPlayer?
    private var playerViewController: AVPlayerViewController!
    
    // IMA Ads SDK
    private var adsLoader: IMAAdsLoader!
//    private var adsManager: IMAAdsManager!
    private var adsManager: IMAStreamManager!
    private var contentPlayhead: IMAAVPlayerContentPlayhead?
    
    // Mux SDK
    private var imaListener: MuxImaListener?
    private var playerBinding: MUXSDKPlayerBinding?
    
    private var adContainerView: UIView?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        playerBinding?.detachAVPlayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.view.accessibilityIdentifier = "AVPlayerView"
        
        let adContainerView = UIView()
        self.adContainerView = adContainerView
        self.view.addSubview(adContainerView)
        adContainerView.frame = self.view.bounds;

        
        setUpContentPlayer(mediaUrl: SSAI_ASSET_TAG_BUCK)
        setUpAdsLoader()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        requestAds()
        player?.play()
    }
    
    func setUpContentPlayer(mediaUrl: String) {
        // Load AVPlayer with path to your content.
        guard let contentURL = URL(string: mediaUrl) else {
            NSLog("!!! Bad Content URL %s", mediaUrl)
            return
        }
        let player = AVPlayer(url: contentURL)
        playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        setUpMux(player: player)
        
        self.player = player
        
        // Set up your content playhead and contentComplete callback.
        contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: player)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ViewController.contentDidFinishPlaying(_:)),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: player.currentItem);
        
        showContentPlayer()
    }
    
    func setUpMux(player: AVPlayer) {
        // Basic Data
        let envKey = ProcessInfo.processInfo.environment["ENV_KEY"] ?? MUX_DATA_ENV_KEY
        let customerPlayerData = MUXSDKCustomerPlayerData(environmentKey: envKey)
        let customerVideoData = MUXSDKCustomerVideoData()
        customerVideoData.videoTitle = "Mux Data IMA SDK Test"
        customerVideoData.videoSourceUrl = nil
        let customerData = MUXSDKCustomerData(customerPlayerData: customerPlayerData, videoData: customerVideoData, viewData: nil, customData: nil)!
        let playerBinding = MUXSDKStats.monitorAVPlayerViewController(playerViewController, withPlayerName: DEMO_PLAYER_NAME, customerData: customerData)!
        self.playerBinding = playerBinding
        
        // IMA Ads
        imaListener = MuxImaListener(playerBinding: playerBinding)
    }
    
    func setUpAdsLoader() {
        let settings = IMASettings()
        settings.enableDebugMode = true
//        adsLoader = IMAAdsLoader(settings: settings)
        adsLoader = IMAAdsLoader(settings: nil)
        adsLoader.delegate = self
    }
    
    func requestAds() {
        guard let adsLoader = self.adsLoader else {
            NSLog("!! RequestAds called without adLoader")
            return
        }
        
        // Create ad display container for ad rendering.
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: self.view, viewController: self)
        // Create an ad request with our ad tag, display container, and optional user context.
        sendServerAdsRequest(
            adTagUrl: SSAI_ASSET_TAG_BUCK,
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: contentPlayhead
        )
    }
    
    func sendServerAdsRequest(adTagUrl: String, adDisplayContainer: IMAAdDisplayContainer, contentPlayhead: IMAAVPlayerContentPlayhead?) {
        let display = IMAAVPlayerVideoDisplay(avPlayer: self.playerViewController.player!)
        let displayContainer = IMAAdDisplayContainer(adContainer: self.adContainerView!, viewController: self)
        let request = IMALiveStreamRequest(assetKey: SSAI_ASSET_TAG_BUCK, adDisplayContainer: displayContainer, videoDisplay: display, userContext: nil)
        
        imaListener?.daiAdRequest(request)
        adsLoader.requestStream(with: request)
    }
    
    func showContentPlayer() {
        self.addChild(playerViewController)
        playerViewController.view.frame = self.view.bounds
        self.view.insertSubview(playerViewController.view, at: 0)
        playerViewController.didMove(toParent:self)
    }
    
    func hideContentPlayer() {
        // The whole controller needs to be detached so that it doesn't capture  events from the remote.
        playerViewController.willMove(toParent:nil)
        playerViewController.view.removeFromSuperview()
        playerViewController.removeFromParent()
    }
    
    // MARK: - IMAAdsLoaderDelegate
    
    func adsLoader(_ loader: IMAAdsLoader, adsLoadedWith adsLoadedData: IMAAdsLoadedData) {
        print("ADTEST: adsLoader: adsLoadedWith called")
        
        adsManager = adsLoadedData.streamManager
        adsManager.delegate = self
        adsManager.initialize(with: nil)
    }
    
    func adsLoader(_ loader: IMAAdsLoader, failedWith adErrorData: IMAAdLoadingErrorData) {
        print("ADTEST: adsLoader error:" + (adErrorData.adError.message ?? "nil"))
        print("Error loading ads: " + (adErrorData.adError.message ?? "nil"))
        showContentPlayer()
        playerViewController.player?.play()
    }
    
    @objc func contentDidFinishPlaying(_ notification: Notification) {
        adsLoader?.contentComplete()
    }
    
    // MARK: - IMAStreamManmagerDelegate
    
    func streamManager(_ adsManager: IMAStreamManager, didReceive event: IMAAdEvent) {
        imaListener?.dispatchEvent(event)
        
        // Play each ad once it has been loaded
//        if event.type == IMAAdEventType.LOADED {
//            adsManager.start()
//        }
    }
    
    func streamManager(_ adsManager: IMAStreamManager, didReceive error: IMAAdError) {
        // Fall back to playing content
        print("ADTEST: AdsManager error: " + (error.message ?? "nil"))
        print("AdsManager error: " + (error.message ?? "nil"))
        imaListener?.dispatchError(error.message ?? "nil")
        showContentPlayer()
        playerViewController.player?.play()
    }
    
    func adsManager(_ adsManager: IMAAdsManager, adDidProgressToTime mediaTime: TimeInterval, totalTime: TimeInterval) {
        
        let nowish = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm:ss:SSS")
        let dateStr = dateFormatter.string(from: nowish)
        
        print("ADTEST: adDidProgressToTime: \(String(describing: mediaTime)) / \(String(describing: totalTime)) at \(dateStr)")
    }
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager) {
        // Pause the content for the SDK to play ads.
        playerViewController.player?.pause()
        imaListener?.onContentPauseOrResume(true)
        hideContentPlayer()
    }
    
    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager) {
        // Resume the content since the SDK is done playing ads (at least for now).
        showContentPlayer()
        imaListener?.onContentPauseOrResume(false)
        playerViewController.player?.play()
    }
    
}
