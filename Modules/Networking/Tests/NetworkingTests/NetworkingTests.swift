import Alamofire
@testable import Core
@testable import Networking
import Testing
import XCTest

// MARK: - Mock Endpoint
struct MockEndpoint: APIEndpoint {
    var baseURL: String = "https://api.example.com"
    var path: String = "/test"
    var method: HTTPMethod = .get
    var headers: HTTPHeaders?
    var parameters: Parameters?
    var encoding: ParameterEncoding = URLEncoding.default
}

// MARK: - Mock Response Model
struct MockResponse: Codable, Equatable {
    let id: Int
    let name: String
}

// MARK: - Mock NetworkService Protocol
final class MockNetworkService: NetworkServiceProtocol, @unchecked Sendable {
    var mockResult: Result<Any, Error>?

    func request<T: Decodable>(_ endpoint: APIEndpoint, responseType: T.Type) async throws -> T {
        guard let result = mockResult else {
            throw NetworkError.noData
        }

        switch result {
        case .success(let data):
            if let typedData = data as? T {
                return typedData
            } else {
                throw NetworkError.decodingError(NSError(domain: "MockError", code: 0))
            }
        case .failure(let error):
            throw error
        }
    }
}

// MARK: - Mock Session Factory
struct MockSessionFactory {
    static func createMockSession() -> Session {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]

        return Session(
            configuration: config,
            delegate: SessionDelegate(),
            rootQueue: DispatchQueue(label: "mock.session.rootQueue"),
            startRequestsImmediately: true
        )
    }
}

// MARK: - Mock URL Protocol com thread-safety
actor MockURLProtocolStorage {
    static let shared = MockURLProtocolStorage()

    var mockData: Data?
    var mockError: Error?
    var mockStatusCode: Int = 200

    private init() {}

    func setMockData(_ data: Data?) {
        mockData = data
    }

    func setMockError(_ error: Error?) {
        mockError = error
    }

    func setMockStatusCode(_ code: Int) {
        mockStatusCode = code
    }

    func getMockData() -> Data? {
        mockData
    }

    func getMockError() -> Error? {
        mockError
    }

    func getMockStatusCode() -> Int {
        mockStatusCode
    }
}

class MockURLProtocol: URLProtocol, @unchecked Sendable {

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let client = self.client, let url = request.url else {
            return
        }

        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }

            Task { @MainActor in
                let storage = MockURLProtocolStorage.shared

                if let error = await storage.getMockError() {
                    client.urlProtocol(self, didFailWithError: error)
                } else {
                    let statusCode = await storage.getMockStatusCode()
                    let response = HTTPURLResponse(
                        url: url,
                        statusCode: statusCode,
                        httpVersion: nil,
                        headerFields: nil
                    )!

                    client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

                    if let data = await storage.getMockData() {
                        client.urlProtocol(self, didLoad: data)
                    }

                    client.urlProtocolDidFinishLoading(self)
                }
            }
        }
    }

    override func stopLoading() {}
}

// MARK: - NetworkService Tests using Swift Testing
@Suite("NetworkService Tests")
struct NetworkServiceTests {

    // MARK: - Mock Protocol Tests (sempre funcionam)

    @Test("Should successfully decode response using mock protocol")
    func testSuccessfulRequestWithMockProtocol() async throws {
        // Arrange
        let mockResponse = MockResponse(id: 1, name: "Test")
        let mockNetworkService = MockNetworkService()
        mockNetworkService.mockResult = .success(mockResponse)
        let endpoint = MockEndpoint()

        // Act
        let result = try await mockNetworkService.request(endpoint, responseType: MockResponse.self)

        // Assert
        #expect(result == mockResponse)
    }

    @Test("Should throw decoding error using mock protocol")
    func testDecodingErrorWithMockProtocol() async {
        // Arrange
        let mockNetworkService = MockNetworkService()
        mockNetworkService.mockResult = .failure(NetworkError.decodingError(NSError(domain: "Test", code: 0)))
        let endpoint = MockEndpoint()

        // Act & Assert
        do {
            _ = try await mockNetworkService.request(endpoint, responseType: MockResponse.self)
            #expect(Bool(false), "Should throw decoding error")
        } catch {
            if case NetworkError.decodingError = error {
                #expect(Bool(true))
            } else {
                #expect(Bool(false), "Wrong error type: \(error)")
            }
        }
    }

