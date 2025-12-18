//
//  CacheSizeInfoTests.swift
//  Settings
//
//  Created by Ivan Tonial IP.TV on 17/12/25.
//

@testable import Settings
import Foundation
import Testing

// MARK: - CacheSizeBreakdown Initialization Tests

@Suite("CacheSizeBreakdown Initialization Tests")
struct CacheSizeBreakdownInitializationTests {

    @Test("Default initialization should have zero values")
    func testDefaultInitialization() {
        // Arrange & Act
        let breakdown = CacheSizeBreakdown()

        // Assert
        #expect(breakdown.managedCache == 0)
        #expect(breakdown.imageCache == 0)
        #expect(breakdown.systemCache == 0)
        #expect(breakdown.temporaryFiles == 0)
        #expect(breakdown.coreDataCache == 0)
    }

    @Test("Should allow setting individual values")
    func testSettingValues() {
        // Arrange
        var breakdown = CacheSizeBreakdown()

        // Act
        breakdown.managedCache = 1000
        breakdown.imageCache = 2000
        breakdown.systemCache = 3000
        breakdown.temporaryFiles = 4000
        breakdown.coreDataCache = 5000

        // Assert
        #expect(breakdown.managedCache == 1000)
        #expect(breakdown.imageCache == 2000)
        #expect(breakdown.systemCache == 3000)
        #expect(breakdown.temporaryFiles == 4000)
        #expect(breakdown.coreDataCache == 5000)
    }
}

// MARK: - CacheSizeBreakdown hasDetails Tests

@Suite("CacheSizeBreakdown hasDetails Tests")
struct CacheSizeBreakdownHasDetailsTests {

    @Test("hasDetails should be false when all values are zero")
    func testHasDetailsFalseWhenEmpty() {
        // Arrange
        let breakdown = CacheSizeBreakdown()

        // Assert
        #expect(breakdown.hasDetails == false)
    }

    @Test("hasDetails should be true when managedCache is set")
    func testHasDetailsTrueWithManagedCache() {
        // Arrange
        var breakdown = CacheSizeBreakdown()
        breakdown.managedCache = 100

        // Assert
        #expect(breakdown.hasDetails == true)
    }

    @Test("hasDetails should be true when imageCache is set")
    func testHasDetailsTrueWithImageCache() {
        // Arrange
        var breakdown = CacheSizeBreakdown()
        breakdown.imageCache = 100

        // Assert
        #expect(breakdown.hasDetails == true)
    }

    @Test("hasDetails should be true when systemCache is set")
    func testHasDetailsTrueWithSystemCache() {
        // Arrange
        var breakdown = CacheSizeBreakdown()
        breakdown.systemCache = 100

        // Assert
        #expect(breakdown.hasDetails == true)
    }

    @Test("hasDetails should be true when temporaryFiles is set")
    func testHasDetailsTrueWithTemporaryFiles() {
        // Arrange
        var breakdown = CacheSizeBreakdown()
        breakdown.temporaryFiles = 100

        // Assert
        #expect(breakdown.hasDetails == true)
    }

    @Test("hasDetails should be true when coreDataCache is set")
    func testHasDetailsTrueWithCoreDataCache() {
        // Arrange
        var breakdown = CacheSizeBreakdown()
        breakdown.coreDataCache = 100

        // Assert
        #expect(breakdown.hasDetails == true)
    }

    @Test("hasDetails should be true when multiple values are set")
    func testHasDetailsTrueWithMultipleValues() {
        // Arrange
        var breakdown = CacheSizeBreakdown()
        breakdown.imageCache = 500
        breakdown.managedCache = 300

        // Assert
        #expect(breakdown.hasDetails == true)
    }
}

// MARK: - CacheSizeInfo Initialization Tests

@Suite("CacheSizeInfo Initialization Tests")
struct CacheSizeInfoInitializationTests {

    @Test("Should initialize with provided values")
    func testInitialization() {
        // Arrange
        let breakdown = CacheSizeBreakdown()
        let date = Date()

        // Act
        let info = CacheSizeInfo(
            totalSize: 1024,
            formattedSize: "1 KB",
            breakdown: breakdown,
            lastCalculated: date
        )

        // Assert
        #expect(info.totalSize == 1024)
        #expect(info.formattedSize == "1 KB")
        #expect(info.lastCalculated == date)
    }
}

// MARK: - CacheSizeInfo isEmpty Tests

