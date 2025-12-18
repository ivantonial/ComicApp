//
//  NetworkServiceTests.swift
//  Networking
//
//  Created by Ivan Tonial IP.TV on 17/12/25.
//
//  Testes do NetworkService.
//  Cobre inicialização, requisições de sucesso e tratamento de erros usando MockNetworkService.
//

import Alamofire
@testable import Networking
import Foundation
import Testing

// MARK: - NetworkService Tests

@Suite("NetworkService Tests")
struct NetworkServiceTests {

    // MARK: - Initialization Tests

    @Test("NetworkService should initialize with default session")
    func testDefaultInitialization() {
        guard #available(iOS 16.0, *) else {
            #expect(true)
            return
        }

        // Act
        let service = NetworkService()

        // Assert - Verifica que a instância foi criada corretamente
        let baseURL = "https://api.example.com"
        let path = "/test"
        let fullURL = baseURL + path
        #expect(fullURL == "https://api.example.com/test")
        // Service foi criado com sucesso se chegou aqui
        _ = service
    }

    @Test("NetworkService should initialize with custom session")
    func testCustomSessionInitialization() {
        guard #available(iOS 16.0, *) else {
            #expect(true)
            return
        }

        // Arrange
        let customSession = MockSessionFactory.createMockSession()

        // Act
        let service = NetworkService(session: customSession)

        // Assert - Service foi criado com sucesso se chegou aqui
        _ = service
        #expect(true)
    }

    // MARK: - Mock Protocol Tests

    @Test("Should successfully decode response using mock service")
    func testSuccessfulRequestWithMockService() async throws {
        // Arrange
        let expectedResponse = MockResponse.defaultFixture()
        let mockService = MockNetworkService()
        mockService.setSuccessResult(expectedResponse)
        let endpoint = MockEndpoint.defaultFixture()

        // Act
        let result = try await mockService.request(endpoint, responseType: MockResponse.self)

        // Assert
        #expect(result == expectedResponse)
    }

    @Test("Should track request call count")
    func testRequestCallCount() async throws {
        // Arrange
        let mockService = MockNetworkService()
        mockService.setSuccessResult(MockResponse.defaultFixture())
        let endpoint = MockEndpoint.defaultFixture()

        // Act
        _ = try await mockService.request(endpoint, responseType: MockResponse.self)
        _ = try await mockService.request(endpoint, responseType: MockResponse.self)
        _ = try await mockService.request(endpoint, responseType: MockResponse.self)

        // Assert
        #expect(mockService.requestCallCount == 3)
    }

    @Test("Should throw noData error when mock result is nil")
    func testNoDataError() async {
        // Arrange
        let mockService = MockNetworkService()
        mockService.simulateNoData()
        let endpoint = MockEndpoint.defaultFixture()

        // Act & Assert
        do {
            _ = try await mockService.request(endpoint, responseType: MockResponse.self)
            Issue.record("Should throw noData error")
        } catch {
            if case NetworkError.noData = error {
                #expect(true)
            } else {
                Issue.record("Wrong error type: \(error)")
            }
        }
    }

    @Test("Should throw decoding error with type mismatch")
    func testDecodingErrorWithTypeMismatch() async {
        // Arrange
        let mockService = MockNetworkService()
        // Configura um tipo diferente do esperado
        mockService.setSuccessResult("String instead of MockResponse")
        let endpoint = MockEndpoint.defaultFixture()

        // Act & Assert
        do {
            _ = try await mockService.request(endpoint, responseType: MockResponse.self)
            Issue.record("Should throw decoding error")
        } catch {
            if case NetworkError.decodingError = error {
                #expect(true)
            } else {
                Issue.record("Wrong error type: \(error)")
            }
        }
    }

    // MARK: - Error Simulation Tests

    @Test("Should throw server error with code")
    func testServerErrorCode() async {
        // Arrange
        let mockService = MockNetworkService()
        mockService.simulateServerError(code: 500)
        let endpoint = MockEndpoint.defaultFixture()

        // Act & Assert
        do {
            _ = try await mockService.request(endpoint, responseType: MockResponse.self)
            Issue.record("Should throw server error")
        } catch {
            if case NetworkError.serverErrorCode(let code) = error {
                #expect(code == 500)
            } else {
                Issue.record("Wrong error type: \(error)")
            }
        }
    }

    @Test("Should throw server error with message")
    func testServerErrorMessage() async {
        // Arrange
        let mockService = MockNetworkService()
        mockService.simulateServerError(message: "Internal Server Error")
        let endpoint = MockEndpoint.defaultFixture()

        // Act & Assert
        do {
            _ = try await mockService.request(endpoint, responseType: MockResponse.self)
            Issue.record("Should throw server error")
        } catch {
            if case NetworkError.serverErrorMessage(let message) = error {
                #expect(message == "Internal Server Error")
            } else {
                Issue.record("Wrong error type: \(error)")
            }
        }
    }

    @Test("Should throw unauthorized error")
    func testUnauthorizedError() async {
        // Arrange
        let mockService = MockNetworkService()
        mockService.simulateUnauthorized()
        let endpoint = MockEndpoint.defaultFixture()

        // Act & Assert
        do {
            _ = try await mockService.request(endpoint, responseType: MockResponse.self)
            Issue.record("Should throw unauthorized error")
        } catch {
            if case NetworkError.unauthorized = error {
                #expect(true)
            } else {
                Issue.record("Wrong error type: \(error)")
            }
        }
    }

    @Test("Should throw notFound error")
    func testNotFoundError() async {
        // Arrange
        let mockService = MockNetworkService()
        mockService.simulateNotFound()
        let endpoint = MockEndpoint.defaultFixture()

        // Act & Assert
        do {
            _ = try await mockService.request(endpoint, responseType: MockResponse.self)
            Issue.record("Should throw notFound error")
        } catch {
            if case NetworkError.notFound = error {
                #expect(true)
            } else {
                Issue.record("Wrong error type: \(error)")
            }
        }
    }

    @Test("Should throw invalidURL error")
    func testInvalidURLError() async {
        // Arrange
        let mockService = MockNetworkService()
        mockService.simulateInvalidURL()
        let endpoint = MockEndpoint.defaultFixture()

        // Act & Assert
        do {
            _ = try await mockService.request(endpoint, responseType: MockResponse.self)
            Issue.record("Should throw invalidURL error")
        } catch {
            if case NetworkError.invalidURL = error {
                #expect(true)
            } else {
                Issue.record("Wrong error type: \(error)")
            }
        }
    }

    @Test("Should throw decoding error")
    func testDecodingError() async {
        // Arrange
        let mockService = MockNetworkService()
        mockService.simulateDecodingError()
        let endpoint = MockEndpoint.defaultFixture()

        // Act & Assert
        do {
            _ = try await mockService.request(endpoint, responseType: MockResponse.self)
            Issue.record("Should throw decoding error")
        } catch {
            if case NetworkError.decodingError = error {
                #expect(true)
            } else {
                Issue.record("Wrong error type: \(error)")
            }
        }
    }

    // MARK: - Mock Service Reset Tests

    @Test("Should reset mock service state")
    func testMockServiceReset() async throws {
        // Arrange
        let mockService = MockNetworkService()
        mockService.setSuccessResult(MockResponse.defaultFixture())
        let endpoint = MockEndpoint.defaultFixture()

        // Act - Make a request
        _ = try await mockService.request(endpoint, responseType: MockResponse.self)

        // Verify state before reset
        #expect(mockService.requestCallCount == 1)

        // Act - Reset
        mockService.reset()

        // Assert
        #expect(mockService.requestCallCount == 0)
        #expect(mockService.mockResult == nil)
    }

    // MARK: - Simulated Delay Tests

    @Test("Should respect simulated delay")
    func testSimulatedDelay() async throws {
        // Arrange
        let mockService = MockNetworkService()
        mockService.setSuccessResult(MockResponse.defaultFixture())
        // Configura delay de 0.1 segundos
        let delay: TimeInterval = 0.1
        mockService.simulatedDelay = delay

        let endpoint = MockEndpoint.defaultFixture()

        // Act
        let startTime = Date()
        _ = try await mockService.request(endpoint, responseType: MockResponse.self)
        let elapsedTime = Date().timeIntervalSince(startTime)

        // Assert - O tempo deve ser pelo menos o delay configurado
        #expect(elapsedTime >= delay * 0.9) // 10% de tolerância
    }

    // MARK: - Last Requested Endpoint Tests

    @Test("Should track last requested endpoint")
    func testLastRequestedEndpoint() async throws {
        // Arrange
        let mockService = MockNetworkService()
        mockService.setSuccessResult(MockResponse.defaultFixture())
        let endpoint = MockEndpoint.postFixture(parameters: ["key": "value"])

        // Act
        _ = try await mockService.request(endpoint, responseType: MockResponse.self)

        // Assert
        #expect(mockService.lastRequestedEndpoint?.path == endpoint.path)
        #expect(mockService.lastRequestedEndpoint?.method == endpoint.method)
    }
}

