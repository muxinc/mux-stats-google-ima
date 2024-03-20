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

class ViewController: UIViewController, IMAAdsLoaderDelegate, IMAAdsManagerDelegate {
    
    private let DEMO_PLAYER_NAME = "adplayer"
    private let MUX_DATA_ENV_KEY = "rhhn9fph0nog346n4tqb6bqda"
    
    private let SSAI_ASSET_TAG_BUCK = "c-rArva4ShKVIAkNfy6HUQ"
    
    private let AD_TAG_LOTS_OF_MIDROLLS = "https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/vmap_ad_samples&sz=640x480&cust_params=sample_ar%3Dpremidpostlongpod&ciu_szs=300x250&gdfp_req=1&ad_rule=1&output=vmap&unviewed_position_start=1&env=vp&impl=s&cmsid=496&vid=short_onecue&correlator="
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
        sendClientAdsRequest(
            adTagUrl: AD_TAG_LOTS_OF_MIDROLLS,
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: contentPlayhead
        )
    }
    
    func sendClientAdsRequest(adTagUrl: String, adDisplayContainer: IMAAdDisplayContainer, contentPlayhead: IMAAVPlayerContentPlayhead?) {
        let request = IMAAdsRequest(
            adTagUrl: adTagUrl,
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: contentPlayhead,
            userContext: nil
        )
        
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
        print("ADTEST: adsLoader: adsLoadedWith called")
        
        adsManager = adsLoadedData.adsManager
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
    
    // MARK: - IMAAdsManagerDelegate
    
    func adsManager(_ adsManager: IMAAdsManager, didReceive event: IMAAdEvent) {
        imaListener?.dispatchEvent(event)
        
        // Play each ad once it has been loaded
        if event.type == IMAAdEventType.LOADED {
            adsManager.start()
        }
    }
    
    func adsManager(_ adsManager: IMAAdsManager, didReceive error: IMAAdError) {
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
