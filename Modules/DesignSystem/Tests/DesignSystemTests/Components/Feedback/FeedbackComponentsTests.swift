//
//  FeedbackComponentsTests.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 08/12/25.
//

@testable import DesignSystem
import SwiftUI
import Testing
import XCTest

// MARK: - EmptyStateComponent Tests

@Suite("EmptyStateComponent Tests")
@MainActor
struct EmptyStateComponentTests {

    @Test("EmptyStateComponent should be instantiable with basic parameters")
    func testBasicInitialization() {
        let component = EmptyStateComponent(
            icon: "magnifyingglass",
            title: "No Results",
            message: "Try a different search term"
        )

        #expect(type(of: component) == EmptyStateComponent.self)
    }

    @Test("EmptyStateComponent should be instantiable with all parameters")
    func testFullInitialization() {
        let component = EmptyStateComponent(
            icon: "magnifyingglass",
            title: "No Results",
            message: "Try a different search term",
            iconSize: 100
        )

        #expect(type(of: component) == EmptyStateComponent.self)
    }

    @Test("EmptyStateComponent should conform to View")
    func testViewConformance() {
        let component = EmptyStateComponent(
            icon: "star",
            title: "Empty",
            message: "Nothing here"
        )
        let _: any View = component
        #expect(true)
    }

    @Test("EmptyStateComponent should accept various icons")
    func testVariousIcons() {
        let icons = ["magnifyingglass", "star", "heart", "bookmark", "folder"]

        for icon in icons {
            let component = EmptyStateComponent(icon: icon, title: "Test", message: "Message")
            #expect(type(of: component) == EmptyStateComponent.self)
        }
    }

    @Test("EmptyStateComponent should work with default iconSize")
    func testDefaultIconSize() {
        let component = EmptyStateComponent(icon: "star", title: "Test", message: "Message")
        #expect(type(of: component) == EmptyStateComponent.self)
    }

    @Test("EmptyStateComponent should work with action button")
    func testWithActionButton() {
        var actionCalled = false
        let component = EmptyStateComponent(
            icon: "star",
            title: "Test",
            message: "Message",
            actionTitle: "Retry",
            action: { actionCalled = true }
        )
        #expect(type(of: component) == EmptyStateComponent.self)
        #expect(actionCalled == false)
    }
}

// MARK: - ErrorComponent Tests

@Suite("ErrorComponent Tests")
@MainActor
struct ErrorComponentTests {

    @Test("ErrorComponent should be instantiable with message only")
    func testMinimalInitialization() {
        let component = ErrorComponent(message: "Something went wrong")
        #expect(type(of: component) == ErrorComponent.self)
    }

    @Test("ErrorComponent should be instantiable with all parameters")
    func testFullInitialization() {
        var retryCalled = false
        let component = ErrorComponent(
            title: "Error",
            message: "Failed to load data",
            retryAction: { retryCalled = true }
        )

        #expect(type(of: component) == ErrorComponent.self)
        #expect(retryCalled == false)
    }

    @Test("ErrorComponent should conform to View")
    func testViewConformance() {
        let component = ErrorComponent(message: "Error")
        let _: any View = component
        #expect(true)
    }

    @Test("ErrorComponent should work with default title")
    func testDefaultTitle() {
        let component = ErrorComponent(message: "Test message")
        #expect(type(of: component) == ErrorComponent.self)
    }

    @Test("ErrorComponent retryAction should not be called on init")
    func testRetryActionNotCalledOnInit() {
        var callCount = 0
        _ = ErrorComponent(message: "Error") {
            callCount += 1
        }

        #expect(callCount == 0)
    }

    @Test("ErrorComponent should work without retry action")
    func testWithoutRetryAction() {
        let component = ErrorComponent(
            title: "Error",
            message: "Something went wrong",
            retryAction: nil
        )
        #expect(type(of: component) == ErrorComponent.self)
    }
}

// MARK: - LoadingComponent Tests

@Suite("LoadingComponent Tests")
@MainActor
struct LoadingComponentTests {

    @Test("LoadingComponent should be instantiable without message")
    func testInitializationWithoutMessage() {
        let component = LoadingComponent()
        #expect(type(of: component) == LoadingComponent.self)
    }

