//
//  ImageQualityTests.swift
//  Settings
//
//  Created by Ivan Tonial IP.TV on 17/12/25.
//

@testable import Settings
import Testing

// MARK: - ImageQuality Initialization Tests

@Suite("ImageQuality Initialization Tests")
struct ImageQualityInitializationTests {

    @Test("ImageQuality.low should exist")
    func testLowExists() {
        // Arrange & Act
        let quality = ImageQuality.low

        // Assert
        #expect(quality == .low)
    }

    @Test("ImageQuality.medium should exist")
    func testMediumExists() {
        // Arrange & Act
        let quality = ImageQuality.medium

        // Assert
        #expect(quality == .medium)
    }

    @Test("ImageQuality.high should exist")
    func testHighExists() {
        // Arrange & Act
        let quality = ImageQuality.high

        // Assert
        #expect(quality == .high)
    }
}

// MARK: - ImageQuality RawValue Tests

@Suite("ImageQuality RawValue Tests")
struct ImageQualityRawValueTests {

    @Test("Low quality should have 'Low' raw value")
    func testLowRawValue() {
        // Arrange
        let quality = ImageQuality.low

        // Act
        let rawValue = quality.rawValue

        // Assert
        #expect(rawValue == "Low")
    }

    @Test("Medium quality should have 'Medium' raw value")
    func testMediumRawValue() {
        // Arrange
        let quality = ImageQuality.medium

        // Act
        let rawValue = quality.rawValue

        // Assert
        #expect(rawValue == "Medium")
    }

    @Test("High quality should have 'High' raw value")
    func testHighRawValue() {
        // Arrange
        let quality = ImageQuality.high

        // Act
        let rawValue = quality.rawValue

        // Assert
        #expect(rawValue == "High")
    }

    @Test("Should initialize from raw value")
    func testInitFromRawValue() {
        // Act
        let low = ImageQuality(rawValue: "Low")
        let medium = ImageQuality(rawValue: "Medium")
        let high = ImageQuality(rawValue: "High")

        // Assert
        #expect(low == .low)
        #expect(medium == .medium)
        #expect(high == .high)
    }

    @Test("Should return nil for invalid raw value")
    func testInvalidRawValue() {
        // Act
        let invalid = ImageQuality(rawValue: "Invalid")

        // Assert
        #expect(invalid == nil)
    }
}

// MARK: - ImageQuality Title Tests

@Suite("ImageQuality Title Tests")
struct ImageQualityTitleTests {

    @Test("Low quality title should be 'Low'")
    func testLowTitle() {
        // Arrange
        let quality = ImageQuality.low

        // Act
        let title = quality.title

        // Assert
        #expect(title == "Low")
    }

    @Test("Medium quality title should be 'Medium'")
    func testMediumTitle() {
        // Arrange
        let quality = ImageQuality.medium

        // Act
        let title = quality.title

        // Assert
        #expect(title == "Medium")
    }

    @Test("High quality title should be 'High'")
    func testHighTitle() {
        // Arrange
        let quality = ImageQuality.high

        // Act
        let title = quality.title

        // Assert
        #expect(title == "High")
    }

    @Test("Title should equal raw value")
    func testTitleEqualsRawValue() {
        // Assert
        for quality in ImageQuality.allCases {
            #expect(quality.title == quality.rawValue)
        }
    }
}

// MARK: - ImageQuality Description Tests

@Suite("ImageQuality Description Tests")
struct ImageQualityDescriptionTests {

    @Test("Low quality should have data saving description")
    func testLowDescription() {
        // Arrange
        let quality = ImageQuality.low

        // Act
        let description = quality.description

        // Assert
        #expect(description == "Saves data, lower quality")
    }

    @Test("Medium quality should have balanced description")
    func testMediumDescription() {
        // Arrange
        let quality = ImageQuality.medium

        // Act
        let description = quality.description

        // Assert
        #expect(description == "Balanced quality and data")
    }

