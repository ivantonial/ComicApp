//
//  SettingsViewModelTests.swift
//  Settings
//
//  Created by Ivan Tonial IP.TV on 17/12/25.
//

@testable import Settings
import Combine
import DesignSystem
import Foundation
import Testing

// MARK: - SettingsViewModel Initialization Tests

@Suite("SettingsViewModel Initialization Tests")
@MainActor
struct SettingsViewModelInitializationTests {

    @Test("Should initialize with default values")
    func testDefaultInitialization() {
        // Act
        let viewModel = SettingsViewModel(cacheManager: nil)

        // Assert - Verifica valores que são sempre definidos na inicialização
        #expect(viewModel.cacheSize == "Calculating...")
        #expect(viewModel.apiStatus == .checking)
        #expect(viewModel.isClearingCache == false)
        #expect(viewModel.isCalculatingCache == false)
        #expect(viewModel.showingClearCacheAlert == false)
        #expect(viewModel.showingResetAlert == false)
        // imageQuality pode variar baseado em UserDefaults persistido
        #expect(ImageQuality.allCases.contains(viewModel.imageQuality))
    }

    @Test("Should initialize with cache manager")
    func testInitializationWithCacheManager() async {
        // Arrange
        let mockManager = MockSettingsCacheManager()

        // Act
        let viewModel = SettingsViewModel(cacheManager: mockManager)

        // Assert - Verifica que foi criado corretamente
        #expect(ImageQuality.allCases.contains(viewModel.imageQuality))
    }

    @Test("Should sync dark mode with ThemeManager on init")
    func testDarkModeSyncOnInit() {
        // Arrange
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType
        themeManager.setTheme(.dark)

        // Act
        let viewModel = SettingsViewModel(cacheManager: nil)

        // Assert
        #expect(viewModel.isDarkModeEnabled == true)

        // Cleanup
        themeManager.setTheme(originalTheme)
    }

    @Test("Should sync light mode with ThemeManager on init")
    func testLightModeSyncOnInit() {
        // Arrange
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType
        themeManager.setTheme(.light)

        // Act
        let viewModel = SettingsViewModel(cacheManager: nil)

        // Assert
        #expect(viewModel.isDarkModeEnabled == false)

        // Cleanup
        themeManager.setTheme(originalTheme)
    }
}

// MARK: - SettingsViewModel Computed Properties Tests

@Suite("SettingsViewModel Computed Properties Tests")
@MainActor
struct SettingsViewModelComputedPropertiesTests {

    @Test("notificationStatusText should return 'Enabled' when enabled")
    func testNotificationStatusTextEnabled() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)
        viewModel.isNotificationsEnabled = true

        // Act
        let text = viewModel.notificationStatusText

        // Assert
        #expect(text == "Enabled")
    }

    @Test("notificationStatusText should return 'Disabled' when disabled")
    func testNotificationStatusTextDisabled() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)
        viewModel.isNotificationsEnabled = false

        // Act
        let text = viewModel.notificationStatusText

        // Assert
        #expect(text == "Disabled")
    }

    @Test("cacheStatusText should return cacheSize when not calculating")
    func testCacheStatusTextNormal() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)
        viewModel.isCalculatingCache = false
        viewModel.cacheSize = "10 MB"

        // Act
        let text = viewModel.cacheStatusText

        // Assert
        #expect(text == "10 MB")
    }

    @Test("cacheStatusText should return 'Calculating...' when calculating")
    func testCacheStatusTextCalculating() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)
        viewModel.isCalculatingCache = true

        // Act
        let text = viewModel.cacheStatusText

        // Assert
        #expect(text == "Calculating...")
    }

    @Test("canClearCache should be true when conditions are met")
    func testCanClearCacheTrue() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)
        viewModel.isClearingCache = false
        viewModel.isCalculatingCache = false
        viewModel.cacheSize = "10 MB"

        // Act & Assert
        #expect(viewModel.canClearCache == true)
    }

    @Test("canClearCache should be false when clearing")
    func testCanClearCacheFalseWhenClearing() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)
        viewModel.isClearingCache = true

        // Act & Assert
        #expect(viewModel.canClearCache == false)
    }

    @Test("canClearCache should be false when calculating")
    func testCanClearCacheFalseWhenCalculating() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)
        viewModel.isCalculatingCache = true

        // Act & Assert
        #expect(viewModel.canClearCache == false)
    }

    @Test("canClearCache should be false when cache is zero")
    func testCanClearCacheFalseWhenZero() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)
        viewModel.cacheSize = "0 bytes"

        // Act & Assert
        #expect(viewModel.canClearCache == false)
    }

    @Test("cacheInfoIcon should return filled icon when breakdown has details")
    func testCacheInfoIconFilled() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)
        var breakdown = CacheSizeBreakdown()
        breakdown.imageCache = 100
        viewModel.cacheBreakdown = breakdown

        // Act
        let icon = viewModel.cacheInfoIcon

        // Assert
        #expect(icon == "info.circle.fill")
    }

    @Test("cacheInfoIcon should be empty when no breakdown details")
    func testCacheInfoIconEmpty() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)
        viewModel.cacheBreakdown = nil

        // Act
        let icon = viewModel.cacheInfoIcon

        // Assert
        #expect(icon == "")
    }
}

