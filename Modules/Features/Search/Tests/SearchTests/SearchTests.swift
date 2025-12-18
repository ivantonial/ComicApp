//
//  SearchTests.swift
//  Search
//
//  Created by Ivan Tonial IP.TV on 16/12/25.
//
//  NOTA: Este arquivo serve como ponto de entrada para os testes do módulo Search.
//  Os testes estão organizados em arquivos separados seguindo a arquitetura MVVM-C:
//
//  Estrutura dos testes:
//  ├── Doubles/
//  │   └── MockComicVineService+Search.swift - Mock para ComicVineServiceProtocol
//  ├── Fixtures/
//  │   ├── CharacterFixture+Search.swift     - Fixtures de Character para testes
//  │   └── ComicFixture+Search.swift         - Fixtures de Comic para testes
//  ├── Models/
//  │   ├── SearchFilterTests.swift           - Testes do SearchFilter
//  │   ├── SearchTypeTests.swift             - Testes do SearchType
//  │   └── SortOptionTests.swift             - Testes do SortOption
//  ├── UseCases/
//  │   └── SearchUseCasesTests.swift         - Testes dos UseCases de busca
//  └── ViewModels/
//      └── SearchViewModelTests.swift        - Testes do SearchViewModel
//

@testable import Search
@testable import ComicVineAPI
import Cache
import Foundation
import Testing
import XCTest

// MARK: - Search Module Export Tests

@Suite("Search Module Export Tests")
struct SearchModuleExportTests {

    @Test("Search module should export SearchFilter")
    func testSearchFilterExport() {
        // Valida que SearchFilter está acessível
        let filter = SearchFilter.all
        #expect(filter.id == "All")
        #expect(filter.title == "All")
        #expect(!filter.icon.isEmpty)
    }

    @Test("Search module should export SearchType")
    func testSearchTypeExport() {
        // Valida que SearchType está acessível
        let type = SearchType.characters
        #expect(type.id == "Characters")
        #expect(!type.icon.isEmpty)
    }

    @Test("Search module should export SortOption")
    func testSortOptionExport() {
        // Valida que SortOption está acessível
        let option = SortOption.name
        #expect(option.id == "Name")
        #expect(option.title == "Name")
        #expect(!option.icon.isEmpty)
    }

    @Test("Search module should export SearchViewModel")
    @MainActor
    func testSearchViewModelExport() {
        // Valida que SearchViewModel está acessível
        let mockService = MockSearchService()
        let viewModel = SearchViewModel(comicVineService: mockService)
        #expect(viewModel.searchText.isEmpty)
        #expect(viewModel.searchType == .characters)
    }

    @Test("Search module should export SearchCharactersWithCacheUseCase")
    func testSearchCharactersUseCaseExport() {
        // Valida que SearchCharactersWithCacheUseCase está acessível
        let mockService = MockSearchService()
        let useCase = SearchCharactersWithCacheUseCase(service: mockService)
        #expect(useCase != nil)
    }

    @Test("Search module should export SearchComicsWithCacheUseCase")
    func testSearchComicsUseCaseExport() {
        // Valida que SearchComicsWithCacheUseCase está acessível
        let mockService = MockSearchService()
        let useCase = SearchComicsWithCacheUseCase(service: mockService)
        #expect(useCase != nil)
    }

    @Test("Search module should export SearchView")
    @MainActor
    func testSearchViewExport() {
        // Valida que SearchView está acessível
        let mockService = MockSearchService()
        let viewModel = SearchViewModel(comicVineService: mockService)
        let view = SearchView(viewModel: viewModel) { _ in }
        #expect(view != nil)
    }
}

// MARK: - Architecture Validation Tests

@Suite("Search Architecture Validation Tests")
struct SearchArchitectureTests {

    @Test("SearchFilter should be CaseIterable")
    func testSearchFilterCaseIterable() {
        // Valida conformidade com CaseIterable
        let allCases = SearchFilter.allCases
        #expect(allCases.count == 7)
    }

    @Test("SearchFilter should be Identifiable")
    func testSearchFilterIdentifiable() {
        // Valida conformidade com Identifiable
        let filter = SearchFilter.heroes
        #expect(filter.id == filter.rawValue)
    }

    @Test("SearchFilter should be Sendable")
    func testSearchFilterSendable() {
        // Valida conformidade com Sendable
        let filter: Sendable = SearchFilter.all
        #expect(filter is SearchFilter)
    }

    @Test("SearchType should be CaseIterable")
    func testSearchTypeCaseIterable() {
        // Valida conformidade com CaseIterable
        let allCases = SearchType.allCases
        #expect(allCases.count == 2)
    }

    @Test("SearchType should be Identifiable")
    func testSearchTypeIdentifiable() {
        // Valida conformidade com Identifiable
        let type = SearchType.comics
        #expect(type.id == type.rawValue)
    }

    @Test("SortOption should be CaseIterable")
    func testSortOptionCaseIterable() {
        // Valida conformidade com CaseIterable
        let allCases = SortOption.allCases
        #expect(allCases.count == 3)
    }

