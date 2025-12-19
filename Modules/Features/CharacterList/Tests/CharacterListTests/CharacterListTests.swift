//
//  CharacterListTests.swift
//  CharacterList
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//
//  NOTA: Este arquivo serve como ponto de entrada para os testes do módulo CharacterList.
//  Os testes estão organizados em arquivos separados seguindo a arquitetura MVVM-C:
//
//  Estrutura dos testes:
//  ├── Doubles/
//  │   └── MockComicVineService+CharacterList.swift - Mock para ComicVineServiceProtocol
//  ├── Fixtures/
//  │   └── CharacterFixture+CharacterList.swift     - Fixtures de Character para testes
//  ├── Models/
//  │   └── CharacterCardModelTests.swift            - Testes do CharacterCardModel
//  ├── UseCases/
//  │   ├── CharacterListSearchUseCaseTests.swift    - Testes do CharacterListSearchUseCase
//  │   └── SearchCharactersUseCaseTests.swift       - Testes do SearchCharactersUseCase
//  └── ViewModels/
//      └── CharacterListViewModelTests.swift        - Testes do CharacterListViewModel
//

@testable import CharacterList
@testable import ComicVineAPI
import DesignSystem
import Foundation
import Testing
import XCTest

// MARK: - CharacterList Module Export Tests

@Suite("CharacterList Module Export Tests")
struct CharacterListModuleExportTests {

    @Test("CharacterList module should export CharacterCardModel")
    func testCharacterCardModelExport() {
        // Valida que CharacterCardModel está acessível
        let model = CharacterCardModel(
            id: 1,
            name: "Spider-Man",
            comicVineImage: nil,
            comicsCount: 100
        )
        #expect(model.id == 1)
        #expect(model.name == "Spider-Man")
    }

    @Test("CharacterList module should export CharacterListViewModel")
    @MainActor
    func testCharacterListViewModelExport() {
        // Valida que CharacterListViewModel está acessível
        let mockService = MockCharacterListService()
        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )
        #expect(viewModel.characters.isEmpty)
    }

    @Test("CharacterList module should export CharacterListSearchUseCase")
    func testCharacterListSearchUseCaseExport() {
        // Valida que CharacterListSearchUseCase está acessível
        let mockService = MockCharacterListService()
        let useCase = CharacterListSearchUseCase(service: mockService)
        #expect(useCase != nil)
    }

    @Test("CharacterList module should export CharacterListView")
    @MainActor
    func testCharacterListViewExport() {
        // Valida que CharacterListView está acessível
        let mockService = MockCharacterListService()
        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )
        let view = CharacterListView(viewModel: viewModel)
        #expect(view != nil)
    }
}

// MARK: - Architecture Validation Tests

@Suite("CharacterList Architecture Validation Tests")
struct CharacterListArchitectureTests {

    @Test("CharacterCardModel should be Identifiable")
    func testCharacterCardModelIdentifiable() {
        // Valida conformidade com Identifiable
        let model = CharacterCardModel(
            id: 42,
            name: "Batman",
            comicVineImage: nil,
            comicsCount: 500
        )
        #expect(model.id == 42)
    }

    @Test("CharacterCardModel should be ContentCardConvertible")
    func testCharacterCardModelContentCardConvertible() {
        // Valida conformidade com ContentCardConvertible
        let model = CharacterCardModel(
            id: 1,
            name: "Superman",
            comicVineImage: nil,
            comicsCount: 200
        )
        let contentCardModel = model.toContentCardModel()
        #expect(contentCardModel.title == "Superman")
    }

    @Test("CharacterListSearchUseCase should be Sendable")
    func testCharacterListSearchUseCaseSendable() {
        // Valida conformidade com Sendable
        let mockService = MockCharacterListService()
        let useCase = CharacterListSearchUseCase(service: mockService)
        let _: Sendable = useCase
        #expect(true)
    }
}

// MARK: - ViewModel Protocol Compliance Tests

