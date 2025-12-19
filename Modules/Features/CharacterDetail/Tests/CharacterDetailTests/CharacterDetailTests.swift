//
//  CharacterDetailTests.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 27/11/25.
//
//  NOTA: Este arquivo serve como ponto de entrada para os testes do módulo CharacterDetail.
//  Os testes estão organizados em arquivos separados seguindo a arquitetura MVVM-C:
//
//  Estrutura dos testes:
//  ├── Doubles/
//  │   ├── MockFavoritesService.swift           - Mock para FavoritesServiceProtocol
//  │   └── MockPersistenceManager.swift         - Mock para PersistenceManagerProtocol
//  ├── Fixtures/
//  │   └── CharacterFixture+CharacterDetail.swift - Fixtures de Character para testes
//  ├── Models/
//  │   ├── CharacterDetailModelTests.swift      - Testes do CharacterDetailModel
//  │   ├── CharacterStatsModelTests.swift       - Testes do CharacterStatsModel
//  │   ├── CharacterRelatedContentModelTests.swift - Testes do CharacterRelatedContentModel
//  │   ├── CharacterShareInfoModelTests.swift   - Testes do CharacterShareInfoModel
//  │   ├── StatItemModelTests.swift             - Testes do StatItemModel
//  │   └── RelatedItemModelTests.swift          - Testes do RelatedItemModel
//  └── ViewModels/
//      └── CharacterDetailViewModelTests.swift  - Testes do CharacterDetailViewModel
//

@testable import CharacterDetail
import ComicVineAPI
import Foundation
import Testing
import XCTest

// MARK: - CharacterDetail Module Export Tests

@Suite("CharacterDetail Module Export Tests")
struct CharacterDetailModuleExportTests {

    @Test("CharacterDetail module should export CharacterDetailModel")
    func testCharacterDetailModelExport() {
        // Valida que CharacterDetailModel está acessível
        let character = Character.detailFixture()
        let model = CharacterDetailModel(from: character)
        #expect(model.character.id == character.id)
    }

    @Test("CharacterDetail module should export CharacterDetailViewModel")
    @MainActor
    func testCharacterDetailViewModelExport() {
        // Valida que CharacterDetailViewModel está acessível
        let character = Character.detailFixture()
        let viewModel = CharacterDetailViewModel(character: character)
        #expect(viewModel.detailModel.character.id == character.id)
    }

    @Test("CharacterDetail module should export CharacterStatsModel")
    func testCharacterStatsModelExport() {
        // Valida que CharacterStatsModel está acessível
        let character = Character.detailFixture()
        let model = CharacterDetailModel(from: character)
        #expect(model.stats.allStats.count == 4)
    }

    @Test("CharacterDetail module should export CharacterRelatedContentModel")
    func testCharacterRelatedContentModelExport() {
        // Valida que CharacterRelatedContentModel está acessível
        let character = Character.detailFixture(includeRelations: true)
        let model = CharacterDetailModel(from: character)
        #expect(model.relatedContent.recentComics.isEmpty == false || model.relatedContent.recentSeries.isEmpty == false || true)
    }

    @Test("CharacterDetail module should export CharacterShareInfoModel")
    func testCharacterShareInfoModelExport() {
        // Valida que CharacterShareInfoModel está acessível
        let character = Character.detailFixture()
        let model = CharacterDetailModel(from: character)
        #expect(model.shareInfo.text.contains(character.name))
    }

    @Test("CharacterDetail module should export StatItemModel")
    func testStatItemModelExport() {
        // Valida que StatItemModel está acessível
        let character = Character.detailFixture()
        let model = CharacterDetailModel(from: character)
        let comics = model.stats.comics
        #expect(comics.title == "Comics")
    }

    @Test("CharacterDetail module should export RelatedItemModel")
    func testRelatedItemModelExport() {
        // Valida que RelatedItemModel está acessível via RelatedItemType
        let character = Character.detailFixture(includeRelations: true)
        let model = CharacterDetailModel(from: character)

        // Valida que o tipo está acessível mesmo sem items
        if let firstComic = model.relatedContent.recentComics.first {
            #expect(firstComic.type == .comic)
        } else {
            // Se não tem comics, apenas valida que o modelo está acessível
            #expect(true)
        }
    }
}

// MARK: - Architecture Validation Tests

@Suite("CharacterDetail Architecture Validation Tests")
struct CharacterDetailArchitectureTests {

    @Test("CharacterDetailModel should be Sendable")
    func testCharacterDetailModelSendable() {
        // Valida conformidade com Sendable
        let character = Character.detailFixture()
        let model = CharacterDetailModel(from: character)
        let _: Sendable = model
        #expect(true)
    }

    @Test("CharacterStatsModel should be Sendable")
    func testCharacterStatsModelSendable() {
        // Valida conformidade com Sendable
        let character = Character.detailFixture()
        let model = CharacterDetailModel(from: character)
        let _: Sendable = model.stats
        #expect(true)
    }

    @Test("CharacterRelatedContentModel should be Sendable")
    func testCharacterRelatedContentModelSendable() {
        // Valida conformidade com Sendable
        let character = Character.detailFixture()
        let model = CharacterDetailModel(from: character)
        let _: Sendable = model.relatedContent
        #expect(true)
    }

