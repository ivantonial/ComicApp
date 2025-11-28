//
//  CacheMetadataTests.swift
//  Cache
//
//  Created by Ivan Tonial IP.TV on 27/11/25.
//

@testable import Cache
import Foundation
import Testing

// MARK: - CacheMetadata Tests

@Suite("CacheMetadata Tests")
struct CacheMetadataTests {

    // MARK: - Initialization Tests

    @Test("CacheMetadata should store expiration date correctly")
    func testExpirationDateStorage() {
        // Arrange
        let date = Date()

        // Act
        let metadata = CacheMetadata(expirationDate: date)

        // Assert
        #expect(metadata.expirationDate == date)
    }

    @Test("CacheMetadata should store future expiration date")
    func testFutureExpirationDate() {
        // Arrange
        let futureDate = Date().addingTimeInterval(3600) // 1 hora no futuro

        // Act
        let metadata = CacheMetadata(expirationDate: futureDate)

        // Assert
        #expect(metadata.expirationDate > Date())
    }

    @Test("CacheMetadata should store past expiration date")
    func testPastExpirationDate() {
        // Arrange
        let pastDate = Date().addingTimeInterval(-3600) // 1 hora no passado

        // Act
        let metadata = CacheMetadata(expirationDate: pastDate)

        // Assert
        #expect(metadata.expirationDate < Date())
    }

    // MARK: - Codable Tests

    @Test("CacheMetadata should be Codable")
    func testCodable() throws {
        // Arrange
        let date = Date()
        let metadata = CacheMetadata(expirationDate: date)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        // Act
        let data = try encoder.encode(metadata)
        let decoded = try decoder.decode(CacheMetadata.self, from: data)

        // Assert
        #expect(decoded.expirationDate.timeIntervalSince1970 == metadata.expirationDate.timeIntervalSince1970)
    }

    @Test("CacheMetadata JSON should contain expirationDate key")
    func testJSONContainsExpectedKey() throws {
        // Arrange
        let metadata = CacheMetadata(expirationDate: Date())
        let encoder = JSONEncoder()

        // Act
        let data = try encoder.encode(metadata)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        // Assert
        #expect(json?["expirationDate"] != nil)
    }

    @Test("CacheMetadata should decode from valid JSON")
    func testDecodeFromJSON() throws {
        // Arrange
        let timestamp: TimeInterval = 1700000000
        let json = """
        {"expirationDate": \(timestamp)}
        """
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        // IMPORTANTE: Configurar para interpretar timestamps como segundos desde Unix epoch (1970)
        // Por padrão, JSONDecoder usa .deferredToDate que interpreta como segundos desde 2001
        decoder.dateDecodingStrategy = .secondsSince1970

        // Act
        let metadata = try decoder.decode(CacheMetadata.self, from: data)

        // Assert
        #expect(metadata.expirationDate.timeIntervalSince1970 == timestamp)
    }

    // MARK: - Sendable Tests

    @Test("CacheMetadata should be Sendable")
    func testSendable() async {
        // Arrange
        let metadata = CacheMetadata(expirationDate: Date())

        // Act - Pass across async boundary
        let result = await Task.detached {
            return metadata.expirationDate
        }.value

        // Assert
        #expect(result == metadata.expirationDate)
    }

    @Test("CacheMetadata should work in concurrent context")
    func testConcurrentAccess() async {
        // Arrange
        let metadata = CacheMetadata(expirationDate: Date())

        // Act
        await withTaskGroup(of: Date.self) { group in
            for _ in 0..<10 {
                group.addTask {
                    return metadata.expirationDate
                }
            }

            var dates: [Date] = []
            for await date in group {
                dates.append(date)
            }

            // Assert
            #expect(dates.count == 10)
            #expect(dates.allSatisfy { $0 == metadata.expirationDate })
        }
    }

    // MARK: - Edge Cases

    @Test("CacheMetadata should handle distant future date")
    func testDistantFutureDate() throws {
        // Arrange
        let distantFuture = Date.distantFuture

        // Act
        let metadata = CacheMetadata(expirationDate: distantFuture)

        // Encode and decode
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let data = try encoder.encode(metadata)
        let decoded = try decoder.decode(CacheMetadata.self, from: data)

        // Assert
        #expect(decoded.expirationDate == distantFuture)
    }

    @Test("CacheMetadata should handle distant past date")
    func testDistantPastDate() throws {
        // Arrange
        let distantPast = Date.distantPast

        // Act
        let metadata = CacheMetadata(expirationDate: distantPast)

        // Encode and decode
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let data = try encoder.encode(metadata)
        let decoded = try decoder.decode(CacheMetadata.self, from: data)

        // Assert
        #expect(decoded.expirationDate == distantPast)
    }
}

// MARK: - CacheMetadata Expiration Logic Tests

@Suite("CacheMetadata Expiration Logic Tests")
struct CacheMetadataExpirationLogicTests {

    @Test("Metadata with future date should not be expired")
    func testNotExpired() {
        // Arrange
        let futureDate = Date().addingTimeInterval(3600)
        let metadata = CacheMetadata(expirationDate: futureDate)

        // Assert
        #expect(metadata.expirationDate > Date())
    }

    @Test("Metadata with past date should be expired")
    func testExpired() {
        // Arrange
        let pastDate = Date().addingTimeInterval(-3600)
        let metadata = CacheMetadata(expirationDate: pastDate)

        // Assert
        #expect(metadata.expirationDate < Date())
    }

    @Test("Metadata expiration check should be accurate within seconds")
    func testExpirationAccuracy() async throws {
        // Arrange
        let expirationDate = Date().addingTimeInterval(1) // Expira em 1 segundo
        let metadata = CacheMetadata(expirationDate: expirationDate)

        // Assert - Ainda não expirou
        #expect(metadata.expirationDate > Date())

        // Aguarda a expiração
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 segundos

        // Assert - Agora expirou
        #expect(metadata.expirationDate < Date())
    }
}
