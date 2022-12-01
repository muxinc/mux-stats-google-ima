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

class ViewController: UIViewController {
    
    private let DEMO_PLAYER_NAME = "adplayer"
    private let AD_TAG_URL = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostlongpod&cmsid=496&vid=short_tencue&correlator="
    private let VOD_TEST_URL = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
    private let VOD_TEST_URL_STEVE  = "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8"
    
    // Player / Player State
    private var player: AVPlayer?
    private var playerViewController: AVPlayerViewController!
    
    // IMA Ads SDK
    private var adsLoader: IMAAdsLoader?
    private var adsManager: IMAAdsManager?
    private var contentPlayhead: IMAAVPlayerContentPlayhead?
    
    // Mux SDK
    private var imaListener: MuxImaListener?
    private var playerBinding: MUXSDKPlayerBinding?
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /*
     TODO: STEP SEVEN OF THE SAMPLE APP
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        setUpContentPlayer()
        setUpAdsLoader()
    }
    
    func setUpContentPlayer() {
        // Load AVPlayer with path to your content.
        let url = VOD_TEST_URL
        guard let contentURL = URL(string: url) else {
            NSLog("!!! Bad Content URL %s", url)
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
    
    func setUpAdsLoader() {
        adsLoader = IMAAdsLoader(settings: nil)
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
        
        adsLoader.requestAds(with: request)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        requestAds()
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
    
    @objc func contentDidFinishPlaying(_ notification: Notification) {
        adsLoader?.contentComplete()
    }
    
}
