//
//  MenuItem.swift
//  MuxStatsGoogleIMAPluginSPMExampleIOS
//

import Foundation

struct MenuItem: Identifiable {
    var name: String
    var adTagURL: String
    var contentURL: String

    let id: UUID = UUID()
}

extension MenuItem {
    static let standardPreRoll = MenuItem(
        name: "Standard pre-roll",
        adTagURL: "https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/"
        + "single_ad_samples&sz=640x480&cust_params=sample_ct%3Dlinear&ciu_szs=300x250%2C728x90&"
        + "gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&impl=s&correlator=",
        contentURL: "https://stream.mux.com/a4nOgmxGWg6gULfcBbAa00gXyfcwPnAFldF8RdsNyk8M.m3u8"
    )

    static let skippablePreRoll = MenuItem(
        name: "Skippable pre-roll",
        adTagURL: "https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/"
        + "single_preroll_skippable&sz=640x480&ciu_szs=300x250%2C728x90&gdfp_req=1&"
        + "output=vast&unviewed_position_start=1&env=vp&impl=s&correlator=",
        contentURL: "https://stream.mux.com/a4nOgmxGWg6gULfcBbAa00gXyfcwPnAFldF8RdsNyk8M.m3u8"
    )

    static let postRoll = MenuItem(
        name: "Post-roll",
        adTagURL: "https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/"
        + "vmap_ad_samples&sz=640x480&cust_params=sample_ar%3Dpostonly&ciu_szs=300x250&"
        + "gdfp_req=1&ad_rule=1&output=vmap&unviewed_position_start=1&env=vp&impl=s&correlator=",
        contentURL: "https://stream.mux.com/a4nOgmxGWg6gULfcBbAa00gXyfcwPnAFldF8RdsNyk8M.m3u8"
    )

    static let adRules = MenuItem(
        name: "Ad rules",
        adTagURL: "https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/"
        + "vmap_ad_samples&sz=640x480&cust_params=sample_ar%3Dpremidpost&ciu_szs=300x250&"
        + "gdfp_req=1&ad_rule=1&output=vmap&unviewed_position_start=1&env=vp&impl=s&cmsid=496&"
        + "vid=short_onecue&correlator=",
        contentURL: "https://stream.mux.com/a4nOgmxGWg6gULfcBbAa00gXyfcwPnAFldF8RdsNyk8M.m3u8"
    )

    static let vmapPods = MenuItem(
        name: "VMAP Pods",
        adTagURL: "https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/"
        + "vmap_ad_samples&sz=640x480&cust_params=sample_ar%3Dpremidpostpod&ciu_szs=300x250&"
        + "gdfp_req=1&ad_rule=1&output=vmap&unviewed_position_start=1&env=vp&impl=s&cmsid=496&"
        + "vid=short_onecue&correlator=",
        contentURL: "https://stream.mux.com/a4nOgmxGWg6gULfcBbAa00gXyfcwPnAFldF8RdsNyk8M.m3u8"
    )

    static let custom = MenuItem(
        name: "Custom",
        adTagURL: "https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/"
        + "single_ad_samples&sz=640x480&cust_params=sample_ct%3Dlinear&ciu_szs=300x250%2C728x90&"
        + "gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&impl=s&correlator=",
        contentURL: "https://stream.mux.com/a4nOgmxGWg6gULfcBbAa00gXyfcwPnAFldF8RdsNyk8M.m3u8"
    )
}