    @Test("High quality should have best quality description")
    func testHighDescription() {
        // Arrange
        let quality = ImageQuality.high

        // Act
        let description = quality.description

        // Assert
        #expect(description == "Best quality, uses more data")
    }

    @Test("All descriptions should be non-empty")
    func testAllDescriptionsNonEmpty() {
        // Assert
        for quality in ImageQuality.allCases {
            #expect(!quality.description.isEmpty)
        }
    }

    @Test("All descriptions should be different")
    func testAllDescriptionsAreDifferent() {
        // Arrange
        let lowDesc = ImageQuality.low.description
        let mediumDesc = ImageQuality.medium.description
        let highDesc = ImageQuality.high.description

        // Assert
        #expect(lowDesc != mediumDesc)
        #expect(lowDesc != highDesc)
        #expect(mediumDesc != highDesc)
    }
}

// MARK: - ImageQuality CaseIterable Tests

@Suite("ImageQuality CaseIterable Tests")
struct ImageQualityCaseIterableTests {

    @Test("allCases should contain exactly 3 cases")
    func testAllCasesCount() {
        // Act
        let allCases = ImageQuality.allCases

        // Assert
        #expect(allCases.count == 3)
    }

    @Test("allCases should contain all quality levels")
    func testAllCasesContainsAll() {
        // Act
        let allCases = ImageQuality.allCases

        // Assert
        #expect(allCases.contains(.low))
        #expect(allCases.contains(.medium))
        #expect(allCases.contains(.high))
    }

    @Test("allCases order should be low, medium, high")
    func testAllCasesOrder() {
        // Act
        let allCases = ImageQuality.allCases

        // Assert
        #expect(allCases[0] == .low)
        #expect(allCases[1] == .medium)
        #expect(allCases[2] == .high)
    }
}

// MARK: - ImageQuality Equality Tests

@Suite("ImageQuality Equality Tests")
struct ImageQualityEqualityTests {

    @Test("Same quality should be equal")
    func testSameQualityEquality() {
        // Arrange
        let quality1 = ImageQuality.high
        let quality2 = ImageQuality.high

        // Assert
        #expect(quality1 == quality2)
    }

    @Test("Different qualities should not be equal")
    func testDifferentQualityInequality() {
        // Arrange
        let low = ImageQuality.low
        let medium = ImageQuality.medium
        let high = ImageQuality.high

        // Assert
        #expect(low != medium)
        #expect(low != high)
        #expect(medium != high)
    }
}

// MARK: - ImageQuality Hashable Tests

@Suite("ImageQuality Hashable Tests")
struct ImageQualityHashableTests {

    @Test("ImageQuality should be hashable")
    func testHashable() {
        // Arrange
        var set = Set<ImageQuality>()

        // Act
        set.insert(.low)
        set.insert(.medium)
        set.insert(.high)
        set.insert(.low) // Duplicate

        // Assert
        #expect(set.count == 3)
    }

    @Test("Same qualities should have same hash")
    func testSameQualityHash() {
        // Arrange
        let quality1 = ImageQuality.medium
        let quality2 = ImageQuality.medium

        // Assert
        #expect(quality1.hashValue == quality2.hashValue)
    }
}

// MARK: - ImageQuality UserDefaults Integration Tests

@Suite("ImageQuality UserDefaults Integration Tests")
struct ImageQualityUserDefaultsTests {

    @Test("Should be storable and retrievable from raw value")
    func testStorageRoundTrip() {
        // Arrange
        let original = ImageQuality.medium

        // Act - Simulate storing to UserDefaults
        let storedValue = original.rawValue
        let retrieved = ImageQuality(rawValue: storedValue)

        // Assert
        #expect(retrieved == original)
    }

    @Test("All qualities should be storable")
    func testAllQualitiesStorable() {
        // Assert
        for quality in ImageQuality.allCases {
            let rawValue = quality.rawValue
            let retrieved = ImageQuality(rawValue: rawValue)
            #expect(retrieved == quality)
        }
    }
}
