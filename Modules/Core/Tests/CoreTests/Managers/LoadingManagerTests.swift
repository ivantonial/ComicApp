//
//  LoadingManagerTests.swift
//  Core
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import Core
import Combine
import Foundation
import Testing
import XCTest

// MARK: - LoadingManager Tests

@Suite("LoadingManager Tests", .serialized)
struct LoadingManagerTests {

    // MARK: - Singleton Tests

    @Test("LoadingManager should be a singleton")
    @MainActor
    func testSingleton() {
        let manager1 = LoadingManager.shared
        let manager2 = LoadingManager.shared

        #expect(manager1 === manager2)
    }

    // MARK: - Initial State Tests

    @Test("LoadingManager should have correct initial state")
    @MainActor
    func testInitialState() {
        let manager = LoadingManager.shared
        manager.forceStopAllLoading() // Reset state

        #expect(manager.isLoading == false)
        #expect(manager.loadingMessage == "Loading")
        #expect(manager.currentLoadingContext == nil)
    }

    // MARK: - Start Loading Tests

    @Test("StartLoading should set isLoading to true")
    @MainActor
    func testStartLoadingSetsIsLoading() {
        let manager = LoadingManager.shared
        manager.forceStopAllLoading()

        manager.startLoading(context: .general)

        #expect(manager.isLoading == true)

        manager.forceStopAllLoading()
    }

    @Test("StartLoading should set current context")
    @MainActor
    func testStartLoadingSetsContext() {
        let manager = LoadingManager.shared
        manager.forceStopAllLoading()

        manager.startLoading(context: .characterList)

        #expect(manager.currentLoadingContext == .characterList)

        manager.forceStopAllLoading()
    }

    @Test("StartLoading should set default message from context")
    @MainActor
    func testStartLoadingSetsDefaultMessage() {
        let manager = LoadingManager.shared
        manager.forceStopAllLoading()

        manager.startLoading(context: .characterList)

        #expect(manager.loadingMessage == LoadingManager.LoadingContext.characterList.message)

        manager.forceStopAllLoading()
    }

    @Test("StartLoading should use custom message when provided")
    @MainActor
    func testStartLoadingCustomMessage() {
        let manager = LoadingManager.shared
        manager.forceStopAllLoading()

        manager.startLoading(context: .general, customMessage: "Custom loading...")

        #expect(manager.loadingMessage == "Custom loading...")

        manager.forceStopAllLoading()
    }

    // MARK: - Stop Loading Tests

    @Test("StopLoading should set isLoading to false when count reaches zero")
    @MainActor
    func testStopLoadingSetsIsLoadingFalse() {
        let manager = LoadingManager.shared
        manager.forceStopAllLoading()

        manager.startLoading(context: .general)
        manager.stopLoading()

        #expect(manager.isLoading == false)
    }

    @Test("StopLoading should clear context when count reaches zero")
    @MainActor
    func testStopLoadingClearsContext() {
        let manager = LoadingManager.shared
        manager.forceStopAllLoading()

        manager.startLoading(context: .characterDetail)
        manager.stopLoading()

        #expect(manager.currentLoadingContext == nil)
    }

    @Test("StopLoading should reset message when count reaches zero")
    @MainActor
    func testStopLoadingResetsMessage() {
        let manager = LoadingManager.shared
        manager.forceStopAllLoading()

        manager.startLoading(context: .general, customMessage: "Custom")
        manager.stopLoading()

        #expect(manager.loadingMessage == "Loading")
    }

    // MARK: - Loading Count Tests

    @Test("Multiple startLoading calls should increment count")
    @MainActor
    func testMultipleStartLoadingIncrements() {
        let manager = LoadingManager.shared
        manager.forceStopAllLoading()

        manager.startLoading(context: .general)
        manager.startLoading(context: .characterList)
        manager.startLoading(context: .comicsList)

        // Deve permanecer loading até todos os stops
        #expect(manager.isLoading == true)

        manager.stopLoading()
        #expect(manager.isLoading == true)

        manager.stopLoading()
        #expect(manager.isLoading == true)

        manager.stopLoading()
        #expect(manager.isLoading == false)
    }

    @Test("StopLoading should not go below zero")
    @MainActor
    func testStopLoadingNotBelowZero() {
        let manager = LoadingManager.shared
        manager.forceStopAllLoading()

        // Stop without start
        manager.stopLoading()
        manager.stopLoading()
        manager.stopLoading()

        // Should still be false, not crash
        #expect(manager.isLoading == false)
    }

    // MARK: - Force Stop Tests

    @Test("ForceStopAllLoading should reset everything")
    @MainActor
    func testForceStopAllLoading() {
        let manager = LoadingManager.shared

        manager.startLoading(context: .general)
        manager.startLoading(context: .characterList)
        manager.startLoading(context: .search)

        manager.forceStopAllLoading()

        #expect(manager.isLoading == false)
        #expect(manager.currentLoadingContext == nil)
        #expect(manager.loadingMessage == "Loading")
    }

    // MARK: - Loading Context Tests