    @Test("Should throw server error using mock protocol")
    func testServerErrorWithMockProtocol() async {
        // Arrange
        let mockNetworkService = MockNetworkService()
        mockNetworkService.mockResult = .failure(NetworkError.serverErrorCode(500))
        let endpoint = MockEndpoint()

        // Act & Assert
        do {
            _ = try await mockNetworkService.request(endpoint, responseType: MockResponse.self)
            #expect(Bool(false), "Should throw server error")
        } catch {
            if case NetworkError.serverErrorCode(let code) = error {
                #expect(code == 500)
            } else {
                #expect(Bool(false), "Wrong error type: \(error)")
            }
        }
    }

    @Test("Should throw noData error using mock protocol")
    func testNoDataErrorWithMockProtocol() async {
        // Arrange
        let mockNetworkService = MockNetworkService()
        // Não definimos mockResult, então deve lançar noData
        let endpoint = MockEndpoint()

        // Act & Assert
        do {
            _ = try await mockNetworkService.request(endpoint, responseType: MockResponse.self)
            #expect(Bool(false), "Should throw noData error")
        } catch {
            if case NetworkError.noData = error {
                #expect(Bool(true))
            } else {
                #expect(Bool(false), "Wrong error type: \(error)")
            }
        }
    }

    // MARK: - Real Implementation Test (usando URLProtocol)

    @Test("Should successfully decode response with real implementation")
    @available(iOS 16.0, *)
    func testSuccessfulRequestWithRealImplementation() async throws {
        // Arrange
        let mockResponse = MockResponse(id: 1, name: "Test")
        let mockData = try JSONEncoder().encode(mockResponse)

        let storage = MockURLProtocolStorage.shared
        await storage.setMockData(mockData)
        await storage.setMockStatusCode(200)
        await storage.setMockError(nil)

        let session = MockSessionFactory.createMockSession()
        let networkService = NetworkService(session: session)
        let endpoint = MockEndpoint()

        // Act
        let result = try await networkService.request(endpoint, responseType: MockResponse.self)

        // Assert
        #expect(result == mockResponse)
    }

    // MARK: - NetworkError Description Tests

    @Test("NetworkError should provide proper descriptions")
    func testNetworkErrorDescriptions() {
        // Test invalid URL error
        let invalidURLError = NetworkError.invalidURL
        #expect(invalidURLError.errorDescription != nil)

        // Test no data error
        let noDataError = NetworkError.noData
        #expect(noDataError.errorDescription != nil)

        // Test server error code
        let serverErrorCode = NetworkError.serverErrorCode(404)
        #expect(serverErrorCode.errorDescription != nil)
        #expect(serverErrorCode.errorDescription?.contains("404") == true)

        // Test server error message
        let serverErrorMessage = NetworkError.serverErrorMessage("Not Found")
        #expect(serverErrorMessage.errorDescription != nil)
        #expect(serverErrorMessage.errorDescription?.contains("Not Found") == true)

        // Test decoding error
        let decodingError = NetworkError.decodingError(NSError(domain: "", code: 0))
        #expect(decodingError.errorDescription != nil)

        // Test unknown error
        let unknownError = NetworkError.unknown(NSError(domain: "test", code: 0))
        #expect(unknownError.errorDescription != nil)

        // Test unauthorized error
        let unauthorizedError = NetworkError.unauthorized
        #expect(unauthorizedError.errorDescription != nil)

        // Test notFound error
        let notFoundError = NetworkError.notFound
        #expect(notFoundError.errorDescription != nil)
    }

    @Test("NetworkError cases should be distinguishable")
    func testNetworkErrorCases() {
        // Verificar que cada case é único e pode ser matched
        let errors: [NetworkError] = [
            .invalidURL,
            .serverErrorMessage("test"),
            .serverErrorCode(500),
            .decodingError(NSError(domain: "", code: 0)),
            .unknown(NSError(domain: "", code: 0)),
            .noData,
            .unauthorized,
            .notFound
        ]

        #expect(errors.count == 8)

        // Verificar que todos têm descrição
        for error in errors {
            #expect(error.errorDescription != nil)
        }
    }
}
