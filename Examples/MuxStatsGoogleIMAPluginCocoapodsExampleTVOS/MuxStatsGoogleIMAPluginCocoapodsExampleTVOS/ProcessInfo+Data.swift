//
//  ProcessInfo+Data.swift
//  MuxStatsGoogleIMAPluginCocoapodsExampleTVOS
//

import Foundation

extension ProcessInfo {
    var environmentKey: String {
        environment["MUX_ENVIRONMENT_KEY"] ?? ""
    }
}
