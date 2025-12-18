//
//  APIStatusTests.swift
//  Settings
//
//  Created by Ivan Tonial IP.TV on 17/12/25.
//

@testable import Settings
import SwiftUI
import Testing

// MARK: - APIStatus Initialization Tests

@Suite("APIStatus Initialization Tests")
struct APIStatusInitializationTests {

    @Test("APIStatus.online should exist")
    func testOnlineExists() {
        // Arrange & Act
        let status = APIStatus.online

        // Assert
        #expect(status == .online)
    }

    @Test("APIStatus.offline should exist")
    func testOfflineExists() {
        // Arrange & Act
        let status = APIStatus.offline

        // Assert
        #expect(status == .offline)
    }

    @Test("APIStatus.checking should exist")
    func testCheckingExists() {
        // Arrange & Act
        let status = APIStatus.checking

        // Assert
        #expect(status == .checking)
    }
}

// MARK: - APIStatus Color Tests

@Suite("APIStatus Color Tests")
struct APIStatusColorTests {

    @Test("Online status should have green color")
    func testOnlineColor() {
        // Arrange
        let status = APIStatus.online

        // Act
        let color = status.color

        // Assert
        #expect(color == .green)
    }

    @Test("Offline status should have red color")
    func testOfflineColor() {
        // Arrange
        let status = APIStatus.offline

        // Act
        let color = status.color

        // Assert
        #expect(color == .red)
    }

    @Test("Checking status should have yellow color")
    func testCheckingColor() {
        // Arrange
        let status = APIStatus.checking

        // Act
        let color = status.color

        // Assert
        #expect(color == .yellow)
    }

    @Test("All statuses should have different colors")
    func testAllColorsAreDifferent() {
        // Arrange
        let onlineColor = APIStatus.online.color
        let offlineColor = APIStatus.offline.color
        let checkingColor = APIStatus.checking.color

        // Assert
        #expect(onlineColor != offlineColor)
        #expect(onlineColor != checkingColor)
        #expect(offlineColor != checkingColor)
    }
}

// MARK: - APIStatus Text Tests

@Suite("APIStatus Text Tests")
struct APIStatusTextTests {

    @Test("Online status should have 'Connected' text")
    func testOnlineText() {
        // Arrange
        let status = APIStatus.online

        // Act
        let text = status.text

        // Assert
        #expect(text == "Connected")
    }

    @Test("Offline status should have 'Disconnected' text")
    func testOfflineText() {
        // Arrange
        let status = APIStatus.offline

        // Act
        let text = status.text

        // Assert
        #expect(text == "Disconnected")
    }

    @Test("Checking status should have 'Checking...' text")
    func testCheckingText() {
        // Arrange
        let status = APIStatus.checking

        // Act
        let text = status.text

        // Assert
        #expect(text == "Checking...")
    }

    @Test("All statuses should have non-empty text")
    func testAllTextsAreNonEmpty() {
        // Arrange
        let statuses: [APIStatus] = [.online, .offline, .checking]

        // Assert
        for status in statuses {
            #expect(!status.text.isEmpty)
        }
    }

    @Test("All statuses should have different texts")
    func testAllTextsAreDifferent() {
        // Arrange
        let onlineText = APIStatus.online.text
        let offlineText = APIStatus.offline.text
        let checkingText = APIStatus.checking.text

        // Assert
        #expect(onlineText != offlineText)
        #expect(onlineText != checkingText)
        #expect(offlineText != checkingText)
    }
}

// MARK: - APIStatus Equality Tests

@Suite("APIStatus Equality Tests")
struct APIStatusEqualityTests {

    @Test("Same status should be equal")
    func testSameStatusEquality() {
        // Arrange
        let status1 = APIStatus.online
        let status2 = APIStatus.online

        // Assert
        #expect(status1 == status2)
    }

    @Test("Different statuses should not be equal")
    func testDifferentStatusInequality() {
        // Arrange
        let online = APIStatus.online
        let offline = APIStatus.offline
        let checking = APIStatus.checking

        // Assert
        #expect(online != offline)
        #expect(online != checking)
        #expect(offline != checking)
    }
}

// MARK: - APIStatus Switch Statement Tests

@Suite("APIStatus Switch Statement Tests")
struct APIStatusSwitchTests {

    @Test("Switch should cover all cases for color")
    func testSwitchColorCoverage() {
        // Arrange
        let statuses: [APIStatus] = [.online, .offline, .checking]

        // Act & Assert
        for status in statuses {
            let color: Color
            switch status {
            case .online:
                color = .green
            case .offline:
                color = .red
            case .checking:
                color = .yellow
            }
            #expect(color == status.color)
        }
    }

    @Test("Switch should cover all cases for text")
    func testSwitchTextCoverage() {
        // Arrange
        let statuses: [APIStatus] = [.online, .offline, .checking]

        // Act & Assert
        for status in statuses {
            let text: String
            switch status {
            case .online:
                text = "Connected"
            case .offline:
                text = "Disconnected"
            case .checking:
                text = "Checking..."
            }
            #expect(text == status.text)
        }
    }
}