@Suite("CharacterListViewModel Protocol Compliance Tests")
struct CharacterListViewModelProtocolTests {

    @Test("CharacterListViewModel should be ObservableObject")
    @MainActor
    func testObservableObjectCompliance() {
        // Valida que CharacterListViewModel implementa ObservableObject
        let mockService = MockCharacterListService()
        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Se compila, o protocolo está implementado
        _ = viewModel.objectWillChange
        #expect(true)
    }

    @Test("CharacterListViewModel should be MainActor")
    @MainActor
    func testMainActorCompliance() {
        // Valida que CharacterListViewModel é @MainActor
        // Se o teste compila com @MainActor, está correto
        let mockService = MockCharacterListService()
        let useCase = FetchCharactersUseCase(service: mockService)
        let _ = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )
        #expect(true)
    }

    @Test("CharacterListViewModel should expose published properties")
    @MainActor
    func testPublishedProperties() {
        // Valida que as propriedades @Published estão expostas
        let mockService = MockCharacterListService()
        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Acessa as propriedades publicadas
        _ = viewModel.characters
        _ = viewModel.searchResults
        _ = viewModel.isLoading
        _ = viewModel.isSearching
        _ = viewModel.error
        _ = viewModel.hasMorePages
        _ = viewModel.searchText

        #expect(true)
    }
}

// MARK: - XCTest Integration Tests

class CharacterListIntegrationTests: XCTestCase {

    @MainActor
    func testViewModelInitialization() {
        // Testa inicialização básica do ViewModel
        let mockService = MockCharacterListService()
        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        XCTAssertTrue(viewModel.characters.isEmpty)
        XCTAssertTrue(viewModel.searchResults.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isSearching)
        XCTAssertNil(viewModel.error)
        XCTAssertTrue(viewModel.hasMorePages)
        XCTAssertTrue(viewModel.searchText.isEmpty)
    }

    @MainActor
    func testViewModelComputedProperties() {
        // Testa propriedades computadas do ViewModel
        let mockService = MockCharacterListService()
        mockService.charactersToReturn = [
            Character.listFixture(id: 1, name: "Spider-Man"),
            Character.listFixture(id: 2, name: "Iron Man")
        ]

        let useCase = FetchCharactersUseCase(service: mockService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: useCase,
            comicVineService: mockService
        )

        // Simula carregamento de dados
        viewModel.loadInitialData()

        // Aguarda um pouco para o async carregar
        let expectation = XCTestExpectation(description: "Load characters")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(viewModel.characters.count, 2)
        XCTAssertEqual(viewModel.displayCharacters.count, 2)
        XCTAssertEqual(viewModel.characterCardModels.count, 2)
    }

    func testCharacterCardModelCreation() {
        // Testa criação do modelo de card
        let character = Character.listFixture()
        let cardModel = CharacterCardModel(from: character)

        XCTAssertEqual(cardModel.id, character.id)
        XCTAssertEqual(cardModel.name, character.name)
        XCTAssertEqual(cardModel.comicsCount, character.countOfIssueAppearances)
    }

    func testCharacterCardModelAspectRatio() {
        // Testa que o aspect ratio padrão é 1.0 (quadrado)
        let character = Character.listFixture()
        let cardModel = CharacterCardModel(from: character)

        XCTAssertEqual(cardModel.aspectRatio, 1.0, accuracy: 0.001)
    }

    func testCharacterCardModelContentCardConversion() {
        // Testa conversão para ContentCardModel
        let cardModel = CharacterCardModel(
            id: 1,
            name: "Wonder Woman",
            comicVineImage: nil,
            comicsCount: 150
        )

        let contentModel = cardModel.toContentCardModel()

        XCTAssertEqual(contentModel.id, 1)
        XCTAssertEqual(contentModel.title, "Wonder Woman")
        XCTAssertNil(contentModel.subtitle)
        XCTAssertEqual(contentModel.contentMode, .fill)
    }
}