    @Test("LoadingComponent should be instantiable with message")
    func testInitializationWithMessage() {
        let component = LoadingComponent(message: "Loading...")
        #expect(type(of: component) == LoadingComponent.self)
    }

    @Test("LoadingComponent should conform to View")
    func testViewConformance() {
        let component = LoadingComponent()
        let _: any View = component
        #expect(true)
    }

    @Test("LoadingComponent should accept various messages")
    func testVariousMessages() {
        let messages = ["Loading...", "Please wait", "Fetching data", ""]

        for message in messages {
            let component = LoadingComponent(message: message)
            #expect(type(of: component) == LoadingComponent.self)
        }
    }

    @Test("LoadingComponent should work with nil message")
    func testNilMessage() {
        let component = LoadingComponent(message: nil)
        #expect(type(of: component) == LoadingComponent.self)
    }
}

// MARK: - FullScreenLoadingComponent Tests

@Suite("FullScreenLoadingComponent Tests")
@MainActor
struct FullScreenLoadingComponentTests {

    @Test("FullScreenLoadingComponent should be instantiable with default parameters")
    func testDefaultInitialization() {
        let component = FullScreenLoadingComponent()
        #expect(type(of: component) == FullScreenLoadingComponent.self)
    }

    @Test("FullScreenLoadingComponent should be instantiable with logoImage")
    func testInitializationWithLogoImage() {
        let component = FullScreenLoadingComponent(logoImage: "CustomLogo")
        #expect(type(of: component) == FullScreenLoadingComponent.self)
    }

    @Test("FullScreenLoadingComponent should be instantiable with loadingText")
    func testInitializationWithLoadingText() {
        let component = FullScreenLoadingComponent(loadingText: "Processing...")
        #expect(type(of: component) == FullScreenLoadingComponent.self)
    }

    @Test("FullScreenLoadingComponent should be instantiable with all parameters")
    func testFullInitialization() {
        var backCalled = false
        let component = FullScreenLoadingComponent(
            logoImage: "Loading",
            loadingText: "Processing...",
            onBack: { backCalled = true }
        )

        #expect(type(of: component) == FullScreenLoadingComponent.self)
        #expect(backCalled == false)
    }

    @Test("FullScreenLoadingComponent should conform to View")
    func testViewConformance() {
        let component = FullScreenLoadingComponent()
        let _: any View = component
        #expect(true)
    }

    @Test("FullScreenLoadingComponent should accept custom loading text")
    func testCustomLoadingText() {
        let component = FullScreenLoadingComponent(loadingText: "Custom Loading...")
        #expect(type(of: component) == FullScreenLoadingComponent.self)
    }

    @Test("FullScreenLoadingComponent onBack should not be called on init")
    func testOnBackNotCalledOnInit() {
        var callCount = 0
        _ = FullScreenLoadingComponent(onBack: { callCount += 1 })
        #expect(callCount == 0)
    }
}

// MARK: - ManagedFullScreenLoadingComponent Tests

@Suite("ManagedFullScreenLoadingComponent Tests")
@MainActor
struct ManagedFullScreenLoadingComponentTests {

    @Test("ManagedFullScreenLoadingComponent should be instantiable")
    func testInitialization() {
        let component = ManagedFullScreenLoadingComponent()
        #expect(type(of: component) == ManagedFullScreenLoadingComponent.self)
    }

    @Test("ManagedFullScreenLoadingComponent should be instantiable with nil context")
    func testInitializationWithNilContext() {
        let component = ManagedFullScreenLoadingComponent(context: nil)
        #expect(type(of: component) == ManagedFullScreenLoadingComponent.self)
    }

    @Test("ManagedFullScreenLoadingComponent should be instantiable with onBack")
    func testInitializationWithOnBack() {
        var backCalled = false
        let component = ManagedFullScreenLoadingComponent(onBack: { backCalled = true })
        #expect(type(of: component) == ManagedFullScreenLoadingComponent.self)
        #expect(backCalled == false)
    }

    @Test("ManagedFullScreenLoadingComponent should conform to View")
    func testViewConformance() {
        let component = ManagedFullScreenLoadingComponent()
        let _: any View = component
        #expect(true)
    }
}

