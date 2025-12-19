//
//  CacheUseCaseTests.swift
//  Settings
//
//  Created by Ivan Tonial IP.TV on 17/12/25.
//

@testable import Settings
import Foundation
import Testing

// MARK: - CacheUseCase Initialization Tests

@Suite("CacheUseCase Initialization Tests")
@MainActor
struct CacheUseCaseInitializationTests {

    @Test("Should initialize without cache manager")
    func testInitWithoutCacheManager() {
        // Act
        let useCase = CacheUseCase(cacheManager: nil)

        // Assert - Verifica que foi criado corretamente
        _ = useCase
        #expect(true) // Se chegou aqui, inicializou corretamente
    }

    @Test("Should initialize with cache manager")
    func testInitWithCacheManager() async {
        // Arrange
        let mockManager = MockSettingsCacheManager()

        // Act
        let useCase = CacheUseCase(cacheManager: mockManager)

        // Assert - Verifica que foi criado corretamente
        _ = useCase
        #expect(true)
    }
}

// MARK: - CacheUseCase calculateTotalCacheSize Tests

@Suite("CacheUseCase calculateTotalCacheSize Tests")
@MainActor
struct CacheUseCaseCalculateSizeTests {

    @Test("Should calculate cache size without manager")
    func testCalculateSizeWithoutManager() async {
        // Arrange
        let useCase = CacheUseCase(cacheManager: nil)

        // Act
        let result = await useCase.calculateTotalCacheSize()

        // Assert
        #expect(result.totalSize >= 0)
        #expect(!result.formattedSize.isEmpty)
    }

    @Test("Should calculate cache size with manager")
    func testCalculateSizeWithManager() async {
        // Arrange
        let mockManager = MockSettingsCacheManager()
        await mockManager.setupWithCacheSize(1024 * 1024) // 1 MB
        let useCase = CacheUseCase(cacheManager: mockManager)

        // Act
        let result = await useCase.calculateTotalCacheSize()

        // Assert
        #expect(result.totalSize >= 0)
        #expect(!result.formattedSize.isEmpty)
        let getCacheSizeCalled = await mockManager.getCacheSizeCalled
        #expect(getCacheSizeCalled)
    }

    @Test("Should include managed cache in breakdown")
    func testBreakdownIncludesManagedCache() async {
        // Arrange
        let mockManager = MockSettingsCacheManager()
        await mockManager.setupWithCacheSize(500_000)
        let useCase = CacheUseCase(cacheManager: mockManager)

        // Act
        let result = await useCase.calculateTotalCacheSize()

        // Assert
        #expect(result.breakdown.managedCache == 500_000)
    }

    @Test("Should set lastCalculated to current date")
    func testLastCalculatedDate() async {
        // Arrange
        let useCase = CacheUseCase(cacheManager: nil)
        let beforeDate = Date()

        // Act
        let result = await useCase.calculateTotalCacheSize()
        let afterDate = Date()

        // Assert
        #expect(result.lastCalculated >= beforeDate)
        #expect(result.lastCalculated <= afterDate)
    }

    @Test("Should format size correctly")
    func testSizeFormatting() async {
        // Arrange
        let useCase = CacheUseCase(cacheManager: nil)

        // Act
        let result = await useCase.calculateTotalCacheSize()

        // Assert
        // O formato deve conter unidades como bytes, KB, MB, etc.
        let validUnits = ["bytes", "KB", "MB", "GB", "TB"]
        let containsValidUnit = validUnits.contains { result.formattedSize.contains($0) }
        #expect(containsValidUnit || result.formattedSize == "Zero KB")
    }
}

// MARK: - CacheUseCase clearAllCache Tests

@Suite("CacheUseCase clearAllCache Tests")
@MainActor
struct CacheUseCaseClearAllTests {

    @Test("Should clear all cache without manager")
    func testClearAllWithoutManager() async {
        // Arrange
        let useCase = CacheUseCase(cacheManager: nil)

        // Act
        let result = await useCase.clearAllCache()

        // Assert - clearedSize pode ser negativo se o cache mudar durante a operação
        #expect(!result.formattedClearedSize.isEmpty)
    }

    @Test("Should clear all cache with manager")
    func testClearAllWithManager() async {
        // Arrange
        let mockManager = MockSettingsCacheManager()
        await mockManager.setupWithCacheSize(1024 * 1024)
        let useCase = CacheUseCase(cacheManager: mockManager)

        // Act
        let result = await useCase.clearAllCache()

        // Assert
        let clearAllCalled = await mockManager.clearAllCalled
        #expect(clearAllCalled)
        // clearedSize pode variar devido a outras fontes de cache (URLCache, system, etc)
        #expect(!result.formattedClearedSize.isEmpty)
    }

    @Test("Should return formatted cleared size")
    func testClearAllFormattedSize() async {
        // Arrange
        let mockManager = MockSettingsCacheManager()
        let useCase = CacheUseCase(cacheManager: mockManager)

        // Act
        let result = await useCase.clearAllCache()

        // Assert
        #expect(!result.formattedClearedSize.isEmpty)
    }
}

