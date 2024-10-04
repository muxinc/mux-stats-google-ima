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
import MuxStatsGoogleIMAPlugin
import MUXSDKStats
import GoogleInteractiveMediaAds

class ViewController: UIViewController, IMAAdsLoaderDelegate, IMAAdsManagerDelegate {
    
    private let DEMO_PLAYER_NAME = "adplayer"
    private let MUX_DATA_ENV_KEY = "rhhn9fph0nog346n4tqb6bqda"
    
    private let AD_TAG_URL = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostlongpod&cmsid=496&vid=short_tencue&correlator="
    private let VOD_TEST_URL_STEVE = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
    private let VOD_TEST_URL_DRAGON_WOMAN = "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8"
    
    // Player / Player State
    private var player: AVPlayer?
    private var playerViewController: AVPlayerViewController!
    
    // IMA Ads SDK
    private var adsLoader: IMAAdsLoader!
    private var adsManager: IMAAdsManager!
    private var contentPlayhead: IMAAVPlayerContentPlayhead?
    
    // Mux SDK
    private var imaListener: MuxImaListener?
    private var playerBinding: MUXSDKPlayerBinding?
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        playerBinding?.detachAVPlayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.view.accessibilityIdentifier = "AVPlayerView"
        
        setUpContentPlayer(mediaUrl: VOD_TEST_URL_STEVE)
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
    
    // MARK: mux: Monitor your AVPlayer and IMAAdsLoader
    func setUpMux(player: AVPlayer, adsLoader: IMAAdsLoader) {
        // Basic Data
        let envKey = ProcessInfo.processInfo.environment["ENV_KEY"] ?? MUX_DATA_ENV_KEY
        let customerPlayerData = MUXSDKCustomerPlayerData(environmentKey: envKey)
        let customerVideoData = MUXSDKCustomerVideoData()
        customerVideoData.videoTitle = "Mux Data IMA SDK Test"
        let customerData = MUXSDKCustomerData(customerPlayerData: customerPlayerData, videoData: customerVideoData, viewData: nil, customData: nil)!
        let playerBinding = MUXSDKStats.monitorAVPlayerViewController(playerViewController, withPlayerName: DEMO_PLAYER_NAME, customerData: customerData)!
        self.playerBinding = playerBinding
        
        // IMA Ads
        imaListener = MuxImaListener(
            playerBinding: playerBinding,
            monitoringAdsLoader: adsLoader
        )
    }
    
    func setUpAdsLoader() {
        
        adsLoader = IMAAdsLoader(settings: nil)
        adsLoader.delegate = self;
        
        // MARK: mux: Set up Mux after you set up your AVPlayer and IAMAdsLoader
        if let player = player {
            setUpMux(player: player, adsLoader: adsLoader);
        }
    }
    
    func requestAds() {
        guard let adsLoader = self.adsLoader else {
            NSLog("!! RequestAds called without adLoader")
            return
        }
        
        // Create ad display container for ad rendering.
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: self.view, viewController: self)
        // Create an ad request with our ad tag, display container, and optional user context.
        let request = IMAAdsRequest(
            adTagUrl: AD_TAG_URL,
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: contentPlayhead,
            userContext: nil)
        
        // MARK: mux: Tell us when you first request CSAI ads
        imaListener?.clientAdRequest(request)
        adsLoader.requestAds(with: request)
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
        adsManager = adsLoadedData.adsManager
        adsManager.delegate = self
        
        //MARK: mux: Call before initialize() but after setting your IMAAdsManagerDelegate
        imaListener?.monitorAdsManager(adsManager)
        
        adsManager.initialize(with: nil)
    }
    
    func adsLoader(_ loader: IMAAdsLoader, failedWith adErrorData: IMAAdLoadingErrorData) {
        print("Error loading ads: " + (adErrorData.adError.message ?? "nil"))
        showContentPlayer()
        playerViewController.player?.play()
    }
    
    @objc func contentDidFinishPlaying(_ notification: Notification) {
        adsLoader?.contentComplete()
    }
    
    // MARK: - IMAAdsManagerDelegate
    
    func adsManager(_ adsManager: IMAAdsManager, didReceive event: IMAAdEvent) {
        // Play each ad once it has been loaded
        if event.type == IMAAdEventType.LOADED {
            adsManager.start()
        }
    }
    
    func adsManager(_ adsManager: IMAAdsManager, didReceive error: IMAAdError) {
        // Fall back to playing content
        print("AdsManager error: " + (error.message ?? "nil"))
        showContentPlayer()
        playerViewController.player?.play()
    }
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager) {
        // Pause the content for the SDK to play ads.
        playerViewController.player?.pause()
        hideContentPlayer()
    }
    
    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager) {
        // Resume the content since the SDK is done playing ads (at least for now).
        showContentPlayer()
        playerViewController.player?.play()
    }
    
}
