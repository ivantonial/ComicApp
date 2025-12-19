//
//  ComicsListTests.swift
//  ComicsList
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//
//  NOTA: Este arquivo serve como ponto de entrada para os testes do módulo ComicsList.
//  Os testes estão organizados em arquivos separados seguindo a arquitetura MVVM-C:
//
//  Estrutura dos testes:
//  ├── Doubles/
//  │   └── MockComicVineService+ComicsList.swift      - Mock para ComicVineServiceProtocol
//  ├── Fixtures/
//  │   ├── CharacterFixture+ComicsList.swift          - Fixtures de Character para testes
//  │   └── ComicFixture+ComicsList.swift              - Fixtures de Comic para testes
//  ├── Models/
//  │   ├── ComicCardModelTests.swift                  - Testes do ComicCardModel
//  │   └── ComicFilterTests.swift                     - Testes do ComicFilter
//  └── ViewModels/
//      └── ComicsListViewModelTests.swift             - Testes do ComicsListViewModel
//

@testable import ComicsList
@testable import ComicVineAPI
import DesignSystem
import Foundation
import Testing
import XCTest

// MARK: - ComicsList Module Export Tests

@Suite("ComicsList Module Export Tests")
struct ComicsListModuleExportTests {

    @Test("ComicsList module should export ComicCardModel")
    func testComicCardModelExport() {
        // Valida que ComicCardModel está acessível
        let comic = Comic.comicsListFixture()
        let model = ComicCardModel(from: comic)
        #expect(model.id == comic.id)
        #expect(model.title == comic.title)
    }

    @Test("ComicsList module should export ComicFilter")
    func testComicFilterExport() {
        // Valida que ComicFilter está acessível
        let filter = ComicFilter.all
        #expect(filter.rawValue == "All")
        #expect(filter.title == "All")
    }

    @Test("ComicsList module should export ComicsListViewModel")
    @MainActor
    func testComicsListViewModelExport() {
        // Valida que ComicsListViewModel está acessível
        let character = Character.comicsListFixture()
        let mockService = MockComicsListService()
        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )
        #expect(viewModel.character.id == character.id)
    }

    @Test("ComicsList module should export ComicsListView")
    @MainActor
    func testComicsListViewExport() {
        // Valida que ComicsListView está acessível
        let character = Character.comicsListFixture()
        let mockService = MockComicsListService()
        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )
        // Se compila, a View está exportada corretamente
        let _ = ComicsListView(viewModel: viewModel)
        #expect(true)
    }
}

// MARK: - Architecture Validation Tests

@Suite("ComicsList Architecture Validation Tests")
struct ComicsListArchitectureTests {

    @Test("ComicCardModel should be Identifiable")
    func testComicCardModelIdentifiable() {
        // Valida conformidade com Identifiable
        let comic = Comic.comicsListFixture(id: 42)
        let model = ComicCardModel(from: comic)
        #expect(model.id == 42)
    }

    @Test("ComicCardModel should be Sendable")
    func testComicCardModelSendable() async {
        // Valida conformidade com Sendable
        let comic = Comic.comicsListFixture()
        let model = ComicCardModel(from: comic)

        let result = await Task.detached {
            return model.title
        }.value

        #expect(result == comic.title)
    }

    @Test("ComicCardModel should be ContentCardConvertible")
    func testComicCardModelContentCardConvertible() {
        // Valida conformidade com ContentCardConvertible
        let comic = Comic.comicsListFixture(
            id: 1,
            volumeName: "Amazing Spider-Man",
            issueNumber: "100"
        )
        let model = ComicCardModel(from: comic)
        let contentCardModel = model.toContentCardModel()
        #expect(contentCardModel.title == "Amazing Spider-Man #100")
    }

    @Test("ComicFilter should be CaseIterable")
    func testComicFilterCaseIterable() {
        // Valida conformidade com CaseIterable
        let allCases = ComicFilter.allCases
        #expect(allCases.count == 4)
        #expect(allCases.contains(.all))
        #expect(allCases.contains(.recent))
        #expect(allCases.contains(.popular))
        #expect(allCases.contains(.classic))
    }

    @Test("ComicFilter should be Identifiable")
    func testComicFilterIdentifiable() {
        // Valida conformidade com Identifiable
        let filter = ComicFilter.recent
        #expect(filter.id == "Recent")
    }
}

// MARK: - ViewModel Protocol Compliance Tests