    @Test("SortOption should be Identifiable")
    func testSortOptionIdentifiable() {
        // Valida conformidade com Identifiable
        let option = SortOption.popularity
        #expect(option.id == option.rawValue)
    }

    @Test("SearchViewModel should be ObservableObject")
    @MainActor
    func testSearchViewModelObservableObject() {
        // Valida conformidade com ObservableObject
        let mockService = MockSearchService()
        let viewModel = SearchViewModel(comicVineService: mockService)
        #expect(viewModel.objectWillChange != nil)
    }

    @Test("SearchViewModel should be MainActor isolated")
    @MainActor
    func testSearchViewModelMainActor() {
        // Valida isolamento MainActor
        let mockService = MockSearchService()
        let viewModel = SearchViewModel(comicVineService: mockService)
        // Se compilou, está no MainActor
        #expect(viewModel.searchText.isEmpty)
    }

    @Test("SearchCharactersWithCacheUseCase should be Sendable")
    func testSearchCharactersUseCaseSendable() {
        // Valida conformidade com Sendable
        let mockService = MockSearchService()
        let useCase: Sendable = SearchCharactersWithCacheUseCase(service: mockService)
        #expect(useCase is SearchCharactersWithCacheUseCase)
    }

    @Test("SearchComicsWithCacheUseCase should be Sendable")
    func testSearchComicsUseCaseSendable() {
        // Valida conformidade com Sendable
        let mockService = MockSearchService()
        let useCase: Sendable = SearchComicsWithCacheUseCase(service: mockService)
        #expect(useCase is SearchComicsWithCacheUseCase)
    }
}

// MARK: - SearchFilter Method Tests

@Suite("SearchFilter Method Tests")
struct SearchFilterMethodTests {

    @Test("filters(for: .characters) should return character filters")
    func testFiltersForCharacters() {
        // Act
        let filters = SearchFilter.filters(for: .characters)

        // Assert
        #expect(filters.count == 4)
        #expect(filters.contains(.all))
        #expect(filters.contains(.heroes))
        #expect(filters.contains(.villains))
        #expect(filters.contains(.teams))
    }

    @Test("filters(for: .comics) should return comic filters")
    func testFiltersForComics() {
        // Act
        let filters = SearchFilter.filters(for: .comics)

        // Assert
        #expect(filters.count == 4)
        #expect(filters.contains(.all))
        #expect(filters.contains(.ongoing))
        #expect(filters.contains(.completed))
        #expect(filters.contains(.special))
    }

    @Test("filters(for:) should always include .all filter first")
    func testFiltersAlwaysIncludeAll() {
        // Act
        let characterFilters = SearchFilter.filters(for: .characters)
        let comicFilters = SearchFilter.filters(for: .comics)

        // Assert
        #expect(characterFilters.first == .all)
        #expect(comicFilters.first == .all)
    }
}

// MARK: - XCTest Integration Tests

class SearchModuleXCTests: XCTestCase {

    func testSearchFilterAllCases() {
        // Arrange & Act
        let allCases = SearchFilter.allCases

        // Assert
        XCTAssertEqual(allCases.count, 7)
        XCTAssertTrue(allCases.contains(.all))
        XCTAssertTrue(allCases.contains(.heroes))
        XCTAssertTrue(allCases.contains(.villains))
        XCTAssertTrue(allCases.contains(.teams))
        XCTAssertTrue(allCases.contains(.ongoing))
        XCTAssertTrue(allCases.contains(.completed))
        XCTAssertTrue(allCases.contains(.special))
    }

    func testSearchTypeAllCases() {
        // Arrange & Act
        let allCases = SearchType.allCases

        // Assert
        XCTAssertEqual(allCases.count, 2)
        XCTAssertTrue(allCases.contains(.characters))
        XCTAssertTrue(allCases.contains(.comics))
    }

    func testSortOptionAllCases() {
        // Arrange & Act
        let allCases = SortOption.allCases

        // Assert
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.name))
        XCTAssertTrue(allCases.contains(.popularity))
        XCTAssertTrue(allCases.contains(.recent))
    }

    @MainActor
    func testSearchViewModelInitialization() {
        // Arrange
        let mockService = MockSearchService()

        // Act
        let viewModel = SearchViewModel(comicVineService: mockService)

        // Assert
        XCTAssertTrue(viewModel.searchText.isEmpty)
        XCTAssertEqual(viewModel.searchType, .characters)
        XCTAssertEqual(viewModel.selectedFilter, .all)
        XCTAssertEqual(viewModel.sortOption, .name)
        XCTAssertTrue(viewModel.characterResults.isEmpty)
        XCTAssertTrue(viewModel.comicResults.isEmpty)
        XCTAssertFalse(viewModel.isSearching)
        XCTAssertNil(viewModel.error)
    }

    func testSearchFilterFiltersForType() {
        // Act
        let characterFilters = SearchFilter.filters(for: .characters)
        let comicFilters = SearchFilter.filters(for: .comics)

        // Assert
        XCTAssertEqual(characterFilters.count, 4)
        XCTAssertEqual(comicFilters.count, 4)
        XCTAssertEqual(characterFilters.first, .all)
        XCTAssertEqual(comicFilters.first, .all)
    }
}