@Suite("CacheSizeInfo isEmpty Tests")
struct CacheSizeInfoIsEmptyTests {

    @Test("isEmpty should be true when totalSize is zero")
    func testIsEmptyTrue() {
        // Arrange
        let info = CacheSizeInfo(
            totalSize: 0,
            formattedSize: "0 bytes",
            breakdown: CacheSizeBreakdown(),
            lastCalculated: Date()
        )

        // Assert
        #expect(info.isEmpty == true)
    }

    @Test("isEmpty should be false when totalSize is greater than zero")
    func testIsEmptyFalse() {
        // Arrange
        let info = CacheSizeInfo(
            totalSize: 100,
            formattedSize: "100 bytes",
            breakdown: CacheSizeBreakdown(),
            lastCalculated: Date()
        )

        // Assert
        #expect(info.isEmpty == false)
    }
}

// MARK: - CacheSizeInfo detailedDescription Tests

@Suite("CacheSizeInfo detailedDescription Tests")
struct CacheSizeInfoDetailedDescriptionTests {

    @Test("detailedDescription should include total size")
    func testDetailedDescriptionIncludesTotal() {
        // Arrange
        let info = CacheSizeInfo(
            totalSize: 1024,
            formattedSize: "1 KB",
            breakdown: CacheSizeBreakdown(),
            lastCalculated: Date()
        )

        // Act
        let description = info.detailedDescription

        // Assert
        #expect(description.contains("Total: 1 KB"))
    }

    @Test("detailedDescription should include breakdown when available")
    func testDetailedDescriptionIncludesBreakdown() {
        // Arrange
        var breakdown = CacheSizeBreakdown()
        breakdown.imageCache = 500
        breakdown.managedCache = 300

        let info = CacheSizeInfo(
            totalSize: 800,
            formattedSize: "800 bytes",
            breakdown: breakdown,
            lastCalculated: Date()
        )

        // Act
        let description = info.detailedDescription

        // Assert
        #expect(description.contains("Images:"))
        #expect(description.contains("App Data:"))
    }

    @Test("detailedDescription should not include zero-value breakdown items")
    func testDetailedDescriptionExcludesZeroValues() {
        // Arrange
        var breakdown = CacheSizeBreakdown()
        breakdown.imageCache = 500
        // managedCache, systemCache, etc. remain 0

        let info = CacheSizeInfo(
            totalSize: 500,
            formattedSize: "500 bytes",
            breakdown: breakdown,
            lastCalculated: Date()
        )

        // Act
        let description = info.detailedDescription

        // Assert
        #expect(description.contains("Images:"))
        #expect(!description.contains("App Data:"))
        #expect(!description.contains("System:"))
    }
}

// MARK: - ClearCacheResult Initialization Tests

@Suite("ClearCacheResult Initialization Tests")
struct ClearCacheResultInitializationTests {

    @Test("Should initialize with success values")
    func testSuccessInitialization() {
        // Arrange & Act
        let result = ClearCacheResult(
            success: true,
            clearedSize: 1024,
            formattedClearedSize: "1 KB",
            errors: [],
            timestamp: Date()
        )

        // Assert
        #expect(result.success == true)
        #expect(result.clearedSize == 1024)
        #expect(result.formattedClearedSize == "1 KB")
        #expect(result.errors.isEmpty)
    }

    @Test("Should initialize with failure values")
    func testFailureInitialization() {
        // Arrange & Act
        let result = ClearCacheResult(
            success: false,
            clearedSize: 500,
            formattedClearedSize: "500 bytes",
            errors: ["Error 1", "Error 2"],
            timestamp: Date()
        )

        // Assert
        #expect(result.success == false)
        #expect(result.clearedSize == 500)
        #expect(result.errors.count == 2)
    }
}

// MARK: - ClearCacheResult message Tests

@Suite("ClearCacheResult message Tests")
struct ClearCacheResultMessageTests {

    @Test("message should indicate success when successful")
    func testSuccessMessage() {
        // Arrange
        let result = ClearCacheResult(
            success: true,
            clearedSize: 1024,
            formattedClearedSize: "1 KB",
            errors: [],
            timestamp: Date()
        )

        // Act
        let message = result.message

        // Assert
        #expect(message == "Successfully cleared 1 KB")
    }

