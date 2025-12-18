//
//  MockEndpointFixture.swift
//  Networking
//
//  Created by Ivan Tonial IP.TV on 17/12/25.
//
//  Fixtures de APIEndpoint para testes do módulo Networking.
//  Fornece endpoints mockados configuráveis para diferentes cenários de teste.
//

import Alamofire
@testable import Networking
import Foundation

// MARK: - MockEndpoint

/// Endpoint mockado para testes que implementa APIEndpoint
public struct MockEndpoint: APIEndpoint, Sendable {

    // MARK: - Properties

    public var baseURL: String
    public var path: String
    public var method: HTTPMethod
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    public var encoding: ParameterEncoding

    // MARK: - Initialization

    public init(
        baseURL: String = "https://api.example.com",
        path: String = "/test",
        method: HTTPMethod = .get,
        headers: HTTPHeaders? = nil,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.parameters = parameters
        self.encoding = encoding
    }
}

// MARK: - MockEndpoint Fixtures

extension MockEndpoint {

    /// Fixture padrão para testes básicos
    public static func defaultFixture() -> MockEndpoint {
        MockEndpoint(
            baseURL: "https://api.example.com",
            path: "/test",
            method: .get,
            headers: nil,
            parameters: nil,
            encoding: URLEncoding.default
        )
    }

    /// Fixture com URL inválida para testar tratamento de erros
    public static func invalidURLFixture() -> MockEndpoint {
        MockEndpoint(
            baseURL: "",
            path: "",
            method: .get,
            headers: nil,
            parameters: nil,
            encoding: URLEncoding.default
        )
    }

    /// Fixture para requisição GET com parâmetros
    public static func getWithParametersFixture(parameters: Parameters) -> MockEndpoint {
        MockEndpoint(
            baseURL: "https://api.example.com",
            path: "/search",
            method: .get,
            headers: nil,
            parameters: parameters,
            encoding: URLEncoding.default
        )
    }

    /// Fixture para requisição POST com body JSON
    public static func postFixture(parameters: Parameters? = nil) -> MockEndpoint {
        MockEndpoint(
            baseURL: "https://api.example.com",
            path: "/create",
            method: .post,
            headers: HTTPHeaders([
                "Content-Type": "application/json"
            ]),
            parameters: parameters,
            encoding: JSONEncoding.default
        )
    }

    /// Fixture para requisição PUT
    public static func putFixture(id: Int, parameters: Parameters? = nil) -> MockEndpoint {
        MockEndpoint(
            baseURL: "https://api.example.com",
            path: "/update/\(id)",
            method: .put,
            headers: HTTPHeaders([
                "Content-Type": "application/json"
            ]),
            parameters: parameters,
            encoding: JSONEncoding.default
        )
    }

    /// Fixture para requisição DELETE
    public static func deleteFixture(id: Int) -> MockEndpoint {
        MockEndpoint(
            baseURL: "https://api.example.com",
            path: "/delete/\(id)",
            method: .delete,
            headers: nil,
            parameters: nil,
            encoding: URLEncoding.default
        )
    }

    /// Fixture para requisição com headers de autenticação
    public static func authenticatedFixture(token: String = "test-token") -> MockEndpoint {
        MockEndpoint(
            baseURL: "https://api.example.com",
            path: "/protected",
            method: .get,
            headers: HTTPHeaders([
                "Authorization": "Bearer \(token)"
            ]),
            parameters: nil,
            encoding: URLEncoding.default
        )
    }

    /// Fixture para requisição com headers customizados
    public static func customHeadersFixture(headers: [String: String]) -> MockEndpoint {
        MockEndpoint(
            baseURL: "https://api.example.com",
            path: "/custom",
            method: .get,
            headers: HTTPHeaders(headers.map { HTTPHeader(name: $0.key, value: $0.value) }),
            parameters: nil,
            encoding: URLEncoding.default
        )
    }

    /// Fixture para diferentes paths
    public static func pathFixture(path: String) -> MockEndpoint {
        MockEndpoint(
            baseURL: "https://api.example.com",
            path: path,
            method: .get,
            headers: nil,
            parameters: nil,
            encoding: URLEncoding.default
        )
    }

    /// Fixture para diferentes base URLs
    public static func baseURLFixture(baseURL: String, path: String = "/test") -> MockEndpoint {
        MockEndpoint(
            baseURL: baseURL,
            path: path,
            method: .get,
            headers: nil,
            parameters: nil,
            encoding: URLEncoding.default
        )
    }
}
