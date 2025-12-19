//
//  NetworkingTests.swift
//  Networking
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//
//  NOTA: Este arquivo serve como ponto de entrada para os testes do módulo Networking.
//  Os testes estão organizados em arquivos separados seguindo a arquitetura modular:
//
//  Estrutura dos testes:
//  ├── Doubles/
//  │   ├── MockNetworkService.swift           - Mock do NetworkServiceProtocol para testes isolados
//  │   └── MockURLProtocol.swift              - Mock do URLProtocol para testes de integração
//  ├── Fixtures/
//  │   ├── MockEndpointFixture.swift          - Fixture de APIEndpoint para testes
//  │   └── MockResponseFixture.swift          - Fixture de resposta para testes
//  ├── Models/
//  │   └── NetworkErrorTests.swift            - Testes do NetworkError
//  └── Services/
//      └── NetworkServiceTests.swift          - Testes do NetworkService
//
//  Uso dos Mocks:
//  - MockNetworkService: Usado para testes que precisam simular o comportamento
//    do NetworkServiceProtocol sem fazer requisições reais
//  - MockURLProtocol: Usado para testes de integração que precisam interceptar
//    requisições HTTP e retornar respostas controladas
//

import Alamofire
@testable import Networking
import Foundation
import Testing
import XCTest

// MARK: - Networking Module Export Tests

@Suite("Networking Module Export Tests")
struct NetworkingModuleExportTests {

    @Test("Networking module should export NetworkError")
    func testNetworkErrorExport() {
        // Valida que NetworkError está acessível
        let error = NetworkError.invalidURL
        #expect(error.errorDescription != nil)
    }

    @Test("Networking module should export NetworkServiceProtocol")
    func testNetworkServiceProtocolExport() {
        // Valida que NetworkServiceProtocol está acessível
        // O protocolo é validado pela existência do mock que o implementa
        let mockService = MockNetworkService()

        // Verifica que o mock pode ser usado como NetworkServiceProtocol
        let _: any NetworkServiceProtocol = mockService

        // Verifica propriedades do mock
        #expect(mockService.requestCallCount == 0)
    }

    @Test("Networking module should export NetworkService")
    func testNetworkServiceExport() {
        guard #available(iOS 16.0, *) else {
            #expect(true)
            return
        }

        // Valida que NetworkService está acessível
        let service = NetworkService()

        // Verifica que o service pode ser usado como NetworkServiceProtocol
        let _: any NetworkServiceProtocol = service

        // Teste passou - NetworkService está disponível e conforma com o protocolo
        #expect(true)
    }

    @Test("Networking module should export APIEndpoint protocol")
    func testAPIEndpointProtocolExport() {
        // Valida que APIEndpoint está acessível
        let endpoint = MockEndpoint.defaultFixture()
        #expect(endpoint.baseURL == "https://api.example.com")
        #expect(endpoint.path == "/test")
    }
}

// MARK: - NetworkError Equatable Extension for Tests

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.serverErrorMessage(let lhsMsg), .serverErrorMessage(let rhsMsg)):
            return lhsMsg == rhsMsg
        case (.serverErrorCode(let lhsCode), .serverErrorCode(let rhsCode)):
            return lhsCode == rhsCode
        case (.noData, .noData):
            return true
        case (.unauthorized, .unauthorized):
            return true
        case (.notFound, .notFound):
            return true
        case (.decodingError, .decodingError):
            return true
        case (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}
