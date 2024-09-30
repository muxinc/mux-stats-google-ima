//
//  GoogleIMAEventTests.swift
//  MuxStatsGoogleIMAPlugin
//

import XCTest

import MUXSDKStats

@testable import MuxStatsGoogleIMAPlugin


final class GoogleIMAEventTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMuxImaListenerInitialization() throws {

        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let imaListener = MuxImaListener(
            playerBinding: binding
        )

        XCTAssertNotNil(imaListener)

    }

    func testMuxImaListenerInitializationOptions() throws {

        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let imaListener = MuxImaListener(
            playerBinding: binding,
            options: .pictureInPicture
        )

        XCTAssertNotNil(imaListener)

    }

}
