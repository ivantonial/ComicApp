//
//  UnknownCaseRepresentableTests.swift
//  Core
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import Core
import Foundation
import Testing
import XCTest

// MARK: - Test Enums

/// Enum de teste que implementa UnknownCaseRepresentable
private enum TestStatus: String, Decodable, CaseIterable, UnknownCaseRepresentable {
    case active
    case inactive
    case pending
    case unknown

    static let unknownCase = Self.unknown
}

/// Enum de teste com valores Int
private enum TestPriority: Int, Decodable, CaseIterable, UnknownCaseRepresentable {
    case low = 1
    case medium = 2
    case high = 3
    case unknown = 0

    static let unknownCase = Self.unknown
}

/// Enum de teste para content types (exemplo do WIKI)
private enum ContentType: String, Decodable, CaseIterable, UnknownCaseRepresentable {
    case text
    case link
    case image
    case video
    case unknown

    static let unknownCase = Self.unknown
}

// MARK: - UnknownCaseRepresentable Protocol Tests

@Suite("UnknownCaseRepresentable Protocol Tests")
struct UnknownCaseRepresentableProtocolTests {

    // MARK: - String-based Enum Tests

    @Test("Should decode known string value correctly")
    func testDecodeKnownStringValue() throws {
        let json = "\"active\""
        let data = json.data(using: .utf8)!

        let status = try JSONDecoder().decode(TestStatus.self, from: data)

        #expect(status == .active)
    }

    @Test("Should decode all known string values")
    func testDecodeAllKnownStringValues() throws {
        let testCases: [(json: String, expected: TestStatus)] = [
            ("\"active\"", .active),
            ("\"inactive\"", .inactive),
            ("\"pending\"", .pending)
        ]

        for testCase in testCases {
            let data = testCase.json.data(using: .utf8)!
            let status = try JSONDecoder().decode(TestStatus.self, from: data)
            #expect(status == testCase.expected)
        }
    }

    @Test("Should decode unknown string value to unknownCase")
    func testDecodeUnknownStringValue() throws {
        let json = "\"invalid_status\""
        let data = json.data(using: .utf8)!

        let status = try JSONDecoder().decode(TestStatus.self, from: data)

        #expect(status == .unknown)
    }

    @Test("Should decode empty string to unknownCase")
    func testDecodeEmptyStringValue() throws {
        let json = "\"\""
        let data = json.data(using: .utf8)!

        let status = try JSONDecoder().decode(TestStatus.self, from: data)

        #expect(status == .unknown)
    }

    @Test("Should decode random string to unknownCase")
    func testDecodeRandomStringValue() throws {
        let json = "\"xyz123_random_value\""
        let data = json.data(using: .utf8)!

        let status = try JSONDecoder().decode(TestStatus.self, from: data)

        #expect(status == .unknown)
    }

    // MARK: - Int-based Enum Tests

    @Test("Should decode known int value correctly")
    func testDecodeKnownIntValue() throws {
        let json = "2"
        let data = json.data(using: .utf8)!

        let priority = try JSONDecoder().decode(TestPriority.self, from: data)

        #expect(priority == .medium)
    }

    @Test("Should decode all known int values")
    func testDecodeAllKnownIntValues() throws {
        let testCases: [(json: String, expected: TestPriority)] = [
            ("1", .low),
            ("2", .medium),
            ("3", .high)
        ]

        for testCase in testCases {
            let data = testCase.json.data(using: .utf8)!
            let priority = try JSONDecoder().decode(TestPriority.self, from: data)
            #expect(priority == testCase.expected)
        }
    }

    @Test("Should decode unknown int value to unknownCase")
    func testDecodeUnknownIntValue() throws {
        let json = "99"
        let data = json.data(using: .utf8)!

        let priority = try JSONDecoder().decode(TestPriority.self, from: data)

        #expect(priority == .unknown)
    }

    @Test("Should decode negative int value to unknownCase")
    func testDecodeNegativeIntValue() throws {
        let json = "-1"
        let data = json.data(using: .utf8)!

        let priority = try JSONDecoder().decode(TestPriority.self, from: data)

        #expect(priority == .unknown)
    }

    // MARK: - ContentType Tests (WIKI Example)

    @Test("ContentType should decode known values")
    func testContentTypeKnownValues() throws {
        let testCases: [(json: String, expected: ContentType)] = [
            ("\"text\"", .text),
            ("\"link\"", .link),
            ("\"image\"", .image),
            ("\"video\"", .video)
        ]

        for testCase in testCases {
            let data = testCase.json.data(using: .utf8)!
            let contentType = try JSONDecoder().decode(ContentType.self, from: data)
            #expect(contentType == testCase.expected)
        }
    }

    @Test("ContentType should decode unknown value to unknown case")
    func testContentTypeUnknownValue() throws {
        let json = "\"audio\""
        let data = json.data(using: .utf8)!

        let contentType = try JSONDecoder().decode(ContentType.self, from: data)

        #expect(contentType == .unknown)
    }

