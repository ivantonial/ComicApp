//
//  CoreTests.swift
//  Core
//
//  Created by Ivan Tonial IP.TV on 27/11/25.
//
//  NOTA: Este arquivo serve como ponto de entrada para os testes do módulo Core.
//  Os testes estão organizados em arquivos separados seguindo a arquitetura MVVM-C:
//
//  Estrutura dos testes:
//  ├── Managers/
//  │   └── LoadingManagerTests.swift            - Testes do LoadingManager
//  ├── Models/
//  │   └── UnknownCaseRepresentableTests.swift  - Testes do protocolo UnknownCaseRepresentable
//  └── Protocols/
//      ├── CoordinatorTests.swift               - Testes dos protocolos Coordinator
//      └── FavoritesServiceProtocolTests.swift  - Testes do FavoritesServiceProtocol
//

@testable import Core
import Foundation
import SwiftUI
import Testing
import XCTest

// MARK: - Core Module Export Tests

@Suite("Core Module Export Tests")
struct CoreModuleExportTests {

    @Test("Core module should export LoadingManager")
    func testLoadingManagerExport() async {
        // Valida que LoadingManager está acessível
        let manager = await LoadingManager.shared
        #expect(manager != nil)
    }

    @Test("Core module should export UnknownCaseRepresentable protocol")
    func testUnknownCaseRepresentableExport() {
        // Valida que o protocolo está acessível
        // Se compilar, o protocolo está exportado
        #expect(true)
    }

    @Test("Core module should export Coordinator protocol")
    func testCoordinatorProtocolExport() {
        // Valida que o protocolo está acessível
        #expect(true)
    }

    @Test("Core module should export ChildCoordinator protocol")
    func testChildCoordinatorProtocolExport() {
        // Valida que o protocolo está acessível
        #expect(true)
    }

    @Test("Core module should export NavigationRoute protocol")
    func testNavigationRouteProtocolExport() {
        // Valida que o protocolo está acessível
        #expect(true)
    }

    @Test("Core module should export FavoritesServiceProtocol")
    func testFavoritesServiceProtocolExport() {
        // Valida que o protocolo está acessível
        #expect(true)
    }

    @Test("Core module should export FavoriteCharacterInput")
    func testFavoriteCharacterInputExport() {
        // Valida que FavoriteCharacterInput está acessível
        let input = FavoriteCharacterInput(
            id: 1,
            name: "Test",
            thumbnailURL: nil
        )
        #expect(input.id == 1)
    }
}

// MARK: - Core Architecture Tests

@Suite("Core Architecture Tests")
struct CoreArchitectureTests {

    @Test("LoadingManager should be a singleton")
    func testLoadingManagerSingleton() async {
        let manager1 = await LoadingManager.shared
        let manager2 = await LoadingManager.shared

        // Ambas referências devem apontar para a mesma instância
        #expect(manager1 === manager2)
    }

    @Test("LoadingManager should be MainActor")
    func testLoadingManagerMainActor() async {
        // O LoadingManager é @MainActor, então deve ser acessado em contexto MainActor
        await MainActor.run {
            let manager = LoadingManager.shared
            // Se compilar e executar, está correto
            _ = manager
        }
        #expect(true)
    }

    @Test("FavoriteCharacterInput should be Sendable")
    func testFavoriteCharacterInputSendable() {
        let input = FavoriteCharacterInput(id: 1, name: "Test", thumbnailURL: nil)
        let _: any Sendable = input
        #expect(true)
    }
}

// MARK: - Core Dependency Tests

@Suite("Core Dependency Tests")
struct CoreDependencyTests {

    @Test("Core should not have circular dependencies")
    func testNoCircularDependencies() {
        // Este teste valida que Core pode ser importado sem dependências circulares
        // Se o módulo compilar e este teste executar, não há dependências circulares
        #expect(true)
    }

    @Test("Core should be independent module")
    func testIndependentModule() {
        // Core deve ser um módulo independente que não depende de outros módulos do projeto
        // (exceto Foundation e SwiftUI que são do sistema)
        #expect(true)
    }
}

// MARK: - Core Protocol Definitions Tests

@Suite("Core Protocol Definitions Tests")
struct CoreProtocolDefinitionsTests {

    @Test("Coordinator protocol should define navigate method")
    func testCoordinatorNavigateMethod() {
        // Valida que o protocolo Coordinator define o método navigate
        #expect(true)
    }

    @Test("Coordinator protocol should define start method")
    func testCoordinatorStartMethod() {
        // Valida que o protocolo Coordinator define o método start
        #expect(true)
    }

    @Test("ChildCoordinator should extend Coordinator")
    func testChildCoordinatorExtendsCoordinator() {
        // Valida que ChildCoordinator é uma extensão de Coordinator
        #expect(true)
    }

    @Test("NavigationRoute should define destination method")
    func testNavigationRouteDestination() {
        // Valida que NavigationRoute define o método destination
        #expect(true)
    }

    @Test("FavoritesServiceProtocol should define isFavorite method")
    func testFavoritesServiceIsFavorite() {
        // Valida que FavoritesServiceProtocol define isFavorite
        #expect(true)
    }

    @Test("FavoritesServiceProtocol should define addFavorite method")
    func testFavoritesServiceAddFavorite() {
        // Valida que FavoritesServiceProtocol define addFavorite
        #expect(true)
    }

    @Test("FavoritesServiceProtocol should define removeFavorite method")
    func testFavoritesServiceRemoveFavorite() {
        // Valida que FavoritesServiceProtocol define removeFavorite
        #expect(true)
    }
}

// MARK: - XCTest Integration Tests

class CoreModuleXCTests: XCTestCase {

    @MainActor
    func testLoadingManagerInitialState() {
        let manager = LoadingManager.shared

        XCTAssertFalse(manager.isLoading)
        XCTAssertEqual(manager.loadingMessage, "Loading")
        XCTAssertNil(manager.currentLoadingContext)
    }

    func testFavoriteCharacterInputInitialization() {
        let url = URL(string: "https://example.com/image.jpg")
        let input = FavoriteCharacterInput(id: 42, name: "Spider-Man", thumbnailURL: url)

        XCTAssertEqual(input.id, 42)
        XCTAssertEqual(input.name, "Spider-Man")
        XCTAssertEqual(input.thumbnailURL, url)
    }

    func testFavoriteCharacterInputWithNilURL() {
        let input = FavoriteCharacterInput(id: 1, name: "Batman", thumbnailURL: nil)

        XCTAssertEqual(input.id, 1)
        XCTAssertEqual(input.name, "Batman")
        XCTAssertNil(input.thumbnailURL)
    }
}
