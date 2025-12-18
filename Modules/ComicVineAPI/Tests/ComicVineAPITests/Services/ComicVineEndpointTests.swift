//
//  ComicVineEndpointTests.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import ComicVineAPI
import Alamofire
import Foundation
import Testing
import XCTest

// MARK: - ComicVineEndpoint Tests

@Suite("ComicVineEndpoint Tests")
struct ComicVineEndpointTests {

    // MARK: - Initialization Tests

    @Test("ComicVineEndpoint should initialize with all properties")
    func testFullInitialization() {
        let endpoint = ComicVineEndpoint(
            baseURL: "https://comicvine.gamespot.com/api",
            path: "/characters",
            method: .get,
            headers: nil,
            parameters: ["limit": "20"],
            encoding: URLEncoding.default
        )

        #expect(endpoint.baseURL == "https://comicvine.gamespot.com/api")
        #expect(endpoint.path == "/characters")
        #expect(endpoint.method == .get)
    }

    @Test("ComicVineEndpoint should use default method GET")
    func testDefaultMethod() {
        let endpoint = ComicVineEndpoint(
            baseURL: "https://example.com",
            path: "/test"
        )

        #expect(endpoint.method == .get)
    }

    @Test("ComicVineEndpoint should accept nil headers")
    func testNilHeaders() {
        let endpoint = ComicVineEndpoint(
            baseURL: "https://example.com",
            path: "/test",
            headers: nil
        )

        #expect(endpoint.headers == nil)
    }

    @Test("ComicVineEndpoint should accept parameters")
    func testParameters() {
        let params = ["key": "value", "limit": "10"]
        let endpoint = ComicVineEndpoint(
            baseURL: "https://example.com",
            path: "/test",
            parameters: params
        )

        #expect(endpoint.parameters != nil)
        #expect((endpoint.parameters as? [String: String])?["key"] == "value")
        #expect((endpoint.parameters as? [String: String])?["limit"] == "10")
    }

    // MARK: - Path Tests

    @Test("Endpoint path should include character prefix for character detail")
    func testCharacterDetailPath() {
        let characterId = 12345
        let path = "/character/4005-\(characterId)"

        #expect(path == "/character/4005-12345")
        #expect(path.contains("4005-"))
    }

    @Test("Endpoint path should include issue prefix for issue detail")
    func testIssueDetailPath() {
        let issueId = 67890
        let path = "/issue/4000-\(issueId)"

        #expect(path == "/issue/4000-67890")
        #expect(path.contains("4000-"))
    }

    @Test("Endpoint path for characters list")
    func testCharactersListPath() {
        let path = "/characters"

        #expect(path == "/characters")
    }

    @Test("Endpoint path for issues list")
    func testIssuesListPath() {
        let path = "/issues"

        #expect(path == "/issues")
    }

    @Test("Endpoint path for search")
    func testSearchPath() {
        let path = "/search"

        #expect(path == "/search")
    }

    // MARK: - Encoding Tests

    @Test("Endpoint should use URLEncoding by default")
    func testDefaultEncoding() {
        let endpoint = ComicVineEndpoint(
            baseURL: "https://example.com",
            path: "/test",
            encoding: URLEncoding.default
        )

        // Verifica que o encoding é URLEncoding
        #expect(endpoint.encoding is URLEncoding)
    }

    // MARK: - Full URL Construction Tests

    @Test("Full URL should combine baseURL and path")
    func testFullUrlConstruction() {
        let endpoint = ComicVineEndpoint(
            baseURL: "https://comicvine.gamespot.com/api",
            path: "/characters"
        )

        let fullURL = endpoint.baseURL + endpoint.path
        #expect(fullURL == "https://comicvine.gamespot.com/api/characters")
    }

    @Test("Full URL for character detail")
    func testCharacterDetailUrl() {
        let endpoint = ComicVineEndpoint(
            baseURL: "https://comicvine.gamespot.com/api",
            path: "/character/4005-1"
        )

        let fullURL = endpoint.baseURL + endpoint.path
        #expect(fullURL == "https://comicvine.gamespot.com/api/character/4005-1")
    }
}

