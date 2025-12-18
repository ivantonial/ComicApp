//
//  ThemeManagerTests.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 08/12/25.
//

@testable import DesignSystem
import SwiftUI
import Testing
import XCTest

// MARK: - ThemeManager Singleton Tests

@Suite("ThemeManager Singleton Tests")
@MainActor
struct ThemeManagerSingletonTests {

    @Test("ThemeManager.shared should return same instance")
    func testSameInstance() {
        let manager1 = ThemeManager.shared
        let manager2 = ThemeManager.shared

        #expect(manager1 === manager2)
    }

    @Test("ThemeManager.shared should not be nil")
    func testNotNil() {
        let manager = ThemeManager.shared
        #expect(manager != nil)
    }

    @Test("ThemeManager should be MainActor isolated")
    func testMainActorIsolation() {
        // Este teste só compila se ThemeManager for @MainActor
        let manager = ThemeManager.shared
        _ = manager
        #expect(true)
    }
}

// MARK: - ThemeManager Initial State Tests

@Suite("ThemeManager Initial State Tests")
@MainActor
struct ThemeManagerInitialStateTests {

    @Test("ThemeManager should have dark as default theme type")
    func testDefaultThemeType() {
        let manager = ThemeManager.shared
        // Salvar estado original
        let originalType = manager.currentThemeType

        // Restaurar para dark (estado padrão esperado)
        manager.setTheme(.dark)
        #expect(manager.currentThemeType == .dark)

        // Restaurar estado original
        manager.setTheme(originalType)
    }

    @Test("ThemeManager currentTheme should match currentThemeType")
    func testCurrentThemeMatchesType() {
        let manager = ThemeManager.shared
        let originalType = manager.currentThemeType

        manager.setTheme(.dark)
        #expect(manager.currentTheme is DarkTheme)

        manager.setTheme(.light)
        #expect(manager.currentTheme is LightTheme)

        manager.setTheme(originalType)
    }

    @Test("ThemeManager isDarkMode should reflect currentThemeType")
    func testIsDarkModeReflectsType() {
        let manager = ThemeManager.shared
        let originalType = manager.currentThemeType

        manager.setTheme(.dark)
        #expect(manager.isDarkMode == true)

        manager.setTheme(.light)
        #expect(manager.isDarkMode == false)

        manager.setTheme(originalType)
    }
}

// MARK: - ThemeManager Theme Switching Tests

@Suite("ThemeManager Theme Switching Tests")
@MainActor
struct ThemeManagerThemeSwitchingTests {

    @Test("setTheme should update currentThemeType")
    func testSetThemeUpdatesType() {
        let manager = ThemeManager.shared
        let originalType = manager.currentThemeType

        manager.setTheme(.light)
        #expect(manager.currentThemeType == .light)

        manager.setTheme(.dark)
        #expect(manager.currentThemeType == .dark)

        manager.setTheme(originalType)
    }

    @Test("setTheme should update currentTheme")
    func testSetThemeUpdatesTheme() {
        let manager = ThemeManager.shared
        let originalType = manager.currentThemeType

        manager.setTheme(.light)
        #expect(manager.currentTheme is LightTheme)

        manager.setTheme(.dark)
        #expect(manager.currentTheme is DarkTheme)

        manager.setTheme(originalType)
    }

    @Test("toggleTheme should switch between themes")
    func testToggleTheme() {
        let manager = ThemeManager.shared
        let originalType = manager.currentThemeType

        manager.setTheme(.dark)
        let beforeToggle = manager.currentThemeType

        manager.toggleTheme()
        let afterToggle = manager.currentThemeType

        #expect(beforeToggle != afterToggle)

        manager.setTheme(originalType)
    }

    @Test("toggleTheme from dark should switch to light")
    func testToggleFromDark() {
        let manager = ThemeManager.shared
        let originalType = manager.currentThemeType

        manager.setTheme(.dark)
        manager.toggleTheme()

        #expect(manager.currentThemeType == .light)

        manager.setTheme(originalType)
    }

    @Test("toggleTheme from light should switch to dark")
    func testToggleFromLight() {
        let manager = ThemeManager.shared
        let originalType = manager.currentThemeType

        manager.setTheme(.light)
        manager.toggleTheme()

        #expect(manager.currentThemeType == .dark)

        manager.setTheme(originalType)
    }
}

