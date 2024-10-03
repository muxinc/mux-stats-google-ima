//
//  UIProcessInfo+Extensions.swift
//  MuxStatsGoogleIMAPluginSPMExampleIOS
//

import Foundation

extension ProcessInfo {
    var environmentKey: String? {
        guard let value = environment["MUX_DATA_ENV_KEY"],
                !value.isEmpty else {
            return nil
        }

        return value
    }
}


