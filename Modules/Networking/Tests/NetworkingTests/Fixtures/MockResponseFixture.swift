//
//  MockResponseFixture.swift
//  Networking
//
//  Created by Ivan Tonial IP.TV on 17/12/25.
//
//  Fixtures de modelos de resposta para testes do módulo Networking.
//  Fornece structs mockadas para testar serialização/deserialização JSON.
//

@testable import Networking
import Foundation

// MARK: - MockResponse

/// Modelo de resposta mockado simples para testes básicos
public struct MockResponse: Codable, Equatable, Sendable {
    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

// MARK: - MockResponse Fixtures

extension MockResponse {

    /// Fixture padrão para testes básicos
    public static func defaultFixture() -> MockResponse {
        MockResponse(id: 1, name: "Test Response")
    }

    /// Fixture com ID customizado
    public static func fixture(id: Int) -> MockResponse {
        MockResponse(id: id, name: "Response \(id)")
    }

    /// Fixture com valores customizados
    public static func fixture(id: Int, name: String) -> MockResponse {
        MockResponse(id: id, name: name)
    }

    /// Array de fixtures para testes de lista
    public static func listFixtures(count: Int = 5) -> [MockResponse] {
        (1...count).map { MockResponse(id: $0, name: "Item \($0)") }
    }
}

// MARK: - MockDetailResponse

/// Modelo de resposta mockado com mais campos para testes complexos
public struct MockDetailResponse: Codable, Equatable, Sendable {
    public let id: Int
    public let name: String
    public let description: String?
    public let createdAt: Date?
    public let tags: [String]
    public let metadata: [String: String]?

    public init(
        id: Int,
        name: String,
        description: String? = nil,
        createdAt: Date? = nil,
        tags: [String] = [],
        metadata: [String: String]? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.createdAt = createdAt
        self.tags = tags
        self.metadata = metadata
    }
}

// MARK: - MockDetailResponse Fixtures

extension MockDetailResponse {

    /// Fixture padrão para testes de detalhes
    public static func defaultFixture() -> MockDetailResponse {
        MockDetailResponse(
            id: 1,
            name: "Detailed Response",
            description: "This is a detailed test response",
            createdAt: Date(),
            tags: ["test", "fixture"],
            metadata: ["key": "value"]
        )
    }

    /// Fixture mínima sem campos opcionais
    public static func minimalFixture() -> MockDetailResponse {
        MockDetailResponse(
            id: 1,
            name: "Minimal Response",
            description: nil,
            createdAt: nil,
            tags: [],
            metadata: nil
        )
    }

    /// Fixture com valores customizados
    public static func fixture(
        id: Int,
        name: String,
        description: String? = nil,
        tags: [String] = []
    ) -> MockDetailResponse {
        MockDetailResponse(
            id: id,
            name: name,
            description: description,
            createdAt: Date(),
            tags: tags,
            metadata: nil
        )
    }
}

// MARK: - MockPaginatedResponse

/// Modelo de resposta paginada mockada para testes de paginação
public struct MockPaginatedResponse<T: Codable & Sendable>: Codable, Sendable {
    public let items: [T]
    public let totalCount: Int
    public let page: Int
    public let pageSize: Int
    public let hasMore: Bool

    public init(
        items: [T],
        totalCount: Int,
        page: Int,
        pageSize: Int,
        hasMore: Bool
    ) {
        self.items = items
        self.totalCount = totalCount
        self.page = page
        self.pageSize = pageSize
        self.hasMore = hasMore
    }
}

// MARK: - MockPaginatedResponse Fixtures

extension MockPaginatedResponse where T == MockResponse {

    /// Fixture de primeira página
    public static func firstPageFixture() -> MockPaginatedResponse<MockResponse> {
        MockPaginatedResponse(
            items: MockResponse.listFixtures(count: 10),
            totalCount: 25,
            page: 1,
            pageSize: 10,
            hasMore: true
        )
    }

    /// Fixture de última página
    public static func lastPageFixture() -> MockPaginatedResponse<MockResponse> {
        MockPaginatedResponse(
            items: MockResponse.listFixtures(count: 5),
            totalCount: 25,
            page: 3,
            pageSize: 10,
            hasMore: false
        )
    }

    /// Fixture de página vazia
    public static func emptyPageFixture() -> MockPaginatedResponse<MockResponse> {
        MockPaginatedResponse(
            items: [],
            totalCount: 0,
            page: 1,
            pageSize: 10,
            hasMore: false
        )
    }

    /// Fixture customizada
    public static func fixture(
        items: [MockResponse],
        page: Int,
        pageSize: Int,
        totalCount: Int
    ) -> MockPaginatedResponse<MockResponse> {
        MockPaginatedResponse(
            items: items,
            totalCount: totalCount,
            page: page,
            pageSize: pageSize,
            hasMore: (page * pageSize) < totalCount
        )
    }
}

// MARK: - MockErrorResponse

/// Modelo de resposta de erro mockada
public struct MockErrorResponse: Codable, Equatable, Sendable {
    public let error: String
    public let code: Int
    public let message: String?

    public init(error: String, code: Int, message: String? = nil) {
        self.error = error
        self.code = code
        self.message = message
    }
}

// MARK: - MockErrorResponse Fixtures

extension MockErrorResponse {

    /// Fixture de erro genérico
    public static func genericErrorFixture() -> MockErrorResponse {
        MockErrorResponse(
            error: "generic_error",
            code: 1000,
            message: "An error occurred"
        )
    }

    /// Fixture de erro de validação
    public static func validationErrorFixture() -> MockErrorResponse {
        MockErrorResponse(
            error: "validation_error",
            code: 1001,
            message: "Invalid input data"
        )
    }

    /// Fixture de erro de autenticação
    public static func authenticationErrorFixture() -> MockErrorResponse {
        MockErrorResponse(
            error: "unauthorized",
            code: 401,
            message: "Authentication required"
        )
    }

    /// Fixture de erro de não encontrado
    public static func notFoundErrorFixture() -> MockErrorResponse {
        MockErrorResponse(
            error: "not_found",
            code: 404,
            message: "Resource not found"
        )
    }

    /// Fixture de erro de servidor
    public static func serverErrorFixture() -> MockErrorResponse {
        MockErrorResponse(
            error: "internal_server_error",
            code: 500,
            message: "Internal server error"
        )
    }
}

// MARK: - JSON Data Helpers

extension MockResponse {

    /// Converte a fixture para Data JSON
    public func toJSONData() throws -> Data {
        try JSONEncoder().encode(self)
    }

    /// Cria Data JSON a partir da fixture padrão
    public static func defaultJSONData() throws -> Data {
        try defaultFixture().toJSONData()
    }
}

extension MockDetailResponse {

    /// Converte a fixture para Data JSON
    public func toJSONData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }
}
