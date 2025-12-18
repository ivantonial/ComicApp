//
//  FixtureValidationTests.swift
//  Networking
//
//  Created by Ivan Tonial IP.TV on 17/12/25.
//
//  Testes de validação das fixtures do módulo Networking.
//  Garante que todas as fixtures estão corretas e funcionais.
//

import Alamofire
@testable import Networking
import Foundation
import Testing

// MARK: - MockEndpoint Fixture Validation Tests

@Suite("MockEndpoint Fixture Validation Tests")
struct MockEndpointFixtureValidationTests {

    @Test("Default fixture should create valid endpoint")
    func testDefaultFixture() {
        // Act
        let endpoint = MockEndpoint.defaultFixture()

        // Assert
        #expect(endpoint.baseURL.isEmpty == false)
        #expect(endpoint.path.isEmpty == false)
        #expect(endpoint.baseURL.hasPrefix("https://"))
    }

    @Test("Invalid URL fixture should have empty values")
    func testInvalidURLFixture() {
        // Act
        let endpoint = MockEndpoint.invalidURLFixture()

        // Assert
        #expect(endpoint.baseURL.isEmpty)
        #expect(endpoint.path.isEmpty)
    }

    @Test("GET with parameters fixture should have correct method and parameters")
    func testGetWithParametersFixture() {
        // Arrange
        let params: Parameters = ["query": "test", "limit": 10]

        // Act
        let endpoint = MockEndpoint.getWithParametersFixture(parameters: params)

        // Assert
        #expect(endpoint.method == .get)
        #expect(endpoint.parameters != nil)
        #expect(endpoint.parameters?["query"] as? String == "test")
        #expect(endpoint.parameters?["limit"] as? Int == 10)
    }

    @Test("POST fixture should have correct method and headers")
    func testPostFixture() {
        // Arrange
        let params: Parameters = ["name": "Test", "value": 123]

        // Act
        let endpoint = MockEndpoint.postFixture(parameters: params)

        // Assert
        #expect(endpoint.method == .post)
        #expect(endpoint.headers != nil)
        #expect(endpoint.parameters != nil)
    }

    @Test("PUT fixture should have correct method and path with ID")
    func testPutFixture() {
        // Arrange
        let id = 42

        // Act
        let endpoint = MockEndpoint.putFixture(id: id)

        // Assert
        #expect(endpoint.method == .put)
        #expect(endpoint.path.contains("\(id)"))
    }

    @Test("DELETE fixture should have correct method and path with ID")
    func testDeleteFixture() {
        // Arrange
        let id = 99

        // Act
        let endpoint = MockEndpoint.deleteFixture(id: id)

        // Assert
        #expect(endpoint.method == .delete)
        #expect(endpoint.path.contains("\(id)"))
    }

    @Test("Authenticated fixture should have Authorization header")
    func testAuthenticatedFixture() {
        // Arrange
        let token = "my-secret-token"

        // Act
        let endpoint = MockEndpoint.authenticatedFixture(token: token)

        // Assert
        #expect(endpoint.headers != nil)

        let authHeader = endpoint.headers?.value(for: "Authorization")
        #expect(authHeader?.contains(token) == true)
        #expect(authHeader?.hasPrefix("Bearer ") == true)
    }

    @Test("Custom headers fixture should include all headers")
    func testCustomHeadersFixture() {
        // Arrange
        let headers = [
            "X-API-Key": "12345",
            "X-Request-ID": "abc-123",
            "Accept": "application/json"
        ]

        // Act
        let endpoint = MockEndpoint.customHeadersFixture(headers: headers)

        // Assert
        #expect(endpoint.headers != nil)
        #expect(endpoint.headers?.value(for: "X-API-Key") == "12345")
        #expect(endpoint.headers?.value(for: "X-Request-ID") == "abc-123")
        #expect(endpoint.headers?.value(for: "Accept") == "application/json")
    }

    @Test("Path fixture should use provided path")
    func testPathFixture() {
        // Arrange
        let paths = ["/users", "/posts/123", "/api/v2/items"]

        for path in paths {
            // Act
            let endpoint = MockEndpoint.pathFixture(path: path)

            // Assert
            #expect(endpoint.path == path)
        }
    }

