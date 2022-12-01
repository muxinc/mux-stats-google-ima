//
//  DemoAppUITests.swift
//  DemoAppUITests
//
//  Created by Emily Dixon on 11/30/22.
//  Copyright © 2022 Dylan Jhaveri. All rights reserved.
//

import XCTest

final class DemoAppUITests: XCTestCase {
    
    // Set this key to your environment key to have the tests generate data on your dashboard
    let UI_TEST_ENV_KEY = "tr4q3qahs0gflm8b1c75h49ln";
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testImaSdk() throws {
        let app = XCUIApplication()
        app.launchEnvironment = [
            "ENV_KEY": UI_TEST_ENV_KEY
        ]
        app.launch()
        
        let waitForLaunchAndPreroll = XCTestExpectation(description: "Wait for launch (~5 sec) and preroll (10 sec)")
        let launchAndPrerollResult = XCTWaiter.wait(for: [waitForLaunchAndPreroll], timeout: 15.0)
        if(launchAndPrerollResult != XCTWaiter.Result.timedOut) {
            XCTFail("interrupted while playing")
        }
        
        let playerViewElement = app.otherElements["AVPlayerView"]
        // TODO: This also pauses the video on iOS 16. Is that fine?
        playerViewElement.tap()
        
        let skipForwardButton = app.buttons["Skip Forward"]
        skipForwardButton.tap()
        let waitForMidroll = XCTWaiter.wait(for: [XCTestExpectation(description: "Wait for Midroll (30s)")], timeout: 30.0)
        if(waitForMidroll != XCTWaiter.Result.timedOut) {
            XCTFail("interrupted while waiting for midroll")
        }
        let waitForALittleMore = XCTWaiter.wait(for: [XCTestExpectation(description: "Wait 10 more seconds")], timeout: 10.0)
        if(waitForALittleMore != XCTWaiter.Result.timedOut) {
            XCTFail("play interrupted")
        }
    }
}
