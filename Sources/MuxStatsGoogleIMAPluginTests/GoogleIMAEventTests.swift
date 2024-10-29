//
//  GoogleIMAEventTests.swift
//  MuxStatsGoogleIMAPlugin
//

import XCTest

import GoogleInteractiveMediaAds
import MUXSDKStats

@testable import MuxStatsGoogleIMAPlugin
@testable import MuxStatsGoogleIMAPlugin.Manual

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
        
        let adsLoader = IMAAdsLoader()
        let imaListener = MuxImaListener(
            playerBinding: binding,
            monitoringAdsLoader: adsLoader
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

        let adsLoader = IMAAdsLoader()
        let imaListener = MuxImaListener(
            playerBinding: binding,
            options: .pictureInPicture,
            monitoringAdsLoader: adsLoader
        )

        XCTAssertNotNil(imaListener)

    }

    func testMuxImaListenerStartedEvent() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MuxImaListener(
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

    func testMuxImaListenerFirstQuartileEvent() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MuxImaListener(
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

    func testMuxImaListenerMidpointEvent() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MuxImaListener(
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

    func testMuxImaListenerThirdQuartileEvent() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MuxImaListener(
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

    func testMuxImaListenerSkippedEvent() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MuxImaListener(
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

    func testMuxImaListenerCompleteEvent() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MuxImaListener(
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

    func testMuxImaListenerPauseEvent() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MuxImaListener(
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

    func testMuxImaListenerLogEventWithoutErrorData() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MuxImaListener(
            playerBinding: binding,
            monitoringAdsLoader: adsLoader
        )

        let event =  imaListener.dispatchEvent(of: .LOG)

        XCTAssertNil(
            event
        )
    }

    func testMuxImaListenerLogEventWithErrorData() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MuxImaListener(
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

    func testMuxImaListenerTappedEvent() throws {
        let binding = try XCTUnwrap(
            MUXSDKPlayerBinding(
                name: "",
                andSoftware: ""
            )
        )

        let adsLoader = IMAAdsLoader()
        let imaListener = MuxImaListener(
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