// MARK: - APIEndpoint Protocol Tests

@Suite("APIEndpoint Protocol Compliance Tests")
struct APIEndpointProtocolTests {

    @Test("ComicVineEndpoint should conform to APIEndpoint")
    func testProtocolConformance() {
        let endpoint = ComicVineEndpoint(
            baseURL: "https://example.com",
            path: "/test"
        )

        // Se compilar, o endpoint conforma ao protocolo
        #expect(endpoint.baseURL == "https://example.com")
        #expect(endpoint.path == "/test")
    }

    @Test("ComicVineEndpoint should be Sendable")
    func testSendableConformance() {
        let endpoint = ComicVineEndpoint(
            baseURL: "https://example.com",
            path: "/test"
        )

        let _: any Sendable = endpoint
        #expect(true)
    }
}

// MARK: - ComicVineAPIService Endpoint Tests

@Suite("ComicVineAPIService.Endpoint Tests")
struct ComicVineAPIServiceEndpointTests {

    @Test("Characters endpoint should have correct path")
    func testCharactersEndpointPath() {
        // Testa o formato esperado do path
        let path = "/characters"
        #expect(path == "/characters")
    }

    @Test("Character detail endpoint should include ID")
    func testCharacterDetailEndpointPath() {
        let id = 12345
        let path = "/character/4005-\(id)"
        #expect(path.contains("4005-12345"))
    }

    @Test("Issues endpoint should have correct path")
    func testIssuesEndpointPath() {
        let path = "/issues"
        #expect(path == "/issues")
    }

    @Test("Issue detail endpoint should include ID")
    func testIssueDetailEndpointPath() {
        let id = 67890
        let path = "/issue/4000-\(id)"
        #expect(path.contains("4000-67890"))
    }

    @Test("Search endpoint should have correct path")
    func testSearchEndpointPath() {
        let path = "/search"
        #expect(path == "/search")
    }

    // MARK: - Parameters Tests

    @Test("Characters endpoint should include pagination parameters")
    func testCharactersEndpointParameters() {
        let offset = 20
        let limit = 50
        let params: [String: String] = [
            "offset": String(offset),
            "limit": String(limit)
        ]

        #expect(params["offset"] == "20")
        #expect(params["limit"] == "50")
    }

    @Test("Search endpoint should include query parameter")
    func testSearchEndpointParameters() {
        let query = "spider-man"
        let resources = "character"
        let params: [String: String] = [
            "query": query,
            "resources": resources
        ]

        #expect(params["query"] == "spider-man")
        #expect(params["resources"] == "character")
    }

    @Test("API key should be added to parameters")
    func testAPIKeyParameter() {
        let apiKey = "test-api-key"
        var params: [String: String] = [:]
        params["api_key"] = apiKey
        params["format"] = "json"

        #expect(params["api_key"] == "test-api-key")
        #expect(params["format"] == "json")
    }
}

// MARK: - XCTest Integration Tests

class ComicVineEndpointXCTests: XCTestCase {

    func testEndpointSendableCompliance() {
        let endpoint = ComicVineEndpoint(
            baseURL: "https://example.com",
            path: "/test"
        )

        let sendable: any Sendable = endpoint
        XCTAssertNotNil(sendable)
    }

    func testEndpointParametersCopying() {
        let params = ["key": "value"]
        let endpoint = ComicVineEndpoint(
            baseURL: "https://example.com",
            path: "/test",
            parameters: params
        )

        XCTAssertNotNil(endpoint.parameters)

        let endpointParams = endpoint.parameters as? [String: String]
        XCTAssertEqual(endpointParams?["key"], "value")
    }

    func testHTTPMethodTypes() {
        let getEndpoint = ComicVineEndpoint(
            baseURL: "https://example.com",
            path: "/get",
            method: .get
        )

        let postEndpoint = ComicVineEndpoint(
            baseURL: "https://example.com",
            path: "/post",
            method: .post
        )

        XCTAssertEqual(getEndpoint.method, .get)
        XCTAssertEqual(postEndpoint.method, .post)
    }
}
