//
//  GoogleIMAEventTests.swift
//  MuxStatsGoogleIMAPlugin
//

import XCTest

import GoogleInteractiveMediaAds
import MUXSDKStats

@testable import MuxStatsGoogleIMAPlugin
@testable import MuxStatsGoogleIMAPlugin.Private

final class GoogleIMAEventTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMUXSDKIMAAdsListenerInitialization() throws {

        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )
        
        let adsLoader = IMAAdsLoader()
        let imaListener = MUXSDKIMAAdsListener(
            playerBinding: binding,
            monitoringAdsLoader: adsLoader
        )

        XCTAssertNotNil(imaListener)

    }

    func testMUXSDKIMAAdsListenerInitializationOptions() throws {

        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MUXSDKIMAAdsListener(
            playerBinding: binding,
            options: .pictureInPicture,
            monitoringAdsLoader: adsLoader
        )

        XCTAssertNotNil(imaListener)

    }

    func testMUXSDKIMAAdsListenerStartedEvent() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MUXSDKIMAAdsListener(
            playerBinding: binding,
            options: .pictureInPicture,
            monitoringAdsLoader: adsLoader
        )

        let event = try XCTUnwrap(
            imaListener.dispatchEvent(
                of: .STARTED
            )
        )

        XCTAssertTrue(
            event.isKind(
                of: MUXSDKAdPlayingEvent.self
            )
        )
    }

    func testMUXSDKIMAAdsListenerFirstQuartileEvent() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MUXSDKIMAAdsListener(
            playerBinding: binding,
            options: .pictureInPicture,
            monitoringAdsLoader: adsLoader
        )

        let event = try XCTUnwrap(
            imaListener.dispatchEvent(
                of: .FIRST_QUARTILE
            )
        )

        XCTAssertTrue(
            event.isKind(
                of: MUXSDKAdFirstQuartileEvent.self
            )
        )
    }

    func testMUXSDKIMAAdsListenerMidpointEvent() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MUXSDKIMAAdsListener(
            playerBinding: binding,
            options: .pictureInPicture,
            monitoringAdsLoader: adsLoader
        )

        let event = try XCTUnwrap(
            imaListener.dispatchEvent(
                of: .MIDPOINT
            )
        )

        XCTAssertTrue(
            event.isKind(
                of: MUXSDKAdMidpointEvent.self
            )
        )
    }

    func testMUXSDKIMAAdsListenerThirdQuartileEvent() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MUXSDKIMAAdsListener(
            playerBinding: binding,
            options: .pictureInPicture,
            monitoringAdsLoader: adsLoader
        )

        let event = try XCTUnwrap(
            imaListener.dispatchEvent(
                of: .THIRD_QUARTILE
            )
        )

        XCTAssertTrue(
            event.isKind(
                of: MUXSDKAdThirdQuartileEvent.self
            )
        )
    }

    func testMUXSDKIMAAdsListenerSkippedEvent() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MUXSDKIMAAdsListener(
            playerBinding: binding,
            options: .pictureInPicture,
            monitoringAdsLoader: adsLoader
        )

        let event = try XCTUnwrap(
            imaListener.dispatchEvent(
                of: .SKIPPED
            )
        )

        XCTAssertTrue(
            event.isKind(
                of: MUXSDKAdEndedEvent.self
            )
        )
    }

    func testMUXSDKIMAAdsListenerCompleteEvent() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MUXSDKIMAAdsListener(
            playerBinding: binding,
            options: .pictureInPicture,
            monitoringAdsLoader: adsLoader
        )

        let event = try XCTUnwrap(
            imaListener.dispatchEvent(
                of: .COMPLETE
            )
        )

        XCTAssertTrue(
            event.isKind(
                of: MUXSDKAdEndedEvent.self
            )
        )
    }

    func testMUXSDKIMAAdsListenerPauseEvent() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MUXSDKIMAAdsListener(
            playerBinding: binding,
            options: .pictureInPicture,
            monitoringAdsLoader: adsLoader
        )

        let event = try XCTUnwrap(
            imaListener.dispatchEvent(
                of: .PAUSE
            )
        )

        XCTAssertTrue(
            event.isKind(
                of: MUXSDKAdPauseEvent.self
            )
        )
    }

    func testMUXSDKIMAAdsListenerLogEventWithoutErrorData() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MUXSDKIMAAdsListener(
            playerBinding: binding,
            monitoringAdsLoader: adsLoader
        )

        let event =  imaListener.dispatchEvent(of: .LOG)

        XCTAssertNil(
            event
        )
    }

    func testMUXSDKIMAAdsListenerLogEventWithErrorData() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MUXSDKIMAAdsListener(
            playerBinding: binding,
            monitoringAdsLoader: adsLoader
        )

        let errorData: [String : Any] = [
            "errorCode": 110,
            "errorMessage": "mock message",
            "type": "adPlayError"
        ]
        let logData: [String: Any] = [
            "logData": errorData
        ]

        let event = try XCTUnwrap(
            imaListener.dispatchEvent(
                .LOG,
                with: nil,
                withIMAAdData: logData
            )
        )

        XCTAssertTrue(
            event.isKind(
                of: MUXSDKAdErrorEvent.self
            )
        )
    }

    func testMUXSDKIMAAdsListenerTappedEvent() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MUXSDKIMAAdsListener(
            playerBinding: binding,
            options: .pictureInPicture,
            monitoringAdsLoader: adsLoader
        )

        let event = imaListener.dispatchEvent(
            of: .TAPPED
        )

        XCTAssertNil(event)
    }
}