    @Test("ContentType should decode new API value to unknown case")
    func testContentTypeNewApiValue() throws {
        // Simula um novo tipo adicionado pela API que o app ainda não conhece
        let json = "\"interactive_3d\""
        let data = json.data(using: .utf8)!

        let contentType = try JSONDecoder().decode(ContentType.self, from: data)

        #expect(contentType == .unknown)
    }
}

// MARK: - Protocol Conformance Tests

@Suite("UnknownCaseRepresentable Conformance Tests")
struct UnknownCaseRepresentableConformanceTests {

    @Test("Enum should be CaseIterable")
    func testCaseIterable() {
        let allCases = TestStatus.allCases

        #expect(allCases.count == 4)
        #expect(allCases.contains(.active))
        #expect(allCases.contains(.inactive))
        #expect(allCases.contains(.pending))
        #expect(allCases.contains(.unknown))
    }

    @Test("Enum should have unknownCase static property")
    func testUnknownCaseProperty() {
        let unknownCase = TestStatus.unknownCase

        #expect(unknownCase == .unknown)
    }

    @Test("Enum should be RawRepresentable")
    func testRawRepresentable() {
        #expect(TestStatus.active.rawValue == "active")
        #expect(TestStatus.inactive.rawValue == "inactive")
        #expect(TestStatus.pending.rawValue == "pending")
        #expect(TestStatus.unknown.rawValue == "unknown")
    }

    @Test("Int enum should have correct raw values")
    func testIntEnumRawValues() {
        #expect(TestPriority.low.rawValue == 1)
        #expect(TestPriority.medium.rawValue == 2)
        #expect(TestPriority.high.rawValue == 3)
        #expect(TestPriority.unknown.rawValue == 0)
    }
}

// MARK: - JSON Object Decoding Tests

@Suite("UnknownCaseRepresentable in JSON Object Tests")
struct UnknownCaseRepresentableJSONObjectTests {

    private struct TestModel: Decodable {
        let id: Int
        let status: TestStatus
        let priority: TestPriority
    }

    @Test("Should decode enum inside JSON object with known values")
    func testDecodeInObjectKnownValues() throws {
        let json = """
        {
            "id": 1,
            "status": "active",
            "priority": 2
        }
        """
        let data = json.data(using: .utf8)!

        let model = try JSONDecoder().decode(TestModel.self, from: data)

        #expect(model.id == 1)
        #expect(model.status == .active)
        #expect(model.priority == .medium)
    }

    @Test("Should decode enum inside JSON object with unknown values")
    func testDecodeInObjectUnknownValues() throws {
        let json = """
        {
            "id": 1,
            "status": "new_status",
            "priority": 999
        }
        """
        let data = json.data(using: .utf8)!

        let model = try JSONDecoder().decode(TestModel.self, from: data)

        #expect(model.id == 1)
        #expect(model.status == .unknown)
        #expect(model.priority == .unknown)
    }
}

// MARK: - XCTest Integration Tests

class UnknownCaseRepresentableXCTests: XCTestCase {

    func testDecodingDoesNotThrowForUnknownValues() {
        let unknownValues = [
            "\"random\"",
            "\"123abc\"",
            "\"ACTIVE\"", // Case sensitive
            "\"Active\"",
            "\"\"",
            "\"   \"" // Whitespace
        ]

        for json in unknownValues {
            let data = json.data(using: .utf8)!

            XCTAssertNoThrow(
                try JSONDecoder().decode(TestStatus.self, from: data),
                "Should not throw for: \(json)"
            )
        }
    }

    func testAllUnknownValuesMapToUnknownCase() {
        let unknownValues = [
            "\"random\"",
            "\"new_api_value\"",
            "\"deprecated_value\"",
            "\"future_feature\""
        ]

        for json in unknownValues {
            let data = json.data(using: .utf8)!

            do {
                let status = try JSONDecoder().decode(TestStatus.self, from: data)
                XCTAssertEqual(status, .unknown, "Should be unknown for: \(json)")
            } catch {
                XCTFail("Should not throw for: \(json)")
            }
        }
    }

    func testProtocolRequirements() {
        // Verifica que o protocolo requer RawRepresentable
        XCTAssertEqual(TestStatus.active.rawValue, "active")

        // Verifica que o protocolo requer CaseIterable
        XCTAssertEqual(TestStatus.allCases.count, 4)

        // Verifica que o protocolo requer unknownCase
        XCTAssertEqual(TestStatus.unknownCase, .unknown)
    }

    func testBackwardCompatibility() {
        // Simula cenário onde API retorna novo valor que o app não conhece
        // O app não deve crashar, apenas usar unknownCase

        let futureApiResponse = """
        {
            "id": 1,
            "status": "archived",
            "priority": 10
        }
        """

        struct TestModel: Decodable {
            let id: Int
            let status: TestStatus
            let priority: TestPriority
        }

        let data = futureApiResponse.data(using: .utf8)!

        XCTAssertNoThrow {
            let model = try JSONDecoder().decode(TestModel.self, from: data)
            XCTAssertEqual(model.status, .unknown)
            XCTAssertEqual(model.priority, .unknown)
        }
    }
}