// MARK: - FullScreenLoadingModifier Tests

@Suite("FullScreenLoadingModifier Tests")
@MainActor
struct FullScreenLoadingModifierTests {

    @Test("FullScreenLoadingModifier should be instantiable with isLoading true")
    func testInitializationWithLoadingTrue() {
        let modifier = FullScreenLoadingModifier(isLoading: true)
        #expect(type(of: modifier) == FullScreenLoadingModifier.self)
    }

    @Test("FullScreenLoadingModifier should be instantiable with isLoading false")
    func testInitializationWithLoadingFalse() {
        let modifier = FullScreenLoadingModifier(isLoading: false)
        #expect(type(of: modifier) == FullScreenLoadingModifier.self)
    }

    @Test("FullScreenLoadingModifier should be instantiable with all parameters")
    func testFullInitialization() {
        var backCalled = false
        let modifier = FullScreenLoadingModifier(
            isLoading: true,
            message: "Loading...",
            onBack: { backCalled = true }
        )
        #expect(type(of: modifier) == FullScreenLoadingModifier.self)
        #expect(backCalled == false)
    }

    @Test("FullScreenLoadingModifier should conform to ViewModifier")
    func testViewModifierConformance() {
        let modifier = FullScreenLoadingModifier(isLoading: false)
        let _: any ViewModifier = modifier
        #expect(true)
    }

    @Test("FullScreenLoadingModifier should work with custom message")
    func testWithCustomMessage() {
        let modifier = FullScreenLoadingModifier(isLoading: true, message: "Please wait...")
        #expect(type(of: modifier) == FullScreenLoadingModifier.self)
    }
}

// MARK: - View Extension fullScreenLoading Tests

@Suite("View Extension fullScreenLoading Tests")
@MainActor
struct ViewExtensionFullScreenLoadingTests {

    @Test("fullScreenLoading extension should be available with Bool")
    func testExtensionAvailability() {
        let view = Text("Test").fullScreenLoading(isLoading: true)
        #expect(true)
        _ = view
    }

    @Test("fullScreenLoading should accept isLoading true")
    func testWithLoadingTrue() {
        let view = Text("Test").fullScreenLoading(isLoading: true)
        #expect(true)
        _ = view
    }

    @Test("fullScreenLoading should accept isLoading false")
    func testWithLoadingFalse() {
        let view = Text("Test").fullScreenLoading(isLoading: false)
        #expect(true)
        _ = view
    }

    @Test("fullScreenLoading should accept custom message")
    func testWithCustomMessage() {
        let view = Text("Test").fullScreenLoading(isLoading: true, message: "Please wait...")
        #expect(true)
        _ = view
    }

    @Test("fullScreenLoading should accept onBack callback")
    func testWithOnBack() {
        var backCalled = false
        let view = Text("Test").fullScreenLoading(
            isLoading: true,
            onBack: { backCalled = true }
        )
        #expect(backCalled == false)
        _ = view
    }

    @Test("managedFullScreenLoading extension should be available")
    func testManagedExtensionAvailability() {
        let view = Text("Test").managedFullScreenLoading()
        #expect(true)
        _ = view
    }

    @Test("managedFullScreenLoading should accept onBack callback")
    func testManagedWithOnBack() {
        var backCalled = false
        let view = Text("Test").managedFullScreenLoading(onBack: { backCalled = true })
        #expect(backCalled == false)
        _ = view
    }
}

// MARK: - XCTest Feedback Components Tests

@MainActor
class FeedbackComponentsXCTests: XCTestCase {

    // MARK: - EmptyStateComponent Tests

    func testEmptyStateBasicInit() {
        let component = EmptyStateComponent(
            icon: "magnifyingglass",
            title: "No Results",
            message: "Try again"
        )

        XCTAssertNotNil(component)
    }

    func testEmptyStateWithIconSize() {
        let component = EmptyStateComponent(
            icon: "star",
            title: "Empty",
            message: "Nothing here",
            iconSize: 120
        )

        XCTAssertNotNil(component)
    }

