//
//  ProcessInfo+Data.swift
//  MUXSDKIMATVOSExample
//
//  Created by AJ Barinov on 9/6/23.
//  Copyright © 2023 Dylan Jhaveri. All rights reserved.
//

import Foundation

extension ProcessInfo {
    var environmentKey: String {
        environment["MUX_ENVIRONMENT_KEY"] ?? ""
    }
}
