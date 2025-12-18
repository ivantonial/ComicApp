//
//  NetworkErrorTests.swift
//  Networking
//
//  Created by Ivan Tonial IP.TV on 17/12/25.
//
//  Testes do modelo NetworkError.
//  Cobre todos os casos de erro, descrições localizadas e conformidade com LocalizedError.
//

@testable import Networking
import Foundation
import Testing

// MARK: - NetworkError Tests

@Suite("NetworkError Tests")
struct NetworkErrorTests {

    // MARK: - Error Description Tests

    @Test("invalidURL should have proper description")
    func testInvalidURLDescription() {
        // Arrange
        let error = NetworkError.invalidURL

        // Act
        let description = error.errorDescription

        // Assert
        #expect(description != nil)
        #expect(description?.isEmpty == false)
    }

    @Test("serverErrorMessage should include message in description")
    func testServerErrorMessageDescription() {
        // Arrange
        let message = "Internal Server Error"
        let error = NetworkError.serverErrorMessage(message)

        // Act
        let description = error.errorDescription

        // Assert
        #expect(description != nil)
        #expect(description?.contains(message) == true)
    }

    @Test("serverErrorCode should include code in description")
    func testServerErrorCodeDescription() {
        // Arrange
        let code = 500
        let error = NetworkError.serverErrorCode(code)

        // Act
        let description = error.errorDescription

        // Assert
        #expect(description != nil)
        #expect(description?.contains("\(code)") == true)
    }

    @Test("decodingError should have proper description")
    func testDecodingErrorDescription() {
        // Arrange
        let underlyingError = NSError(
            domain: "DecodingError",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Failed to decode"]
        )
        let error = NetworkError.decodingError(underlyingError)

        // Act
        let description = error.errorDescription

        // Assert
        #expect(description != nil)
        #expect(description?.isEmpty == false)
    }

    @Test("unknown error should have proper description")
    func testUnknownErrorDescription() {
        // Arrange
        let underlyingError = NSError(
            domain: "UnknownDomain",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"]
        )
        let error = NetworkError.unknown(underlyingError)

        // Act
        let description = error.errorDescription

        // Assert
        #expect(description != nil)
        #expect(description?.isEmpty == false)
    }

    @Test("noData should have proper description")
    func testNoDataDescription() {
        // Arrange
        let error = NetworkError.noData

        // Act
        let description = error.errorDescription

        // Assert
        #expect(description != nil)
        #expect(description?.isEmpty == false)
    }

    @Test("unauthorized should have proper description")
    func testUnauthorizedDescription() {
        // Arrange
        let error = NetworkError.unauthorized

        // Act
        let description = error.errorDescription

        // Assert
        #expect(description != nil)
        #expect(description?.isEmpty == false)
    }

    @Test("notFound should have proper description")
    func testNotFoundDescription() {
        // Arrange
        let error = NetworkError.notFound

        // Act
        let description = error.errorDescription

        // Assert
        #expect(description != nil)
        #expect(description?.isEmpty == false)
    }

    // MARK: - All Cases Tests

    @Test("All NetworkError cases should have descriptions")
    func testAllCasesHaveDescriptions() {
        // Arrange
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

        // Assert
        for error in errors {
            #expect(error.errorDescription != nil, "Error \(error) should have description")
            #expect(error.errorDescription?.isEmpty == false, "Error \(error) description should not be empty")
        }
    }

    @Test("NetworkError cases count should be 8")
    func testNetworkErrorCasesCount() {
        // Arrange
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

        // Assert
        #expect(errors.count == 8)
    }

    // MARK: - LocalizedError Conformance Tests

    @Test("NetworkError should conform to LocalizedError")
    func testLocalizedErrorConformance() {
        // Arrange
        let error: LocalizedError = NetworkError.invalidURL

        // Assert
        #expect(error.errorDescription != nil)
    }

    @Test("NetworkError can be used with Error protocol")
    func testErrorProtocolConformance() {
        // Arrange
        let error: Error = NetworkError.serverErrorCode(404)

        // Act
        let localizedDescription = error.localizedDescription

        // Assert
        #expect(localizedDescription.isEmpty == false)
    }

    // MARK: - Specific Code Tests

    @Test("serverErrorCode should correctly store and return code")
    func testServerErrorCodeValue() {
        // Arrange
        let codes = [400, 401, 403, 404, 500, 502, 503]

        for code in codes {
            // Act
            let error = NetworkError.serverErrorCode(code)

            // Assert
            if case .serverErrorCode(let storedCode) = error {
                #expect(storedCode == code)
            } else {
                Issue.record("Expected serverErrorCode case")
            }
        }
    }