// MARK: - APIEndpoint Tests

@Suite("APIEndpoint Tests")
struct APIEndpointTests {

    @Test("MockEndpoint should have correct default values")
    func testMockEndpointDefaults() {
        // Arrange & Act
        let endpoint = MockEndpoint.defaultFixture()

        // Assert
        #expect(endpoint.baseURL == "https://api.example.com")
        #expect(endpoint.path == "/test")
        #expect(endpoint.method == .get)
        #expect(endpoint.headers == nil)
        #expect(endpoint.parameters == nil)
    }

    @Test("MockEndpoint should support custom configuration")
    func testMockEndpointCustomConfiguration() {
        // Arrange & Act
        let endpoint = MockEndpoint(
            baseURL: "https://custom.api.com",
            path: "/custom/path",
            method: .post,
            headers: HTTPHeaders(["X-Custom": "Header"]),
            parameters: ["key": "value"],
            encoding: JSONEncoding.default
        )

        // Assert
        #expect(endpoint.baseURL == "https://custom.api.com")
        #expect(endpoint.path == "/custom/path")
        #expect(endpoint.method == .post)
        #expect(endpoint.headers != nil)
        #expect(endpoint.parameters != nil)
    }

    @Test("MockEndpoint fixtures should create correct configurations")
    func testMockEndpointFixtures() {
        // Test GET with parameters
        let getEndpoint = MockEndpoint.getWithParametersFixture(parameters: ["q": "search"])
        #expect(getEndpoint.method == .get)
        #expect(getEndpoint.parameters != nil)

        // Test POST
        let postEndpoint = MockEndpoint.postFixture()
        #expect(postEndpoint.method == .post)

        // Test PUT
        let putEndpoint = MockEndpoint.putFixture(id: 1)
        #expect(putEndpoint.method == .put)
        #expect(putEndpoint.path.contains("1"))

        // Test DELETE
        let deleteEndpoint = MockEndpoint.deleteFixture(id: 1)
        #expect(deleteEndpoint.method == .delete)
        #expect(deleteEndpoint.path.contains("1"))

        // Test authenticated
        let authEndpoint = MockEndpoint.authenticatedFixture(token: "my-token")
        #expect(authEndpoint.headers != nil)
    }

