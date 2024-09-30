//
//  GoogleIMAEventTests.swift
//  MuxStatsGoogleIMAPlugin
//

import XCTest

import GoogleInteractiveMediaAds
import MUXSDKStats

@testable import MuxStatsGoogleIMAPlugin

class MUXSDKMockIMAAdStartedEvent: IMAAdEvent {
    override var type: IMAAdEventType {
        return .STARTED
    }
}

class MUXSDKMockIMAAdFirstQuartileEvent: IMAAdEvent {
    override var type: IMAAdEventType {
        return .FIRST_QUARTILE
    }
}

class MUXSDKMockIMAAdMidpointEvent: IMAAdEvent {
    override var type: IMAAdEventType {
        return .MIDPOINT
    }
}

class MUXSDKMockIMAAdThirdQuartileEvent: IMAAdEvent {
    override var type: IMAAdEventType {
        return .THIRD_QUARTILE
    }
}

class MUXSDKMockIMAAdSkippedEvent: IMAAdEvent {
    override var type: IMAAdEventType {
        return .SKIPPED
    }
}

class MUXSDKMockIMAAdCompleteEvent: IMAAdEvent {
    override var type: IMAAdEventType {
        return .COMPLETE
    }
}

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

    func testMuxImaListenerStartedEvent() throws {
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

        let event = try XCTUnwrap(
            imaListener.dispatchEvent(
                .STARTED,
                with: nil,
                withIMAAdData: nil
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

        let imaListener = MuxImaListener(
            playerBinding: binding,
            options: .pictureInPicture
        )

        let event = try XCTUnwrap(
            imaListener.dispatchEvent(
                .FIRST_QUARTILE,
                with: nil,
                withIMAAdData: nil
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

        let imaListener = MuxImaListener(
            playerBinding: binding,
            options: .pictureInPicture
        )

        let event = try XCTUnwrap(
            imaListener.dispatchEvent(
                .MIDPOINT,
                with: nil,
                withIMAAdData: nil
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

        let imaListener = MuxImaListener(
            playerBinding: binding,
            options: .pictureInPicture
        )

        let event = try XCTUnwrap(
            imaListener.dispatchEvent(
                .THIRD_QUARTILE,
                with: nil,
                withIMAAdData: nil
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

        let imaListener = MuxImaListener(
            playerBinding: binding,
            options: .pictureInPicture
        )

        let event = try XCTUnwrap(
            imaListener.dispatchEvent(
                .SKIPPED,
                with: nil,
                withIMAAdData: nil
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

        let imaListener = MuxImaListener(
            playerBinding: binding,
            options: .pictureInPicture
        )

        let event = try XCTUnwrap(
            imaListener.dispatchEvent(
                .COMPLETE,
                with: nil,
                withIMAAdData: nil
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

        let imaListener = MuxImaListener(
            playerBinding: binding,
            options: .pictureInPicture
        )

        let event = try XCTUnwrap(
            imaListener.dispatchEvent(
                .PAUSE,
                with: nil,
                withIMAAdData: nil
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

        let imaListener = MuxImaListener(
            playerBinding: binding
        )

        let event = imaListener.dispatchEvent(
            .LOG,
            with: nil,
            withIMAAdData: nil
        )

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

        let imaListener = MuxImaListener(
            playerBinding: binding
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

        let imaListener = MuxImaListener(
            playerBinding: binding,
            options: .pictureInPicture
        )

        let event = imaListener.dispatchEvent(
            .TAPPED,
            with: nil,
            withIMAAdData: nil
        )

        XCTAssertNil(event)
    }
}
