//
//  FavoritesNotificationTests.swift
//  Favorites
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//

@testable import Favorites
import Combine
import Foundation
import Testing
import XCTest

// MARK: - FavoritesNotification Name Tests

@Suite("FavoritesNotification Name Tests")
struct FavoritesNotificationNameTests {

    @Test("favoritesDidChange should have correct raw value")
    func testFavoritesDidChangeRawValue() {
        // Act
        let notificationName = Notification.Name.favoritesDidChange

        // Assert
        #expect(notificationName.rawValue == "favoritesDidChange")
    }

    @Test("favoritesDidChange should be accessible")
    func testFavoritesDidChangeAccessible() {
        // Act
        let _ = Notification.Name.favoritesDidChange

        // Assert - Se compila, está acessível
        #expect(true)
    }

    @Test("favoritesDidChange should be a static property")
    func testFavoritesDidChangeIsStatic() {
        // Act
        let name1 = Notification.Name.favoritesDidChange
        let name2 = Notification.Name.favoritesDidChange

        // Assert - Devem ser iguais pois é estático
        #expect(name1 == name2)
    }
}

// MARK: - FavoritesNotification Equatable Tests

@Suite("FavoritesNotification Equatable Tests")
struct FavoritesNotificationEquatableTests {

    @Test("Same notification names should be equal")
    func testSameNotificationNamesEqual() {
        // Arrange
        let name1 = Notification.Name.favoritesDidChange
        let name2 = Notification.Name.favoritesDidChange

        // Assert
        #expect(name1 == name2)
    }

    @Test("Different notification names should not be equal")
    func testDifferentNotificationNamesNotEqual() {
        // Arrange
        let favoritesName = Notification.Name.favoritesDidChange
        let otherName = Notification.Name("otherNotification")

        // Assert
        #expect(favoritesName != otherName)
    }

    @Test("Notification name should equal itself")
    func testNotificationNameEqualsItself() {
        // Arrange
        let name = Notification.Name.favoritesDidChange

        // Assert
        #expect(name == name)
    }
}

// MARK: - FavoritesNotification Hashable Tests

@Suite("FavoritesNotification Hashable Tests")
struct FavoritesNotificationHashableTests {

    @Test("Can be used in Set")
    func testCanBeUsedInSet() {
        // Act
        var set = Set<Notification.Name>()
        set.insert(.favoritesDidChange)
        set.insert(.favoritesDidChange) // Duplicate

        // Assert
        #expect(set.count == 1)
        #expect(set.contains(.favoritesDidChange))
    }

    @Test("Can be used as Dictionary key")
    func testCanBeUsedAsDictionaryKey() {
        // Act
        var dict = [Notification.Name: String]()
        dict[.favoritesDidChange] = "Favorites Changed"

        // Assert
        #expect(dict[.favoritesDidChange] == "Favorites Changed")
    }

    @Test("Hash should be consistent")
    func testConsistentHash() {
        // Arrange
        let name1 = Notification.Name.favoritesDidChange
        let name2 = Notification.Name.favoritesDidChange

        // Assert
        #expect(name1.hashValue == name2.hashValue)
    }
}

// MARK: - FavoritesNotification Post Tests

@Suite("FavoritesNotification Post Tests")
struct FavoritesNotificationPostTests {

    @Test("Can post favoritesDidChange notification")
    func testCanPostNotification() {
        // Act - Se não lançar erro, passou
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)

        // Assert
        #expect(true)
    }

    @Test("Can post notification with userInfo")
    func testCanPostNotificationWithUserInfo() {
        // Act
        let userInfo: [String: Any] = ["characterId": 123, "action": "added"]
        NotificationCenter.default.post(
            name: .favoritesDidChange,
            object: nil,
            userInfo: userInfo
        )

        // Assert
        #expect(true)
    }
}

// MARK: - FavoritesNotification Observer Tests

@Suite("FavoritesNotification Observer Tests", .serialized)
struct FavoritesNotificationObserverTests {

    @Test("Can add observer for favoritesDidChange")
    func testCanAddObserver() async {
        // Arrange
        let expectation = ConfirmationToken()
        var received = false

        // Act
        let observer = NotificationCenter.default.addObserver(
            forName: .favoritesDidChange,
            object: nil,
            queue: .main
        ) { _ in
            received = true
            expectation.confirm()
        }

        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)