    @Test("Base URL fixture should use provided base URL")
    func testBaseURLFixture() {
        // Arrange
        let baseURLs = [
            "https://api.github.com",
            "https://api.twitter.com",
            "http://localhost:8080"
        ]

        for baseURL in baseURLs {
            // Act
            let endpoint = MockEndpoint.baseURLFixture(baseURL: baseURL)

            // Assert
            #expect(endpoint.baseURL == baseURL)
        }
    }

    @Test("All HTTP methods should be supported")
    func testAllHTTPMethods() {
        // Arrange & Act
        let getEndpoint = MockEndpoint(method: .get)
        let postEndpoint = MockEndpoint(method: .post)
        let putEndpoint = MockEndpoint(method: .put)
        let deleteEndpoint = MockEndpoint(method: .delete)
        let patchEndpoint = MockEndpoint(method: .patch)

        // Assert
        #expect(getEndpoint.method == .get)
        #expect(postEndpoint.method == .post)
        #expect(putEndpoint.method == .put)
        #expect(deleteEndpoint.method == .delete)
        #expect(patchEndpoint.method == .patch)
    }
}

// MARK: - MockResponse Fixture Validation Tests

@Suite("MockResponse Fixture Validation Tests")
struct MockResponseFixtureValidationTests {

    @Test("Default fixture should have valid values")
    func testDefaultFixture() {
        // Act
        let response = MockResponse.defaultFixture()

        // Assert
        #expect(response.id > 0)
        #expect(response.name.isEmpty == false)
    }

    @Test("Fixture with ID should use provided ID")
    func testFixtureWithID() {
        // Arrange
        let ids = [1, 10, 100, 1000]

        for id in ids {
            // Act
            let response = MockResponse.fixture(id: id)

            // Assert
            #expect(response.id == id)
            #expect(response.name.contains("\(id)"))
        }
    }

    @Test("Custom fixture should use all provided values")
    func testCustomFixture() {
        // Arrange
        let id = 42
        let name = "Custom Name"

        // Act
        let response = MockResponse.fixture(id: id, name: name)

        // Assert
        #expect(response.id == id)
        #expect(response.name == name)
    }

    @Test("List fixtures should create correct count")
    func testListFixtures() {
        // Arrange
        let counts = [1, 5, 10, 20]

        for count in counts {
            // Act
            let responses = MockResponse.listFixtures(count: count)

            // Assert
            #expect(responses.count == count)

            // Verificar que IDs são sequenciais
            for (index, response) in responses.enumerated() {
                #expect(response.id == index + 1)
            }
        }
    }

    @Test("MockResponse should be Codable")
    func testCodable() throws {
        // Arrange
        let original = MockResponse.defaultFixture()

        // Act
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(MockResponse.self, from: data)

        // Assert
        #expect(decoded == original)
    }

    @Test("MockResponse should be Equatable")
    func testEquatable() {
        // Arrange
        let response1 = MockResponse(id: 1, name: "Test")
        let response2 = MockResponse(id: 1, name: "Test")
        let response3 = MockResponse(id: 2, name: "Different")

        // Assert
        #expect(response1 == response2)
        #expect(response1 != response3)
    }

    @Test("MockResponse should be Sendable")
    func testSendable() async {
        // Arrange
        let response = MockResponse.defaultFixture()

        // Act
        let result = await Task.detached {
            return response.name
        }.value

        // Assert
        #expect(result == response.name)
    }
}

// MARK: - MockDetailResponse Fixture Validation Tests

@Suite("MockDetailResponse Fixture Validation Tests")
struct MockDetailResponseFixtureValidationTests {

    @Test("Default fixture should have all fields populated")
    func testDefaultFixture() {
        // Act
        let response = MockDetailResponse.defaultFixture()

        // Assert
        #expect(response.id > 0)
        #expect(response.name.isEmpty == false)
        #expect(response.description != nil)
        #expect(response.createdAt != nil)
        #expect(response.tags.isEmpty == false)
        #expect(response.metadata != nil)
    }

    @Test("Minimal fixture should have only required fields")
    func testMinimalFixture() {
        // Act
        let response = MockDetailResponse.minimalFixture()

        // Assert
        #expect(response.id > 0)
        #expect(response.name.isEmpty == false)
        #expect(response.description == nil)
        #expect(response.createdAt == nil)
        #expect(response.tags.isEmpty)
        #expect(response.metadata == nil)
    }