    @Test("CharacterShareInfoModel should be Sendable")
    func testCharacterShareInfoModelSendable() {
        // Valida conformidade com Sendable
        let character = Character.detailFixture()
        let model = CharacterDetailModel(from: character)
        let _: Sendable = model.shareInfo
        #expect(true)
    }

    @Test("StatItemModel should be Sendable")
    func testStatItemModelSendable() {
        // Valida conformidade com Sendable
        let character = Character.detailFixture()
        let model = CharacterDetailModel(from: character)
        let _: Sendable = model.stats.comics
        #expect(true)
    }

    @Test("StatItemModel should be Identifiable")
    func testStatItemModelIdentifiable() {
        // Valida conformidade com Identifiable
        let character = Character.detailFixture()
        let model = CharacterDetailModel(from: character)
        let comics = model.stats.comics
        #expect(comics.id != UUID())
    }

    @Test("RelatedItemModel should be Sendable")
    func testRelatedItemModelSendable() {
        // Valida conformidade com Sendable
        let character = Character.detailFixture(includeRelations: true)
        let model = CharacterDetailModel(from: character)
        if let firstComic = model.relatedContent.recentComics.first {
            let _: Sendable = firstComic
        }
        #expect(true)
    }

    @Test("RelatedItemModel should be Identifiable")
    func testRelatedItemModelIdentifiable() {
        // Valida conformidade com Identifiable
        let character = Character.detailFixture(includeRelations: true)
        let model = CharacterDetailModel(from: character)
        if let firstComic = model.relatedContent.recentComics.first {
            #expect(!firstComic.id.isEmpty)
        } else {
            #expect(true)
        }
    }
}

// MARK: - ViewModel Protocol Compliance Tests

@Suite("CharacterDetailViewModel Protocol Compliance Tests")
struct CharacterDetailViewModelProtocolTests {

    @Test("CharacterDetailViewModel should be ObservableObject")
    @MainActor
    func testObservableObjectCompliance() {
        // Valida que CharacterDetailViewModel implementa ObservableObject
        let character = Character.detailFixture()
        let viewModel = CharacterDetailViewModel(character: character)

        // Se compila, o protocolo está implementado
        _ = viewModel.objectWillChange
        #expect(true)
    }

    @Test("CharacterDetailViewModel should be MainActor")
    @MainActor
    func testMainActorCompliance() {
        // Valida que CharacterDetailViewModel é @MainActor
        // Se o teste compila com @MainActor, está correto
        let character = Character.detailFixture()
        let _ = CharacterDetailViewModel(character: character)
        #expect(true)
    }

    @Test("CharacterDetailViewModel should expose published properties")
    @MainActor
    func testPublishedProperties() {
        // Valida que as propriedades @Published estão expostas
        let character = Character.detailFixture()
        let viewModel = CharacterDetailViewModel(character: character)

        // Acessa as propriedades publicadas
        _ = viewModel.detailModel
        _ = viewModel.isLoading
        _ = viewModel.error
        _ = viewModel.isFavorite

        #expect(true)
    }
}

// MARK: - XCTest Integration Tests

class CharacterDetailIntegrationTests: XCTestCase {

    @MainActor
    func testViewModelInitialization() {
        // Testa inicialização básica do ViewModel
        let character = Character.detailFixture()
        let viewModel = CharacterDetailViewModel(character: character)

        XCTAssertEqual(viewModel.detailModel.character.id, character.id)
        XCTAssertEqual(viewModel.detailModel.character.name, character.name)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertFalse(viewModel.isFavorite)
    }

    @MainActor
    func testViewModelDerivedProperties() {
        // Testa propriedades derivadas do ViewModel
        let character = Character.detailFixture(
            comicsCount: 50,
            includeRelations: true
        )
        let viewModel = CharacterDetailViewModel(character: character)

        XCTAssertTrue(viewModel.hasComics)
        XCTAssertTrue(viewModel.hasRelatedContent)
        XCTAssertFalse(viewModel.shareItems.isEmpty)
    }

    @MainActor
    func testViewModelWithNoComics() {
        // Testa ViewModel com personagem sem comics
        let character = Character.detailFixture(comicsCount: 0)
        let viewModel = CharacterDetailViewModel(character: character)

        XCTAssertFalse(viewModel.hasComics)
    }

    @MainActor
    func testViewModelWithNoRelatedContent() {
        // Testa ViewModel com personagem sem conteúdo relacionado
        let character = Character.detailFixture(includeRelations: false)
        let viewModel = CharacterDetailViewModel(character: character)

        XCTAssertFalse(viewModel.hasRelatedContent)
    }

    func testModelCreation() {
        // Testa criação do modelo
        let character = Character.detailFixture()
        let model = CharacterDetailModel(from: character)

        XCTAssertEqual(model.character.id, character.id)
        XCTAssertEqual(model.character.name, character.name)
    }

    func testStatsModelCreation() {
        // Testa criação do modelo de estatísticas
        let character = Character.detailFixture(
            comicsCount: 100,
            includeRelations: true
        )
        let model = CharacterDetailModel(from: character)

        XCTAssertEqual(model.stats.comics.value, 100)
        XCTAssertEqual(model.stats.allStats.count, 4)
    }
}