        // Aguarda um pouco para a notificação ser processada
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Cleanup
        NotificationCenter.default.removeObserver(observer)

        // Assert
        #expect(received == true)
    }

    @Test("Observer receives correct notification")
    func testObserverReceivesCorrectNotification() async {
        // Arrange
        var receivedName: Notification.Name?

        let observer = NotificationCenter.default.addObserver(
            forName: .favoritesDidChange,
            object: nil,
            queue: .main
        ) { notification in
            receivedName = notification.name
        }

        // Act
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)

        // Aguarda um pouco para a notificação ser processada
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Cleanup
        NotificationCenter.default.removeObserver(observer)

        // Assert
        #expect(receivedName == .favoritesDidChange)
    }

    @Test("Observer receives userInfo")
    func testObserverReceivesUserInfo() async {
        // Arrange
        var receivedUserInfo: [AnyHashable: Any]?
        let expectedCharacterId = 42

        let observer = NotificationCenter.default.addObserver(
            forName: .favoritesDidChange,
            object: nil,
            queue: .main
        ) { notification in
            receivedUserInfo = notification.userInfo
        }

        // Act
        NotificationCenter.default.post(
            name: .favoritesDidChange,
            object: nil,
            userInfo: ["characterId": expectedCharacterId]
        )

        // Aguarda um pouco para a notificação ser processada
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Cleanup
        NotificationCenter.default.removeObserver(observer)

        // Assert
        #expect(receivedUserInfo?["characterId"] as? Int == expectedCharacterId)
    }
}

// MARK: - Helper for Async Tests

private class ConfirmationToken {
    private var _confirmed = false

    func confirm() {
        _confirmed = true
    }

    var isConfirmed: Bool {
        _confirmed
    }
}

// MARK: - XCTest Integration Tests

class FavoritesNotificationXCTests: XCTestCase {

    func testNotificationNameRawValue() {
        XCTAssertEqual(Notification.Name.favoritesDidChange.rawValue, "favoritesDidChange")
    }

    func testNotificationNameEquality() {
        let name1 = Notification.Name.favoritesDidChange
        let name2 = Notification.Name.favoritesDidChange
        XCTAssertEqual(name1, name2)
    }

    func testNotificationNameHashable() {
        var set = Set<Notification.Name>()
        set.insert(.favoritesDidChange)
        set.insert(.favoritesDidChange)
        XCTAssertEqual(set.count, 1)
    }

    func testCanPostNotification() {
        // Act - Se não lançar erro, passou
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)

        // Assert
        XCTAssertTrue(true)
    }

    func testObserverReceivesNotification() {
        // Arrange
        let expectation = XCTestExpectation(description: "Notification received")
        var received = false

        let observer = NotificationCenter.default.addObserver(
            forName: .favoritesDidChange,
            object: nil,
            queue: .main
        ) { _ in
            received = true
            expectation.fulfill()
        }

        // Act
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(received)

        // Cleanup
        NotificationCenter.default.removeObserver(observer)
    }

    func testObserverReceivesUserInfo() {
        // Arrange
        let expectation = XCTestExpectation(description: "UserInfo received")
        var receivedCharacterId: Int?

        let observer = NotificationCenter.default.addObserver(
            forName: .favoritesDidChange,
            object: nil,
            queue: .main
        ) { notification in
            receivedCharacterId = notification.userInfo?["characterId"] as? Int
            expectation.fulfill()
        }

        // Act
        NotificationCenter.default.post(
            name: .favoritesDidChange,
            object: nil,
            userInfo: ["characterId": 42]
        )

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedCharacterId, 42)

        // Cleanup
        NotificationCenter.default.removeObserver(observer)
    }

    func testCombinePublisher() {
        // Arrange
        let expectation = XCTestExpectation(description: "Publisher received")
        var cancellables = Set<AnyCancellable>()
        var received = false

        NotificationCenter.default
            .publisher(for: .favoritesDidChange)
            .sink { _ in
                received = true
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Act
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(received)
    }
}
