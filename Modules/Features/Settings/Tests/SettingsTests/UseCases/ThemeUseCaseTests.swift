//
//  ThemeUseCaseTests.swift
//  Settings
//
//  Created by Ivan Tonial IP.TV on 17/12/25.
//

@testable import Settings
import DesignSystem
import Testing

// MARK: - ThemeUseCase Initialization Tests

@Suite("ThemeUseCase Initialization Tests")
@MainActor
struct ThemeUseCaseInitializationTests {

    @Test("Should initialize successfully")
    func testInitialization() {
        // Act
        let useCase = ThemeUseCase()

        // Assert - Se chegou aqui, inicializou corretamente
        _ = useCase
        #expect(true)
    }

    @Test("Should conform to ThemeUseCaseProtocol")
    func testProtocolConformance() {
        // Arrange & Act
        let useCase: ThemeUseCaseProtocol = ThemeUseCase()

        // Assert - Verifica que o tipo está correto
        let theme = useCase.getCurrentTheme()
        #expect(theme == .dark || theme == .light)
    }
}

// MARK: - ThemeUseCase getCurrentTheme Tests

@Suite("ThemeUseCase getCurrentTheme Tests")
@MainActor
struct ThemeUseCaseGetCurrentThemeTests {

    @Test("Should return current theme type")
    func testGetCurrentTheme() {
        // Arrange
        let useCase = ThemeUseCase()
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType

        // Act
        let currentTheme = useCase.getCurrentTheme()

        // Assert
        #expect(currentTheme == originalTheme)
    }

    @Test("Should return dark when ThemeManager is dark")
    func testGetCurrentThemeDark() {
        // Arrange
        let useCase = ThemeUseCase()
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType

        themeManager.setTheme(.dark)

        // Act
        let currentTheme = useCase.getCurrentTheme()

        // Assert
        #expect(currentTheme == .dark)

        // Cleanup
        themeManager.setTheme(originalTheme)
    }

    @Test("Should return light when ThemeManager is light")
    func testGetCurrentThemeLight() {
        // Arrange
        let useCase = ThemeUseCase()
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType

        themeManager.setTheme(.light)

        // Act
        let currentTheme = useCase.getCurrentTheme()

        // Assert
        #expect(currentTheme == .light)

        // Cleanup
        themeManager.setTheme(originalTheme)
    }
}

// MARK: - ThemeUseCase setTheme Tests

@Suite("ThemeUseCase setTheme Tests")
@MainActor
struct ThemeUseCaseSetThemeTests {

    @Test("Should set theme to dark")
    func testSetThemeDark() {
        // Arrange
        let useCase = ThemeUseCase()
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType

        // Act
        useCase.setTheme(.dark)

        // Assert
        #expect(themeManager.currentThemeType == .dark)
        #expect(useCase.getCurrentTheme() == .dark)

        // Cleanup
        themeManager.setTheme(originalTheme)
    }

    @Test("Should set theme to light")
    func testSetThemeLight() {
        // Arrange
        let useCase = ThemeUseCase()
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType

        // Act
        useCase.setTheme(.light)

        // Assert
        #expect(themeManager.currentThemeType == .light)
        #expect(useCase.getCurrentTheme() == .light)

        // Cleanup
        themeManager.setTheme(originalTheme)
    }

    @Test("Should update ThemeManager when setting theme")
    func testSetThemeUpdatesManager() {
        // Arrange
        let useCase = ThemeUseCase()
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType

        themeManager.setTheme(.dark)

        // Act
        useCase.setTheme(.light)

        // Assert
        #expect(themeManager.currentThemeType == .light)
        #expect(themeManager.currentTheme is LightTheme)

        // Cleanup
        themeManager.setTheme(originalTheme)
    }
}

// MARK: - ThemeUseCase toggleTheme Tests

@Suite("ThemeUseCase toggleTheme Tests")
@MainActor
struct ThemeUseCaseToggleThemeTests {