// MARK: - SettingsViewModel Theme Tests

@Suite("SettingsViewModel Theme Tests")
@MainActor
struct SettingsViewModelThemeTests {

    @Test("applyTheme should set dark theme")
    func testApplyDarkTheme() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType

        // Act
        viewModel.applyTheme(isDark: true)

        // Assert
        #expect(themeManager.currentThemeType == .dark)

        // Cleanup
        themeManager.setTheme(originalTheme)
    }

    @Test("applyTheme should set light theme")
    func testApplyLightTheme() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType

        // Act
        viewModel.applyTheme(isDark: false)

        // Assert
        #expect(themeManager.currentThemeType == .light)

        // Cleanup
        themeManager.setTheme(originalTheme)
    }
}

// MARK: - SettingsViewModel Settings Update Tests

@Suite("SettingsViewModel Settings Update Tests")
@MainActor
struct SettingsViewModelSettingsUpdateTests {

    @Test("toggleAutoPlayVideos should toggle the value")
    func testToggleAutoPlayVideos() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)
        let initialValue = viewModel.isAutoPlayVideosEnabled

        // Act
        viewModel.toggleAutoPlayVideos()

        // Assert
        #expect(viewModel.isAutoPlayVideosEnabled == !initialValue)
    }

    @Test("updateImageQuality should update quality")
    func testUpdateImageQuality() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)

        // Act
        viewModel.updateImageQuality(.low)

        // Assert
        #expect(viewModel.imageQuality == .low)
    }

    @Test("updateImageQuality should update to medium")
    func testUpdateImageQualityMedium() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)

        // Act
        viewModel.updateImageQuality(.medium)

        // Assert
        #expect(viewModel.imageQuality == .medium)
    }

    @Test("toggleCacheDetails should toggle showCacheDetails")
    func testToggleCacheDetails() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)
        let initialValue = viewModel.showCacheDetails

        // Act
        viewModel.toggleCacheDetails()

        // Assert
        #expect(viewModel.showCacheDetails == !initialValue)
    }
}

// MARK: - SettingsViewModel Reset Tests

@Suite("SettingsViewModel Reset Tests")
@MainActor
struct SettingsViewModelResetTests {

    @Test("resetSettings should reset all values to defaults")
    func testResetSettings() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)
        let themeManager = ThemeManager.shared
        let originalTheme = themeManager.currentThemeType

        viewModel.isNotificationsEnabled = true
        viewModel.isAutoPlayVideosEnabled = true
        viewModel.imageQuality = .low

        // Act
        viewModel.resetSettings()

        // Assert
        #expect(viewModel.isNotificationsEnabled == false)
        #expect(viewModel.isAutoPlayVideosEnabled == false)
        #expect(viewModel.imageQuality == .high)
        #expect(viewModel.isDarkModeEnabled == true)

        // Cleanup
        themeManager.setTheme(originalTheme)
    }
}

// MARK: - SettingsViewModel Cache Operations Tests

@Suite("SettingsViewModel Cache Operations Tests")
@MainActor
struct SettingsViewModelCacheOperationsTests {

    @Test("clearCache should not execute when canClearCache is false")
    func testClearCacheWhenDisabled() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)
        viewModel.isClearingCache = true

        // Act
        viewModel.clearCache()

        // Assert - Não deve mudar o estado porque já está limpando
        #expect(viewModel.isClearingCache == true)
    }

    @Test("refreshCacheSize should trigger recalculation")
    func testRefreshCacheSize() async throws {
        // Arrange
        let mockManager = MockSettingsCacheManager()
        let viewModel = SettingsViewModel(cacheManager: mockManager)

        // Aguarda a inicialização
        try await Task.sleep(nanoseconds: 100_000_000)

        // Act
        viewModel.refreshCacheSize()

        // Aguarda a atualização
        try await Task.sleep(nanoseconds: 200_000_000)

        // Assert
        let getCacheSizeCalled = await mockManager.getCacheSizeCalled
        #expect(getCacheSizeCalled)
    }
}