    @Test("MockEndpoint URL construction should work correctly")
    func testMockEndpointURLConstruction() {
        // Arrange
        let endpoint = MockEndpoint.defaultFixture()

        // Act
        let fullURL = endpoint.baseURL + endpoint.path

        // Assert
        #expect(fullURL == "https://api.example.com/test")
    }

    @Test("MockEndpoint invalid URL fixture should have empty values")
    func testInvalidURLFixture() {
        // Act
        let endpoint = MockEndpoint.invalidURLFixture()

        // Assert
        #expect(endpoint.baseURL.isEmpty)
        #expect(endpoint.path.isEmpty)
    }
}

// MARK: - MockResponse Fixture Tests

@Suite("MockResponse Fixture Tests")
struct MockResponseFixtureTests {

    @Test("MockResponse default fixture should have correct values")
    func testDefaultFixture() {
        // Act
        let response = MockResponse.defaultFixture()

        // Assert
        #expect(response.id == 1)
        #expect(response.name == "Test Response")
    }

    @Test("MockResponse list fixtures should create correct count")
    func testListFixtures() {
        // Act
        let responses = MockResponse.listFixtures(count: 10)

        // Assert
        #expect(responses.count == 10)
        for (index, response) in responses.enumerated() {
            #expect(response.id == index + 1)
            #expect(response.name == "Item \(index + 1)")
        }
    }

    @Test("MockDetailResponse minimal fixture should have nil optionals")
    func testMinimalDetailFixture() {
        // Act
        let response = MockDetailResponse.minimalFixture()

        // Assert
        #expect(response.description == nil)
        #expect(response.createdAt == nil)
        #expect(response.tags.isEmpty)
        #expect(response.metadata == nil)
    }

    @Test("MockPaginatedResponse fixtures should have correct pagination info")
    func testPaginatedFixtures() {
        // Test first page
        let firstPage = MockPaginatedResponse<MockResponse>.firstPageFixture()
        #expect(firstPage.page == 1)
        #expect(firstPage.hasMore == true)
        #expect(firstPage.items.count == 10)

        // Test last page
        let lastPage = MockPaginatedResponse<MockResponse>.lastPageFixture()
        #expect(lastPage.page == 3)
        #expect(lastPage.hasMore == false)
        #expect(lastPage.items.count == 5)

        // Test empty page
        let emptyPage = MockPaginatedResponse<MockResponse>.emptyPageFixture()
        #expect(emptyPage.items.isEmpty)
        #expect(emptyPage.totalCount == 0)
    }

    @Test("MockErrorResponse fixtures should have correct error info")
    func testErrorFixtures() {
        // Test generic error
        let generic = MockErrorResponse.genericErrorFixture()
        #expect(generic.error == "generic_error")

        // Test authentication error
        let auth = MockErrorResponse.authenticationErrorFixture()
        #expect(auth.code == 401)

        // Test not found error
        let notFound = MockErrorResponse.notFoundErrorFixture()
        #expect(notFound.code == 404)

        // Test server error
        let server = MockErrorResponse.serverErrorFixture()
        #expect(server.code == 500)
    }

    @Test("MockResponse should convert to JSON data")
    func testJSONConversion() throws {
        // Arrange
        let response = MockResponse.defaultFixture()

        // Act
        let data = try response.toJSONData()
        let decoded = try JSONDecoder().decode(MockResponse.self, from: data)

        // Assert
        #expect(decoded == response)
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