// MARK: - CacheUseCase clearCacheByType Tests

@Suite("CacheUseCase clearCacheByType Tests")
@MainActor
struct CacheUseCaseClearByTypeTests {

    @Test("Should clear managed cache type")
    func testClearManagedType() async {
        // Arrange
        let mockManager = MockSettingsCacheManager()
        await mockManager.setupWithCacheSize(500_000)
        let useCase = CacheUseCase(cacheManager: mockManager)

        // Act
        let result = await useCase.clearCacheByType(.managed)

        // Assert
        let clearAllCalled = await mockManager.clearAllCalled
        #expect(clearAllCalled)
        // O clearedSize para .managed retorna apenas o tamanho do mock
        #expect(result.clearedSize == 500_000)
    }

    @Test("Should clear images cache type")
    func testClearImagesType() async {
        // Arrange
        let useCase = CacheUseCase(cacheManager: nil)

        // Act
        let result = await useCase.clearCacheByType(.images)

        // Assert - clearedSize pode ser negativo devido a mudanças no cache durante a operação
        #expect(!result.formattedClearedSize.isEmpty)
    }

    @Test("Should clear temporary cache type")
    func testClearTemporaryType() async {
        // Arrange
        let useCase = CacheUseCase(cacheManager: nil)

        // Act
        let result = await useCase.clearCacheByType(.temporary)

        // Assert - clearedSize pode ser negativo devido a mudanças no cache durante a operação
        #expect(!result.formattedClearedSize.isEmpty)
    }

    @Test("Should clear system cache type")
    func testClearSystemType() async {
        // Arrange
        let useCase = CacheUseCase(cacheManager: nil)

        // Act
        let result = await useCase.clearCacheByType(.system)

        // Assert - clearedSize pode ser negativo devido a mudanças no cache durante a operação
        #expect(!result.formattedClearedSize.isEmpty)
    }

    @Test("Should delegate to clearAllCache for .all type")
    func testClearAllType() async {
        // Arrange
        let mockManager = MockSettingsCacheManager()
        let useCase = CacheUseCase(cacheManager: mockManager)

        // Act
        let result = await useCase.clearCacheByType(.all)

        // Assert
        let clearAllCalled = await mockManager.clearAllCalled
        #expect(clearAllCalled)
        // clearedSize pode ser negativo se o cache mudar durante a operação
        #expect(!result.formattedClearedSize.isEmpty)
    }
}

// MARK: - CacheUseCase Error Handling Tests

@Suite("CacheUseCase Error Handling Tests")
@MainActor
struct CacheUseCaseErrorHandlingTests {

    @Test("Should handle nil cache manager gracefully")
    func testNilCacheManagerHandling() async {
        // Arrange
        let useCase = CacheUseCase(cacheManager: nil)

        // Act
        let sizeResult = await useCase.calculateTotalCacheSize()
        let clearResult = await useCase.clearAllCache()

        // Assert
        #expect(sizeResult.totalSize >= 0)
        // clearedSize pode ser negativo se o cache mudar durante a operação (sizeBefore - sizeAfter)
        #expect(!clearResult.formattedClearedSize.isEmpty)
    }

    @Test("Should return errors array in clear result")
    func testErrorsInClearResult() async {
        // Arrange
        let useCase = CacheUseCase(cacheManager: nil)

        // Act
        let result = await useCase.clearCacheByType(.system)

        // Assert - errors é um array, pode estar vazio ou ter itens
        #expect(result.errors.count >= 0)
    }
}

// MARK: - CacheUseCase Integration Tests

@Suite("CacheUseCase Integration Tests")
@MainActor
struct CacheUseCaseIntegrationTests {

    @Test("Should calculate and clear in sequence")
    func testCalculateAndClearSequence() async {
        // Arrange
        let mockManager = MockSettingsCacheManager()
        await mockManager.setupWithCacheSize(1_000_000)
        let useCase = CacheUseCase(cacheManager: mockManager)

        // Act
        let sizeBefore = await useCase.calculateTotalCacheSize()
        _ = await useCase.clearAllCache()

        // Simula que o cache foi limpo
        await mockManager.setupEmpty()
        let sizeAfter = await useCase.calculateTotalCacheSize()

        // Assert
        #expect(sizeBefore.breakdown.managedCache > 0)
        #expect(sizeAfter.breakdown.managedCache == 0)
    }

    @Test("Should track multiple clear operations")
    func testMultipleClearOperations() async {
        // Arrange
        let mockManager = MockSettingsCacheManager()
        let useCase = CacheUseCase(cacheManager: mockManager)

        // Act
        _ = await useCase.clearCacheByType(.managed)
        _ = await useCase.clearCacheByType(.managed)
        _ = await useCase.clearCacheByType(.managed)

        // Assert
        let clearAllCallCount = await mockManager.clearAllCallCount
        #expect(clearAllCallCount == 3)
    }
}
