//
//  SettingsTests.swift
//  Settings
//
//  Created by Ivan Tonial IP.TV on 17/12/25.
//
//  NOTA: Este arquivo serve como ponto de entrada para os testes do módulo Settings.
//  Os testes estão organizados em arquivos separados seguindo a arquitetura MVVM-C:
//
//  Estrutura dos testes:
//  ├── Doubles/
//  │   └── MockCacheManager+Settings.swift        - Mock para CacheManagerProtocol
//  ├── Models/
//  │   ├── APIStatusTests.swift                   - Testes do APIStatus
//  │   ├── ImageQualityTests.swift                - Testes do ImageQuality
//  │   └── CacheSizeInfoTests.swift               - Testes das structs de cache
//  ├── UseCases/
//  │   ├── CacheUseCaseTests.swift                - Testes do CacheUseCase
//  │   └── ThemeUseCaseTests.swift                - Testes do ThemeUseCase
//  ├── ViewModels/
//  │   └── SettingsViewModelTests.swift           - Testes do SettingsViewModel
//  └── Views/
//      └── SettingsSectionHeaderViewTests.swift   - Testes do SettingsSectionHeaderView
//

@testable import Settings
import Cache
import DesignSystem
import Foundation
import SwiftUI
import Testing
import XCTest

// MARK: - Settings Module Export Tests

@Suite("Settings Module Export Tests")
@MainActor
struct SettingsModuleExportTests {

    @Test("Settings module should export APIStatus")
    func testAPIStatusExport() {
        // Valida que APIStatus está acessível
        let status = APIStatus.online
        #expect(status.text == "Connected")
        #expect(status.color == .green)
    }

    @Test("Settings module should export all APIStatus cases")
    func testAllAPIStatusCases() {
        // Valida que todos os casos de APIStatus estão disponíveis
        let online = APIStatus.online
        let offline = APIStatus.offline
        let checking = APIStatus.checking

        #expect(online.text == "Connected")
        #expect(offline.text == "Disconnected")
        #expect(checking.text == "Checking...")
    }

    @Test("Settings module should export ImageQuality")
    func testImageQualityExport() {
        // Valida que ImageQuality está acessível
        let quality = ImageQuality.high
        #expect(quality.title == "High")
        #expect(!quality.description.isEmpty)
    }

    @Test("Settings module should export all ImageQuality cases")
    func testAllImageQualityCases() {
        // Valida que todos os casos de ImageQuality estão disponíveis
        let allCases = ImageQuality.allCases
        #expect(allCases.count == 3)
        #expect(allCases.contains(.low))
        #expect(allCases.contains(.medium))
        #expect(allCases.contains(.high))
    }

    @Test("Settings module should export CacheUseCase")
    func testCacheUseCaseExport() {
        // Valida que CacheUseCase está acessível
        let useCase = CacheUseCase(cacheManager: nil)
        _ = useCase
        #expect(true)
    }

    @Test("Settings module should export ThemeUseCase")
    func testThemeUseCaseExport() {
        // Valida que ThemeUseCase está acessível
        let useCase = ThemeUseCase()
        _ = useCase
        #expect(true)
    }

    @Test("Settings module should export ThemeUseCaseProtocol")
    func testThemeUseCaseProtocolExport() {
        // Valida que ThemeUseCaseProtocol está acessível
        let useCase: ThemeUseCaseProtocol = ThemeUseCase()
        let theme = useCase.getCurrentTheme()
        #expect(theme == .dark || theme == .light)
    }

    @Test("Settings module should export SettingsViewModel")
    func testSettingsViewModelExport() {
        // Valida que SettingsViewModel está acessível
        let viewModel = SettingsViewModel(cacheManager: nil)
        // Verifica que imageQuality é um dos valores válidos (pode variar baseado em UserDefaults)
        #expect(ImageQuality.allCases.contains(viewModel.imageQuality))
    }

    @Test("Settings module should export CacheSizeInfo")
    func testCacheSizeInfoExport() {
        // Valida que CacheSizeInfo está acessível
        let breakdown = CacheSizeBreakdown()
        let info = CacheSizeInfo(
            totalSize: 1024,
            formattedSize: "1 KB",
            breakdown: breakdown,
            lastCalculated: Date()
        )
        #expect(info.totalSize == 1024)
        #expect(info.formattedSize == "1 KB")
    }

    @Test("Settings module should export CacheSizeBreakdown")
    func testCacheSizeBreakdownExport() {
        // Valida que CacheSizeBreakdown está acessível
        var breakdown = CacheSizeBreakdown()
        breakdown.imageCache = 500
        breakdown.managedCache = 300
        #expect(breakdown.hasDetails == true)
    }

    @Test("Settings module should export ClearCacheResult")
    func testClearCacheResultExport() {
        // Valida que ClearCacheResult está acessível
        let result = ClearCacheResult(
            success: true,
            clearedSize: 1024,
            formattedClearedSize: "1 KB",
            errors: [],
            timestamp: Date()
        )
        #expect(result.success == true)
        #expect(result.clearedSize == 1024)
    }

    @Test("Settings module should export CacheType")
    func testCacheTypeExport() {
        // Valida que CacheType está acessível
        let types: [CacheType] = [.managed, .images, .temporary, .system, .all]
        #expect(types.count == 5)
    }

    @Test("Settings module should export SettingsView")
    func testSettingsViewExport() {
        // Valida que SettingsView está acessível
        let viewModel = SettingsViewModel(cacheManager: nil)
        let view = SettingsView(viewModel: viewModel)
        _ = view
        #expect(true)
    }

    @Test("Settings module should export SettingsSectionHeaderView")
    func testSettingsSectionHeaderViewExport() {
        // Valida que SettingsSectionHeaderView está acessível
        let header = SettingsSectionHeaderView(
            title: "Test",
            systemImage: "gear",
            color: .gray
        )
        #expect(header.title == "Test")
        #expect(header.systemImage == "gear")
    }
}