    @Test("Should toggle from dark to light")
    func testToggleFromDarkToLight() {
        // Arrange
        let useCase = ThemeUseCase()
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType

        themeManager.setTheme(.dark)

        // Act
        useCase.toggleTheme()

        // Assert
        #expect(themeManager.currentThemeType == .light)
        #expect(useCase.getCurrentTheme() == .light)

        // Cleanup
        themeManager.setTheme(originalTheme)
    }

    @Test("Should toggle from light to dark")
    func testToggleFromLightToDark() {
        // Arrange
        let useCase = ThemeUseCase()
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType

        themeManager.setTheme(.light)

        // Act
        useCase.toggleTheme()

        // Assert
        #expect(themeManager.currentThemeType == .dark)
        #expect(useCase.getCurrentTheme() == .dark)

        // Cleanup
        themeManager.setTheme(originalTheme)
    }

    @Test("Should toggle back to original after two toggles")
    func testDoubleToggle() {
        // Arrange
        let useCase = ThemeUseCase()
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType

        // Act
        useCase.toggleTheme()
        useCase.toggleTheme()

        // Assert
        #expect(themeManager.currentThemeType == originalTheme)
    }
}

// MARK: - ThemeUseCaseProtocol Tests

@Suite("ThemeUseCaseProtocol Tests")
@MainActor
struct ThemeUseCaseProtocolTests {

    @Test("Protocol should define getCurrentTheme method")
    func testProtocolGetCurrentTheme() {
        // Arrange
        let useCase: ThemeUseCaseProtocol = ThemeUseCase()

        // Act
        let theme = useCase.getCurrentTheme()

        // Assert
        #expect(theme == .dark || theme == .light)
    }

    @Test("Protocol should define setTheme method")
    func testProtocolSetTheme() {
        // Arrange
        let useCase: ThemeUseCaseProtocol = ThemeUseCase()
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType

        // Act
        useCase.setTheme(.light)

        // Assert
        #expect(useCase.getCurrentTheme() == .light)

        // Cleanup
        themeManager.setTheme(originalTheme)
    }

    @Test("Protocol should define toggleTheme method")
    func testProtocolToggleTheme() {
        // Arrange
        let useCase: ThemeUseCaseProtocol = ThemeUseCase()
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType
        let themeBefore = useCase.getCurrentTheme()

        // Act
        useCase.toggleTheme()
        let themeAfter = useCase.getCurrentTheme()

        // Assert
        #expect(themeBefore != themeAfter)

        // Cleanup
        themeManager.setTheme(originalTheme)
    }
}

// MARK: - ThemeUseCase Integration Tests

@Suite("ThemeUseCase Integration Tests")
@MainActor
struct ThemeUseCaseIntegrationTests {

    @Test("Should work with ThemeManager singleton")
    func testThemeManagerIntegration() {
        // Arrange
        let useCase = ThemeUseCase()
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType

        // Act
        useCase.setTheme(.light)
        let managerTheme = themeManager.currentThemeType
        let useCaseTheme = useCase.getCurrentTheme()

        // Assert
        #expect(managerTheme == .light)
        #expect(useCaseTheme == .light)
        #expect(managerTheme == useCaseTheme)

        // Cleanup
        themeManager.setTheme(originalTheme)
    }

    @Test("Multiple instances should affect same ThemeManager")
    func testMultipleInstances() {
        // Arrange
        let useCase1 = ThemeUseCase()
        let useCase2 = ThemeUseCase()
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType

        // Act
        useCase1.setTheme(.dark)
        let theme1 = useCase2.getCurrentTheme()

        useCase2.setTheme(.light)
        let theme2 = useCase1.getCurrentTheme()

        // Assert
        #expect(theme1 == .dark)
        #expect(theme2 == .light)

        // Cleanup
        themeManager.setTheme(originalTheme)
    }

    @Test("Should reflect ThemeManager isDarkMode correctly")
    func testIsDarkModeReflection() {
        // Arrange
        let useCase = ThemeUseCase()
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType

        // Act & Assert
        useCase.setTheme(.dark)
        #expect(themeManager.isDarkMode == true)

        useCase.setTheme(.light)
        #expect(themeManager.isDarkMode == false)

        // Cleanup
        themeManager.setTheme(originalTheme)
    }
}