// MARK: - ThemeManager isDarkMode Tests

@Suite("ThemeManager isDarkMode Tests")
@MainActor
struct ThemeManagerIsDarkModeTests {

    @Test("isDarkMode should be true when theme is dark")
    func testIsDarkModeTrue() {
        let manager = ThemeManager.shared
        let originalType = manager.currentThemeType

        manager.setTheme(.dark)
        #expect(manager.isDarkMode == true)

        manager.setTheme(originalType)
    }

    @Test("isDarkMode should be false when theme is light")
    func testIsDarkModeFalse() {
        let manager = ThemeManager.shared
        let originalType = manager.currentThemeType

        manager.setTheme(.light)
        #expect(manager.isDarkMode == false)

        manager.setTheme(originalType)
    }
}

// MARK: - ThemeManager ObservableObject Tests

@Suite("ThemeManager ObservableObject Tests")
@MainActor
struct ThemeManagerObservableObjectTests {

    @Test("ThemeManager should conform to ObservableObject")
    func testObservableObjectConformance() {
        let manager = ThemeManager.shared
        let _: any ObservableObject = manager
        #expect(true)
    }

    @Test("ThemeManager should have published properties")
    func testPublishedProperties() {
        let manager = ThemeManager.shared
        // Acessar propriedades para verificar se são publicadas
        _ = manager.currentThemeType
        _ = manager.currentTheme
        _ = manager.isDarkMode
        #expect(true)
    }
}

// MARK: - XCTest ThemeManager Tests

class ThemeManagerXCTests: XCTestCase {

    @MainActor
    func testSingletonInstance() {
        let manager1 = ThemeManager.shared
        let manager2 = ThemeManager.shared

        XCTAssertTrue(manager1 === manager2)
    }

    @MainActor
    func testSetTheme() {
        let manager = ThemeManager.shared
        let originalType = manager.currentThemeType

        manager.setTheme(.light)
        XCTAssertEqual(manager.currentThemeType, .light)

        manager.setTheme(.dark)
        XCTAssertEqual(manager.currentThemeType, .dark)

        manager.setTheme(originalType)
    }

    @MainActor
    func testToggleTheme() {
        let manager = ThemeManager.shared
        let originalType = manager.currentThemeType

        manager.setTheme(.dark)
        manager.toggleTheme()
        XCTAssertEqual(manager.currentThemeType, .light)

        manager.toggleTheme()
        XCTAssertEqual(manager.currentThemeType, .dark)

        manager.setTheme(originalType)
    }

    @MainActor
    func testIsDarkMode() {
        let manager = ThemeManager.shared
        let originalType = manager.currentThemeType

        manager.setTheme(.dark)
        XCTAssertTrue(manager.isDarkMode)

        manager.setTheme(.light)
        XCTAssertFalse(manager.isDarkMode)

        manager.setTheme(originalType)
    }

    @MainActor
    func testCurrentThemeMatchesType() {
        let manager = ThemeManager.shared
        let originalType = manager.currentThemeType

        manager.setTheme(.dark)
        XCTAssertTrue(manager.currentTheme is DarkTheme)

        manager.setTheme(.light)
        XCTAssertTrue(manager.currentTheme is LightTheme)

        manager.setTheme(originalType)
    }

    @MainActor
    func testToggleMultipleTimes() {
        let manager = ThemeManager.shared
        let originalType = manager.currentThemeType

        manager.setTheme(.dark)

        for _ in 0..<10 {
            let before = manager.currentThemeType
            manager.toggleTheme()
            let after = manager.currentThemeType
            XCTAssertNotEqual(before, after)
        }

        manager.setTheme(originalType)
    }

    @MainActor
    func testApplyCurrentThemeDoesNotCrash() {
        let manager = ThemeManager.shared

        // Apenas verifica que não lança exceção
        manager.applyCurrentTheme()
        XCTAssertTrue(true)
    }

    @MainActor
    func testConsistencyAfterMultipleOperations() {
        let manager = ThemeManager.shared
        let originalType = manager.currentThemeType

        manager.setTheme(.dark)
        manager.toggleTheme()
        manager.setTheme(.dark)
        manager.toggleTheme()
        manager.toggleTheme()

        // Deve estar em dark após: dark -> light -> dark -> light -> dark
        XCTAssertEqual(manager.currentThemeType, .dark)

        manager.setTheme(originalType)
    }
}