// MARK: - SettingsViewModel External Links Tests

@Suite("SettingsViewModel External Links Tests")
@MainActor
struct SettingsViewModelExternalLinksTests {

    @Test("shareApp should return share items")
    func testShareApp() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)

        // Act
        let items = viewModel.shareApp()

        // Assert
        #expect(items.count == 2)
    }

    @Test("shareApp should contain text and URL")
    func testShareAppContents() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)

        // Act
        let items = viewModel.shareApp()

        // Assert
        let containsString = items.contains { $0 is String }
        let containsURL = items.contains { $0 is URL }
        #expect(containsString)
        #expect(containsURL)
    }
}

// MARK: - SettingsViewModel Lifecycle Tests

@Suite("SettingsViewModel Lifecycle Tests")
@MainActor
struct SettingsViewModelLifecycleTests {

    @Test("onAppear should be callable")
    func testOnAppear() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)

        // Act & Assert - Não deve lançar exceção
        viewModel.onAppear()
        #expect(true)
    }

    @Test("onDisappear should be callable")
    func testOnDisappear() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)

        // Act & Assert - Não deve lançar exceção
        viewModel.onDisappear()
        #expect(true)
    }

    @Test("onAppear followed by onDisappear should be safe")
    func testOnAppearAndDisappear() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)

        // Act
        viewModel.onAppear()
        viewModel.onDisappear()

        // Assert - Não deve lançar exceção
        #expect(true)
    }
}

// MARK: - SettingsViewModel Alert State Tests

@Suite("SettingsViewModel Alert State Tests")
@MainActor
struct SettingsViewModelAlertStateTests {

    @Test("showingClearCacheAlert should be settable")
    func testShowingClearCacheAlert() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)

        // Act
        viewModel.showingClearCacheAlert = true

        // Assert
        #expect(viewModel.showingClearCacheAlert == true)
    }

    @Test("showingResetAlert should be settable")
    func testShowingResetAlert() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)

        // Act
        viewModel.showingResetAlert = true

        // Assert
        #expect(viewModel.showingResetAlert == true)
    }
}

// MARK: - SettingsViewModel formattedLastUpdate Tests

@Suite("SettingsViewModel formattedLastUpdate Tests")
@MainActor
struct SettingsViewModelFormattedLastUpdateTests {

    @Test("formattedLastUpdate should be nil when lastCacheUpdate is nil")
    func testFormattedLastUpdateNil() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)
        viewModel.lastCacheUpdate = nil

        // Act
        let formatted = viewModel.formattedLastUpdate

        // Assert
        #expect(formatted == nil)
    }

    @Test("formattedLastUpdate should return formatted string when date is set")
    func testFormattedLastUpdateWithDate() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)
        viewModel.lastCacheUpdate = Date()

        // Act
        let formatted = viewModel.formattedLastUpdate

        // Assert
        #expect(formatted != nil)
        #expect(formatted?.contains("Updated") == true)
    }
}

// MARK: - SettingsViewModel Published Properties Tests

@Suite("SettingsViewModel Published Properties Tests")
@MainActor
struct SettingsViewModelPublishedPropertiesTests {

    @Test("All published properties should be observable")
    func testPublishedProperties() {
        // Arrange
        let viewModel = SettingsViewModel(cacheManager: nil)

        // Act & Assert - Verifica que as propriedades podem ser lidas
        _ = viewModel.isNotificationsEnabled
        _ = viewModel.isDarkModeEnabled
        _ = viewModel.isAutoPlayVideosEnabled
        _ = viewModel.imageQuality
        _ = viewModel.cacheSize
        _ = viewModel.cacheDetails
        _ = viewModel.appVersion
        _ = viewModel.buildNumber
        _ = viewModel.showingClearCacheAlert
        _ = viewModel.showingResetAlert
        _ = viewModel.apiStatus
        _ = viewModel.isClearingCache
        _ = viewModel.isCalculatingCache
        _ = viewModel.lastCacheUpdate
        _ = viewModel.cacheBreakdown
        _ = viewModel.showCacheDetails

        #expect(true)
    }
}
