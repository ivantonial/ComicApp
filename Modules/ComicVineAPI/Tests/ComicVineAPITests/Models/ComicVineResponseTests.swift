//
//  ComicVineResponseTests.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import ComicVineAPI
import Foundation
import Testing
import XCTest

// MARK: - Test Helper Struct

/// Estrutura simples para testes de ComicVineResponse
private struct SimpleTestModel: Decodable, Sendable {
    let id: Int
    let name: String
}

// MARK: - ComicVineResponse Tests

@Suite("ComicVineResponse Tests")
struct ComicVineResponseTests {

    // MARK: - Decoding Array Results Tests

    @Test("ComicVineResponse should decode array results")
    func testDecodeArrayResults() throws {
        let json = """
        {
            "error": "OK",
            "status_code": 1,
            "limit": 20,
            "offset": 0,
            "number_of_page_results": 2,
            "number_of_total_results": 100,
            "results": [
                {"id": 1, "name": "Item 1"},
                {"id": 2, "name": "Item 2"}
            ]
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(ComicVineResponse<SimpleTestModel>.self, from: data)

        #expect(response.results.count == 2)
        #expect(response.results[0].id == 1)
        #expect(response.results[1].id == 2)
    }

    @Test("ComicVineResponse should decode single object result as array")
    func testDecodeSingleObjectAsArray() throws {
        let json = """
        {
            "error": "OK",
            "status_code": 1,
            "limit": 1,
            "offset": 0,
            "number_of_page_results": 1,
            "number_of_total_results": 1,
            "results": {"id": 1, "name": "Single Item"}
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(ComicVineResponse<SimpleTestModel>.self, from: data)

        #expect(response.results.count == 1)
        #expect(response.results[0].id == 1)
        #expect(response.results[0].name == "Single Item")
    }

    @Test("ComicVineResponse should decode empty array results")
    func testDecodeEmptyArray() throws {
        let json = """
        {
            "error": "OK",
            "status_code": 1,
            "limit": 20,
            "offset": 0,
            "number_of_page_results": 0,
            "number_of_total_results": 0,
            "results": []
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(ComicVineResponse<SimpleTestModel>.self, from: data)

        #expect(response.results.isEmpty)
    }

    // MARK: - Response Metadata Tests

    @Test("ComicVineResponse should decode all metadata fields")
    func testDecodeMetadata() throws {
        let json = """
        {
            "error": "OK",
            "status_code": 1,
            "limit": 50,
            "offset": 100,
            "number_of_page_results": 50,
            "number_of_total_results": 500,
            "results": []
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(ComicVineResponse<SimpleTestModel>.self, from: data)

        #expect(response.error == "OK")
        #expect(response.statusCode == 1)
        #expect(response.limit == 50)
        #expect(response.offset == 100)
        #expect(response.numberOfPageResults == 50)
        #expect(response.numberOfTotalResults == 500)
    }

    // MARK: - isSuccess Tests

    @Test("isSuccess should return true for successful response")
    func testIsSuccessTrue() throws {
        let json = """
        {
            "error": "OK",
            "status_code": 1,
            "limit": 20,
            "offset": 0,
            "number_of_page_results": 0,
            "number_of_total_results": 0,
            "results": []
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(ComicVineResponse<SimpleTestModel>.self, from: data)

        #expect(response.isSuccess == true)
    }

    @Test("isSuccess should return false for error status code")
    func testIsSuccessFalseStatusCode() throws {
        let json = """
        {
            "error": "OK",
            "status_code": 100,
            "limit": 20,
            "offset": 0,
            "number_of_page_results": 0,
            "number_of_total_results": 0,
            "results": []
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(ComicVineResponse<SimpleTestModel>.self, from: data)

        #expect(response.isSuccess == false)
    }

    @Test("isSuccess should return false for error message")
    func testIsSuccessFalseErrorMessage() throws {
        let json = """
        {
            "error": "Invalid API Key",
            "status_code": 1,
            "limit": 20,
            "offset": 0,
            "number_of_page_results": 0,
            "number_of_total_results": 0,
            "results": []
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(ComicVineResponse<SimpleTestModel>.self, from: data)

        #expect(response.isSuccess == false)
    }

    // MARK: - errorMessage Tests

    @Test("errorMessage should return nil for successful response")
    func testErrorMessageNil() throws {
        let json = """
        {
            "error": "OK",
            "status_code": 1,
            "limit": 20,
            "offset": 0,
            "number_of_page_results": 0,
            "number_of_total_results": 0,
            "results": []
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(ComicVineResponse<SimpleTestModel>.self, from: data)

        #expect(response.errorMessage == nil)
    }

    @Test("errorMessage should return formatted message for error")
    func testErrorMessageFormatted() throws {
        let json = """
        {
            "error": "Invalid API Key",
            "status_code": 100,
            "limit": 20,
            "offset": 0,
            "number_of_page_results": 0,
            "number_of_total_results": 0,
            "results": []
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(ComicVineResponse<SimpleTestModel>.self, from: data)

        #expect(response.errorMessage?.contains("Invalid API Key") == true)
        #expect(response.errorMessage?.contains("100") == true)
    }

    // MARK: - firstResult Tests

    @Test("firstResult should return first item when available")
    func testFirstResultExists() throws {
        let json = """
        {
            "error": "OK",
            "status_code": 1,
            "limit": 20,
            "offset": 0,
            "number_of_page_results": 2,
            "number_of_total_results": 2,
            "results": [
                {"id": 1, "name": "First"},
                {"id": 2, "name": "Second"}
            ]
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(ComicVineResponse<SimpleTestModel>.self, from: data)

        #expect(response.firstResult?.id == 1)
        #expect(response.firstResult?.name == "First")
    }

    @Test("firstResult should return nil for empty results")
    func testFirstResultEmpty() throws {
        let json = """
        {
            "error": "OK",
            "status_code": 1,
            "limit": 20,
            "offset": 0,
            "number_of_page_results": 0,
            "number_of_total_results": 0,
            "results": []
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(ComicVineResponse<SimpleTestModel>.self, from: data)

        #expect(response.firstResult == nil)
    }
}

// MARK: - ComicVineResponse with Character Tests

@Suite("ComicVineResponse Character Tests")
struct ComicVineResponseCharacterTests {

    @Test("Should decode Character array response")
    func testDecodeCharacterArray() throws {
        let json = """
        {
            "error": "OK",
            "status_code": 1,
            "limit": 20,
            "offset": 0,
            "number_of_page_results": 1,
            "number_of_total_results": 1,
            "results": [
                {
                    "id": 1,
                    "name": "Spider-Man",
                    "image": {},
                    "api_detail_url": "https://test.com",
                    "site_detail_url": "https://test.com",
                    "count_of_issue_appearances": 100,
                    "date_added": "2024-01-01 00:00:00",
                    "date_last_updated": "2024-01-01 00:00:00"
                }
            ]
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(ComicVineResponse<Character>.self, from: data)

        #expect(response.results.count == 1)
        #expect(response.results[0].name == "Spider-Man")
    }

    @Test("Should decode single Character response")
    func testDecodeSingleCharacter() throws {
        let json = """
        {
            "error": "OK",
            "status_code": 1,
            "limit": 1,
            "offset": 0,
            "number_of_page_results": 1,
            "number_of_total_results": 1,
            "results": {
                "id": 1,
                "name": "Batman",
                "image": {},
                "api_detail_url": "https://test.com",
                "site_detail_url": "https://test.com",
                "count_of_issue_appearances": 200,
                "date_added": "2024-01-01 00:00:00",
                "date_last_updated": "2024-01-01 00:00:00"
            }
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(ComicVineResponse<Character>.self, from: data)

        #expect(response.results.count == 1)
        #expect(response.results[0].name == "Batman")
    }
}

// MARK: - XCTest Integration Tests

class ComicVineResponseXCTests: XCTestCase {

    func testResponseSendableCompliance() throws {
        let json = """
        {
            "error": "OK",
            "status_code": 1,
            "limit": 20,
            "offset": 0,
            "number_of_page_results": 0,
            "number_of_total_results": 0,
            "results": []
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(ComicVineResponse<Character>.self, from: data)

        let sendable: any Sendable = response
        XCTAssertNotNil(sendable)
    }

    func testStatusCodeMapping() throws {
        // Status code 1 = success
        // Status codes > 1 = various errors

        let successJSON = """
        {"error": "OK", "status_code": 1, "limit": 20, "offset": 0, "number_of_page_results": 0, "number_of_total_results": 0, "results": []}
        """

        let errorJSON = """
        {"error": "Error", "status_code": 100, "limit": 20, "offset": 0, "number_of_page_results": 0, "number_of_total_results": 0, "results": []}
        """

        let successResponse = try JSONDecoder().decode(
            ComicVineResponse<Character>.self,
            from: successJSON.data(using: .utf8)!
        )
        let errorResponse = try JSONDecoder().decode(
            ComicVineResponse<Character>.self,
            from: errorJSON.data(using: .utf8)!
        )

        XCTAssertTrue(successResponse.isSuccess)
        XCTAssertFalse(errorResponse.isSuccess)
    }
}