    @Test("Custom fixture should use provided values")
    func testCustomFixture() {
        // Arrange
        let id = 99
        let name = "Custom Detail"
        let description = "Custom description"
        let tags = ["tag1", "tag2"]

        // Act
        let response = MockDetailResponse.fixture(
            id: id,
            name: name,
            description: description,
            tags: tags
        )

        // Assert
        #expect(response.id == id)
        #expect(response.name == name)
        #expect(response.description == description)
        #expect(response.tags == tags)
    }

    @Test("MockDetailResponse should be Codable with dates")
    func testCodableWithDates() throws {
        // Arrange
        let original = MockDetailResponse.defaultFixture()
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        // Act
        let data = try encoder.encode(original)
        let decoded = try decoder.decode(MockDetailResponse.self, from: data)

        // Assert
        #expect(decoded.id == original.id)
        #expect(decoded.name == original.name)
    }
}

// MARK: - MockPaginatedResponse Fixture Validation Tests

@Suite("MockPaginatedResponse Fixture Validation Tests")
struct MockPaginatedResponseFixtureValidationTests {

    @Test("First page fixture should have correct pagination")
    func testFirstPageFixture() {
        // Act
        let response = MockPaginatedResponse<MockResponse>.firstPageFixture()

        // Assert
        #expect(response.page == 1)
        #expect(response.hasMore == true)
        #expect(response.items.count == 10)
        #expect(response.totalCount > response.items.count)
    }

    @Test("Last page fixture should indicate no more pages")
    func testLastPageFixture() {
        // Act
        let response = MockPaginatedResponse<MockResponse>.lastPageFixture()

        // Assert
        #expect(response.hasMore == false)
        #expect(response.page > 1)
    }

    @Test("Empty page fixture should have no items")
    func testEmptyPageFixture() {
        // Act
        let response = MockPaginatedResponse<MockResponse>.emptyPageFixture()

        // Assert
        #expect(response.items.isEmpty)
        #expect(response.totalCount == 0)
        #expect(response.hasMore == false)
    }

    @Test("Custom fixture should calculate hasMore correctly")
    func testCustomFixtureHasMore() {
        // Test case where there are more items
        let withMore = MockPaginatedResponse<MockResponse>.fixture(
            items: MockResponse.listFixtures(count: 10),
            page: 1,
            pageSize: 10,
            totalCount: 25
        )
        #expect(withMore.hasMore == true)

        // Test case where this is the last page
        let lastPage = MockPaginatedResponse<MockResponse>.fixture(
            items: MockResponse.listFixtures(count: 5),
            page: 3,
            pageSize: 10,
            totalCount: 25
        )
        #expect(lastPage.hasMore == false)
    }
}

// MARK: - MockErrorResponse Fixture Validation Tests

@Suite("MockErrorResponse Fixture Validation Tests")
struct MockErrorResponseFixtureValidationTests {

    @Test("Generic error fixture should have valid error info")
    func testGenericErrorFixture() {
        // Act
        let error = MockErrorResponse.genericErrorFixture()

        // Assert
        #expect(error.error.isEmpty == false)
        #expect(error.code > 0)
        #expect(error.message != nil)
    }

    @Test("Validation error fixture should be correct")
    func testValidationErrorFixture() {
        // Act
        let error = MockErrorResponse.validationErrorFixture()

        // Assert
        #expect(error.error == "validation_error")
        #expect(error.code == 1001)
    }

    @Test("Authentication error fixture should have 401 code")
    func testAuthenticationErrorFixture() {
        // Act
        let error = MockErrorResponse.authenticationErrorFixture()

        // Assert
        #expect(error.code == 401)
        #expect(error.error == "unauthorized")
    }

    @Test("Not found error fixture should have 404 code")
    func testNotFoundErrorFixture() {
        // Act
        let error = MockErrorResponse.notFoundErrorFixture()

        // Assert
        #expect(error.code == 404)
        #expect(error.error == "not_found")
    }

    @Test("Server error fixture should have 500 code")
    func testServerErrorFixture() {
        // Act
        let error = MockErrorResponse.serverErrorFixture()

        // Assert
        #expect(error.code == 500)
        #expect(error.error == "internal_server_error")
    }

    @Test("MockErrorResponse should be Codable")
    func testCodable() throws {
        // Arrange
        let original = MockErrorResponse.genericErrorFixture()

        // Act
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(MockErrorResponse.self, from: data)

        // Assert
        #expect(decoded == original)
    }
}