    func testEmptyStateViewBody() {
        let component = EmptyStateComponent(
            icon: "star",
            title: "Empty",
            message: "Nothing"
        )
        let body = component.body

        XCTAssertNotNil(body)
    }

    // MARK: - ErrorComponent Tests

    func testErrorComponentMinimalInit() {
        let component = ErrorComponent(message: "Error occurred")
        XCTAssertNotNil(component)
    }

    func testErrorComponentFullInit() {
        let component = ErrorComponent(
            title: "Oops!",
            message: "Something went wrong",
            retryAction: {}
        )

        XCTAssertNotNil(component)
    }

    func testErrorComponentRetryNotCalledOnInit() {
        var retryCalled = false

        _ = ErrorComponent(message: "Error") {
            retryCalled = true
        }

        XCTAssertFalse(retryCalled)
    }

    func testErrorComponentViewBody() {
        let component = ErrorComponent(message: "Error")
        let body = component.body

        XCTAssertNotNil(body)
    }

    // MARK: - LoadingComponent Tests

    func testLoadingComponentDefaultInit() {
        let component = LoadingComponent()
        XCTAssertNotNil(component)
    }

    func testLoadingComponentWithMessage() {
        let component = LoadingComponent(message: "Loading data...")
        XCTAssertNotNil(component)
    }

    func testLoadingComponentViewBody() {
        let component = LoadingComponent()
        let body = component.body

        XCTAssertNotNil(body)
    }

    // MARK: - FullScreenLoadingComponent Tests

    func testFullScreenLoadingDefaultInit() {
        let component = FullScreenLoadingComponent()
        XCTAssertNotNil(component)
    }

    func testFullScreenLoadingWithLogoImage() {
        let component = FullScreenLoadingComponent(logoImage: "CustomLogo")
        XCTAssertNotNil(component)
    }

    func testFullScreenLoadingWithLoadingText() {
        let component = FullScreenLoadingComponent(loadingText: "Processing...")
        XCTAssertNotNil(component)
    }

    func testFullScreenLoadingFullInit() {
        let component = FullScreenLoadingComponent(
            logoImage: "Loading",
            loadingText: "Processing...",
            onBack: {}
        )

        XCTAssertNotNil(component)
    }

    func testFullScreenLoadingViewBody() {
        let component = FullScreenLoadingComponent()
        let body = component.body

        XCTAssertNotNil(body)
    }

    // MARK: - ManagedFullScreenLoadingComponent Tests

    func testManagedFullScreenLoadingDefaultInit() {
        let component = ManagedFullScreenLoadingComponent()
        XCTAssertNotNil(component)
    }

    func testManagedFullScreenLoadingWithOnBack() {
        let component = ManagedFullScreenLoadingComponent(onBack: {})
        XCTAssertNotNil(component)
    }

    // MARK: - FullScreenLoadingModifier Tests

    func testFullScreenLoadingModifierInit() {
        let modifier = FullScreenLoadingModifier(isLoading: true)
        XCTAssertNotNil(modifier)
    }

    func testFullScreenLoadingModifierWithMessage() {
        let modifier = FullScreenLoadingModifier(isLoading: true, message: "Loading...")
        XCTAssertNotNil(modifier)
    }

    func testFullScreenLoadingModifierApplication() {
        let view = Text("Test").fullScreenLoading(isLoading: true)
        XCTAssertNotNil(view)
    }

    func testFullScreenLoadingModifierWithText() {
        let view = Text("Test").fullScreenLoading(
            isLoading: true,
            message: "Please wait..."
        )
        XCTAssertNotNil(view)
    }

    func testFullScreenLoadingModifierWithAllParameters() {
        let view = Text("Test").fullScreenLoading(
            isLoading: true,
            message: "Please wait...",
            onBack: {}
        )
        XCTAssertNotNil(view)
    }

    // MARK: - View Extension Tests

    func testManagedFullScreenLoadingExtension() {
        let view = Text("Test").managedFullScreenLoading()
        XCTAssertNotNil(view)
    }

    func testManagedFullScreenLoadingExtensionWithOnBack() {
        let view = Text("Test").managedFullScreenLoading(onBack: {})
        XCTAssertNotNil(view)
    }
}