    @Test("serverErrorMessage should correctly store and return message")
    func testServerErrorMessageValue() {
        // Arrange
        let messages = [
            "Bad Request",
            "Unauthorized",
            "Forbidden",
            "Not Found",
            "Internal Server Error"
        ]

        for message in messages {
            // Act
            let error = NetworkError.serverErrorMessage(message)

            // Assert
            if case .serverErrorMessage(let storedMessage) = error {
                #expect(storedMessage == message)
            } else {
                Issue.record("Expected serverErrorMessage case")
            }
        }
    }

    // MARK: - Associated Value Tests

    @Test("decodingError should preserve underlying error")
    func testDecodingErrorPreservesUnderlyingError() {
        // Arrange
        let underlyingError = NSError(
            domain: "TestDomain",
            code: 42,
            userInfo: [NSLocalizedDescriptionKey: "Test Error"]
        )

        // Act
        let error = NetworkError.decodingError(underlyingError)

        // Assert
        if case .decodingError(let storedError) = error {
            let nsError = storedError as NSError
            #expect(nsError.domain == "TestDomain")
            #expect(nsError.code == 42)
        } else {
            Issue.record("Expected decodingError case")
        }
    }

    @Test("unknown error should preserve underlying error")
    func testUnknownErrorPreservesUnderlyingError() {
        // Arrange
        let underlyingError = NSError(
            domain: "UnknownDomain",
            code: 99,
            userInfo: [NSLocalizedDescriptionKey: "Unknown Test Error"]
        )

        // Act
        let error = NetworkError.unknown(underlyingError)

        // Assert
        if case .unknown(let storedError) = error {
            let nsError = storedError as NSError
            #expect(nsError.domain == "UnknownDomain")
            #expect(nsError.code == 99)
        } else {
            Issue.record("Expected unknown case")
        }
    }

    // MARK: - HTTP Status Code Mapping Tests

    @Test("Common HTTP error codes should map correctly")
    func testCommonHTTPErrorCodes() {
        // Test 400 Bad Request
        let badRequest = NetworkError.serverErrorCode(400)
        #expect(badRequest.errorDescription?.contains("400") == true)

        // Test 401 Unauthorized
        let unauthorized = NetworkError.serverErrorCode(401)
        #expect(unauthorized.errorDescription?.contains("401") == true)

        // Test 403 Forbidden
        let forbidden = NetworkError.serverErrorCode(403)
        #expect(forbidden.errorDescription?.contains("403") == true)

        // Test 404 Not Found
        let notFound = NetworkError.serverErrorCode(404)
        #expect(notFound.errorDescription?.contains("404") == true)

        // Test 500 Internal Server Error
        let serverError = NetworkError.serverErrorCode(500)
        #expect(serverError.errorDescription?.contains("500") == true)
    }
}

// MARK: - NetworkError Equatable Tests

@Suite("NetworkError Equatable Tests")
struct NetworkErrorEquatableTests {

    @Test("Same error cases should be equal")
    func testSameErrorCasesAreEqual() {
        // Assert
        #expect(NetworkError.invalidURL == NetworkError.invalidURL)
        #expect(NetworkError.noData == NetworkError.noData)
        #expect(NetworkError.unauthorized == NetworkError.unauthorized)
        #expect(NetworkError.notFound == NetworkError.notFound)
    }

    @Test("Different error cases should not be equal")
    func testDifferentErrorCasesAreNotEqual() {
        // Assert
        #expect(NetworkError.invalidURL != NetworkError.noData)
        #expect(NetworkError.unauthorized != NetworkError.notFound)
        #expect(NetworkError.serverErrorCode(400) != NetworkError.serverErrorCode(500))
    }

    @Test("serverErrorCode with same code should be equal")
    func testServerErrorCodeEquality() {
        // Assert
        #expect(NetworkError.serverErrorCode(404) == NetworkError.serverErrorCode(404))
        #expect(NetworkError.serverErrorCode(500) == NetworkError.serverErrorCode(500))
    }

    @Test("serverErrorMessage with same message should be equal")
    func testServerErrorMessageEquality() {
        // Assert
        #expect(NetworkError.serverErrorMessage("Error") == NetworkError.serverErrorMessage("Error"))
        #expect(NetworkError.serverErrorMessage("Test") != NetworkError.serverErrorMessage("Different"))
    }
}
