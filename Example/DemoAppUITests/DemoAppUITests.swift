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

    var launchedApplication: XCUIApplication?

    override func setUpWithError() throws {
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchEnvironment = [
            "ENV_KEY": UI_TEST_ENV_KEY
        ]
        app.activate()
        app.launch()

        launchedApplication = app
    }
    
    func testAdPlayback() throws {

        guard let launchedApplication else {
            XCTFail("Failed to launch application")
            return
        }

        let launchWaitResult = launchedApplication.wait(
            for: XCUIApplication.State.runningForeground,
            timeout: 10.0
        )

        XCTAssertTrue(
            launchWaitResult,
            "Application is not running in foreground and cannot receive tap events."
        )

        // TODO: Check if a preroll ad is actually present
        let waitForLaunchAndPreroll = XCTestExpectation(
            description: "Wait for launch (~5 sec) and preroll (10 sec)"
        )
        let launchAndPrerollResult = XCTWaiter.wait(
            for: [waitForLaunchAndPreroll],
            timeout: 15.0
        )
        if (launchAndPrerollResult != XCTWaiter.Result.timedOut) {
            XCTFail("interrupted while playing")
        }
        
        let playerViewElement = launchedApplication.otherElements["AVPlayerView"]

        let playerViewElementExistenceResult = playerViewElement.waitForExistence(
            timeout: 10.0
        )

        XCTAssertTrue(
            playerViewElementExistenceResult,
            "AVPlayerView never came into existence."
        )

        XCTAssertTrue(
            playerViewElement.isHittable,
            "AVPlayerView cannot be clicked, tapped, or pressed. It is either offscreen, covered by another element or is not present in view hierarchy"
        )

        playerViewElement.tap()

        let skipForwardButton = launchedApplication.buttons["Skip Forward"]

        let skipForwardButtonExistenceResult = skipForwardButton.waitForExistence(
            timeout: 10.0
        )

        XCTAssertTrue(
            skipForwardButtonExistenceResult,
            "Skip forward button never came into existence"
        )

        XCTAssertTrue(
            skipForwardButton.isHittable,
            "AVPlayer skip forward button cannot be clicked, tapped, or pressed. It is either offscreen, covered by another element or is not present in view hierarchy"
        )

        skipForwardButton.tap()

        // TODO: Check if a midroll ad is actually present
        let midrollExpectation = XCTestExpectation(
            description: "Wait for Midroll (40s)"
        )
        let waitForMidroll = XCTWaiter.wait(
            for: [midrollExpectation],
            timeout: 40.0
        )
        if (waitForMidroll != XCTWaiter.Result.timedOut) {
            XCTFail("interrupted while waiting for midroll")
        }
    }
}