    @Test("LoadingContext should have correct messages")
    func testLoadingContextMessages() {
        #expect(LoadingManager.LoadingContext.characterList.message == "Loading heroes...")
        #expect(LoadingManager.LoadingContext.characterDetail.message == "Loading character...")
        #expect(LoadingManager.LoadingContext.comicsList.message == "Loading comics...")
        #expect(LoadingManager.LoadingContext.favorites.message == "Loading favorites...")
        #expect(LoadingManager.LoadingContext.search.message == "Searching...")
        #expect(LoadingManager.LoadingContext.settings.message == "Loading settings...")
        #expect(LoadingManager.LoadingContext.general.message == "Loading...")
    }

    @Test("LoadingContext rawValues should be correct")
    func testLoadingContextRawValues() {
        #expect(LoadingManager.LoadingContext.characterList.rawValue == "Loading heroes")
        #expect(LoadingManager.LoadingContext.characterDetail.rawValue == "Loading character")
        #expect(LoadingManager.LoadingContext.comicsList.rawValue == "Loading comics")
        #expect(LoadingManager.LoadingContext.favorites.rawValue == "Loading favorites")
        #expect(LoadingManager.LoadingContext.search.rawValue == "Searching")
        #expect(LoadingManager.LoadingContext.settings.rawValue == "Loading settings")
        #expect(LoadingManager.LoadingContext.general.rawValue == "Loading")
    }
}

// MARK: - WithLoading Tests

@Suite("LoadingManager WithLoading Tests", .serialized)
struct LoadingManagerWithLoadingTests {

    @Test("WithLoading should set loading during operation")
    @MainActor
    func testWithLoadingSetsLoading() async throws {
        let manager = LoadingManager.shared
        manager.forceStopAllLoading()

        var wasLoading = false

        _ = try await manager.withLoading(context: .general) {
            wasLoading = manager.isLoading
            return "result"
        }

        #expect(wasLoading == true)
        #expect(manager.isLoading == false)
    }

    @Test("WithLoading should return operation result")
    @MainActor
    func testWithLoadingReturnsResult() async throws {
        let manager = LoadingManager.shared
        manager.forceStopAllLoading()

        let result = try await manager.withLoading(context: .general) {
            return 42
        }

        #expect(result == 42)
    }

    @Test("WithLoading should stop loading on error")
    @MainActor
    func testWithLoadingStopsOnError() async {
        let manager = LoadingManager.shared
        manager.forceStopAllLoading()

        do {
            _ = try await manager.withLoading(context: .general) {
                throw TestError.testError
            }
        } catch {
            // Expected
        }

        #expect(manager.isLoading == false)
    }

    @Test("WithLoading should use custom message")
    @MainActor
    func testWithLoadingCustomMessage() async throws {
        let manager = LoadingManager.shared
        manager.forceStopAllLoading()

        var capturedMessage = ""

        _ = try await manager.withLoading(context: .general, customMessage: "Custom message") {
            capturedMessage = manager.loadingMessage
            return true
        }

        #expect(capturedMessage == "Custom message")
    }
}

// MARK: - Test Helpers

private enum TestError: Error {
    case testError
}

// MARK: - XCTest Integration Tests

class LoadingManagerXCTests: XCTestCase {

    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            LoadingManager.shared.forceStopAllLoading()
        }
    }

    override func tearDown() async throws {
        await MainActor.run {
            LoadingManager.shared.forceStopAllLoading()
        }
        try await super.tearDown()
    }

    @MainActor
    func testObservableObjectCompliance() {
        let manager = LoadingManager.shared

        // LoadingManager deve ser ObservableObject
        let cancellable = manager.objectWillChange.sink { _ in }
        XCTAssertNotNil(cancellable)
        cancellable.cancel()
    }

    @MainActor
    func testPublishedProperties() {
        let manager = LoadingManager.shared

        var isLoadingChanges = 0
        let cancellable = manager.$isLoading.sink { _ in
            isLoadingChanges += 1
        }

        manager.startLoading(context: .general)
        manager.stopLoading()

        // Deve ter recebido mudanças
        XCTAssertGreaterThan(isLoadingChanges, 0)
        cancellable.cancel()
    }

    @MainActor
    func testConcurrentLoadingOperations() async {
        let manager = LoadingManager.shared

        // Em Swift 6, withTaskGroup + @MainActor in causa erro de isolation checker
        // Executar operações sequencialmente no MainActor
        for i in 0..<5 {
            manager.startLoading(context: .general, customMessage: "Loading \(i)")
            try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
            manager.stopLoading()
        }

        // Após todas as operações, deve estar false
        XCTAssertFalse(manager.isLoading)
    }

    @MainActor
    func testWithTemporaryLoading() {
        let manager = LoadingManager.shared
        let expectation = XCTestExpectation(description: "Temporary loading completes")

        var operationExecuted = false

        manager.withTemporaryLoading(context: .general, duration: 0.1) {
            operationExecuted = true
        }

        XCTAssertTrue(operationExecuted)
        XCTAssertTrue(manager.isLoading)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertFalse(manager.isLoading)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