@Suite("ComicsListViewModel Protocol Compliance Tests")
struct ComicsListViewModelProtocolTests {

    @Test("ComicsListViewModel should be ObservableObject")
    @MainActor
    func testObservableObjectCompliance() {
        // Valida que ComicsListViewModel implementa ObservableObject
        let character = Character.comicsListFixture()
        let mockService = MockComicsListService()
        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        // Se compila, o protocolo está implementado
        _ = viewModel.objectWillChange
        #expect(true)
    }

    @Test("ComicsListViewModel should be MainActor")
    @MainActor
    func testMainActorCompliance() {
        // Valida que ComicsListViewModel é @MainActor
        // Se o teste compila com @MainActor, está correto
        let character = Character.comicsListFixture()
        let mockService = MockComicsListService()
        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let _ = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )
        #expect(true)
    }

    @Test("ComicsListViewModel should expose published properties")
    @MainActor
    func testPublishedProperties() {
        // Valida que as propriedades @Published estão expostas
        let character = Character.comicsListFixture()
        let mockService = MockComicsListService()
        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        // Acessa as propriedades publicadas
        _ = viewModel.comics
        _ = viewModel.isLoading
        _ = viewModel.error
        _ = viewModel.selectedFilter
        _ = viewModel.hasMorePages
        _ = viewModel.selectedComic
        _ = viewModel.loadingProgress
        _ = viewModel.loadingMessage

        #expect(true)
    }
}

// MARK: - XCTest Integration Tests

class ComicsListIntegrationTests: XCTestCase {

    @MainActor
    func testViewModelInitialization() {
        // Testa inicialização básica do ViewModel
        let character = Character.comicsListFixture()
        let mockService = MockComicsListService()
        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        XCTAssertTrue(viewModel.comics.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertEqual(viewModel.selectedFilter, .all)
        XCTAssertTrue(viewModel.hasMorePages)
        XCTAssertNil(viewModel.selectedComic)
    }

    @MainActor
    func testViewModelComputedProperties() {
        // Testa propriedades computadas do ViewModel
        let character = Character.comicsListFixture()
        let mockService = MockComicsListService()
        let useCase = FetchIssuesByIdsUseCase(service: mockService)
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: useCase
        )

        // Verifica propriedades computadas iniciais
        XCTAssertEqual(viewModel.filteredComics.count, 0)
        // totalComics retorna o count de issueCredits quando disponível (10 na fixture padrão)
        // não o countOfIssueAppearances
        XCTAssertEqual(viewModel.totalComics, 10)
        XCTAssertFalse(viewModel.hasFilters)
    }

    func testComicCardModelCreation() {
        // Testa criação do modelo de card
        let comic = Comic.comicsListFixture()
        let cardModel = ComicCardModel(from: comic)

        XCTAssertEqual(cardModel.id, comic.id)
        XCTAssertEqual(cardModel.title, comic.title)
        XCTAssertEqual(cardModel.issueNumber, comic.issueNumber)
        XCTAssertEqual(cardModel.coverDate, comic.coverDate)
    }

    func testComicCardModelContentCardConversion() {
        // Testa conversão para ContentCardModel
        let comic = Comic.comicsListFixture(
            id: 1,
            volumeName: "X-Men",
            issueNumber: "50",
            coverDate: "2024-06-01"
        )
        let cardModel = ComicCardModel(from: comic)
        let contentModel = cardModel.toContentCardModel()

        XCTAssertEqual(contentModel.id, 1)
        XCTAssertEqual(contentModel.title, "X-Men #50")
        XCTAssertEqual(contentModel.subtitle, "Issue #50")
        XCTAssertEqual(contentModel.aspectRatio, 3.0 / 4.0, accuracy: 0.001)
        XCTAssertNotNil(contentModel.badge)
    }

    func testComicFilterValues() {
        // Testa valores do ComicFilter
        XCTAssertEqual(ComicFilter.all.title, "All")
        XCTAssertEqual(ComicFilter.recent.title, "Recent")
        XCTAssertEqual(ComicFilter.popular.title, "Popular")
        XCTAssertEqual(ComicFilter.classic.title, "Classic")
    }

    func testComicFilterIdentifiers() {
        // Testa identificadores do ComicFilter
        for filter in ComicFilter.allCases {
            XCTAssertEqual(filter.id, filter.rawValue)
        }
    }
}