    @Test("message should indicate partial success with errors")
    func testPartialSuccessMessage() {
        // Arrange
        let result = ClearCacheResult(
            success: false,
            clearedSize: 500,
            formattedClearedSize: "500 bytes",
            errors: ["Some error"],
            timestamp: Date()
        )

        // Act
        let message = result.message

        // Assert
        #expect(message == "Cleared 500 bytes with some errors")
    }

    @Test("message should be generic when no details")
    func testGenericMessage() {
        // Arrange
        let result = ClearCacheResult(
            success: false,
            clearedSize: 0,
            formattedClearedSize: "0 bytes",
            errors: [],
            timestamp: Date()
        )

        // Act
        let message = result.message

        // Assert
        #expect(message == "Cache cleared")
    }
}

// MARK: - CacheType Tests

@Suite("CacheType Tests")
struct CacheTypeTests {

    @Test("CacheType.managed should exist")
    func testManagedExists() {
        // Arrange & Act
        let type = CacheType.managed

        // Assert
        #expect(type == .managed)
    }

    @Test("CacheType.images should exist")
    func testImagesExists() {
        // Arrange & Act
        let type = CacheType.images

        // Assert
        #expect(type == .images)
    }

    @Test("CacheType.temporary should exist")
    func testTemporaryExists() {
        // Arrange & Act
        let type = CacheType.temporary

        // Assert
        #expect(type == .temporary)
    }

    @Test("CacheType.system should exist")
    func testSystemExists() {
        // Arrange & Act
        let type = CacheType.system

        // Assert
        #expect(type == .system)
    }

    @Test("CacheType.all should exist")
    func testAllExists() {
        // Arrange & Act
        let type = CacheType.all

        // Assert
        #expect(type == .all)
    }

    @Test("All cache types should be different")
    func testAllTypesAreDifferent() {
        // Arrange
        let types: [CacheType] = [.managed, .images, .temporary, .system, .all]

        // Act & Assert
        for i in 0..<types.count {
            for j in (i+1)..<types.count {
                #expect(types[i] != types[j])
            }
        }
    }
}

// MARK: - CacheType Equality Tests

@Suite("CacheType Equality Tests")
struct CacheTypeEqualityTests {

    @Test("Same cache type should be equal")
    func testSameTypeEquality() {
        // Arrange
        let type1 = CacheType.images
        let type2 = CacheType.images

        // Assert
        #expect(type1 == type2)
    }

    @Test("Different cache types should not be equal")
    func testDifferentTypeInequality() {
        // Arrange
        let managed = CacheType.managed
        let images = CacheType.images

        // Assert
        #expect(managed != images)
    }
}

// MARK: - Cache Structs Integration Tests

@Suite("Cache Structs Integration Tests")
struct CacheStructsIntegrationTests {

    @Test("Should create complete cache info with breakdown")
    func testCompleteCacheInfo() {
        // Arrange
        var breakdown = CacheSizeBreakdown()
        breakdown.managedCache = 1_000_000
        breakdown.imageCache = 2_000_000
        breakdown.systemCache = 500_000
        breakdown.temporaryFiles = 100_000
        breakdown.coreDataCache = 300_000

        let totalSize: Int64 = breakdown.managedCache +
                               breakdown.imageCache +
                               breakdown.systemCache +
                               breakdown.temporaryFiles +
                               breakdown.coreDataCache

        // Act
        let info = CacheSizeInfo(
            totalSize: totalSize,
            formattedSize: "3.9 MB",
            breakdown: breakdown,
            lastCalculated: Date()
        )

        // Assert
        #expect(info.totalSize == 3_900_000)
        #expect(!info.isEmpty)
        #expect(info.breakdown.hasDetails)
    }

    @Test("Should handle cache clear workflow")
    func testCacheClearWorkflow() {
        // Arrange - Simula estado inicial
        var breakdown = CacheSizeBreakdown()
        breakdown.imageCache = 1_000_000

        let initialInfo = CacheSizeInfo(
            totalSize: 1_000_000,
            formattedSize: "1 MB",
            breakdown: breakdown,
            lastCalculated: Date()
        )

        // Act - Simula limpeza bem-sucedida
        let clearResult = ClearCacheResult(
            success: true,
            clearedSize: 1_000_000,
            formattedClearedSize: "1 MB",
            errors: [],
            timestamp: Date()
        )

        // Assert
        #expect(!initialInfo.isEmpty)
        #expect(clearResult.success)
        #expect(clearResult.message.contains("Successfully"))
    }
}
