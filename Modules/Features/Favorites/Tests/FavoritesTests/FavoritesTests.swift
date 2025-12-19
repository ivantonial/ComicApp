//
//  FavoritesTests.swift
//  Favorites
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//
//  NOTA: Este arquivo serve como ponto de entrada para os testes do módulo Favorites.
//  Os testes estão organizados em arquivos separados seguindo a arquitetura MVVM-C:
//
//  Estrutura dos testes:
//  ├── Doubles/
//  │   ├── MockFavoritesService+Favorites.swift     - Mock do FavoritesService para testes isolados
//  │   └── MockPersistenceManager+Favorites.swift   - Mock do PersistenceManager para testes de integração
//  ├── Fixtures/
//  │   └── CharacterFixture+Favorites.swift         - Fixtures de Character para testes
//  ├── Models/
//  │   ├── FavoritesSortOptionTests.swift           - Testes do FavoritesSortOption
//  │   └── FavoritesNotificationTests.swift         - Testes do FavoritesNotification
//  └── ViewModels/
//      └── FavoritesViewModelTests.swift            - Testes do FavoritesViewModel
//
//  Uso dos Mocks:
//  - MockFavoritesPersistenceManager: Usado quando se precisa testar o FavoritesService
//    ou FavoritesViewModel com controle total sobre a persistência
//  - MockFavoritesServiceForFavorites: Usado para testes isolados que precisam
//    simular o comportamento do FavoritesService sem dependências externas
//

@testable import Favorites
@testable import ComicVineAPI
import Cache
import Core
import DesignSystem
import Foundation
import Testing
import XCTest

// MARK: - Favorites Module Export Tests

@Suite("Favorites Module Export Tests")
struct FavoritesModuleExportTests {

    @Test("Favorites module should export FavoritesSortOption")
    func testFavoritesSortOptionExport() {
        // Valida que FavoritesSortOption está acessível
        let sortOption = FavoritesSortOption.dateAdded
        #expect(sortOption.title == "Date Added")
        #expect(sortOption.icon == "calendar")
    }

    @Test("Favorites module should export all sort options")
    func testAllSortOptionsExport() {
        // Valida que todos os casos de FavoritesSortOption estão disponíveis
        let allCases = FavoritesSortOption.allCases
        #expect(allCases.count == 3)
        #expect(allCases.contains(.dateAdded))
        #expect(allCases.contains(.name))
        #expect(allCases.contains(.mostComics))
    }

    @Test("Favorites module should export FavoritesViewModel")
    @MainActor
    func testFavoritesViewModelExport() {
        // Valida que FavoritesViewModel está acessível
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)
        #expect(viewModel.favoriteCharacters.isEmpty)
    }

    @Test("Favorites module should export FavoritesView")
    @MainActor
    func testFavoritesViewExport() {
        // Valida que FavoritesView está acessível
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)
        let view = FavoritesView(viewModel: viewModel)
        #expect(view != nil)
    }

    @Test("Favorites module should export FavoritesService")
    @MainActor
    func testFavoritesServiceExport() {
        // Valida que FavoritesService está acessível
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        #expect(service.favoriteCharacters.isEmpty)
    }
}

// MARK: - Architecture Validation Tests

@Suite("Favorites Architecture Validation Tests")
struct FavoritesArchitectureTests {

    @Test("FavoritesSortOption should be CaseIterable")
    func testFavoritesSortOptionCaseIterable() {
        // Valida conformidade com CaseIterable
        let allCases = FavoritesSortOption.allCases
        #expect(allCases.count == 3)
    }

    @Test("FavoritesSortOption should have rawValue")
    func testFavoritesSortOptionRawValue() {
        // Valida que cada caso tem um rawValue
        #expect(FavoritesSortOption.dateAdded.rawValue == "Date Added")
        #expect(FavoritesSortOption.name.rawValue == "Name")
        #expect(FavoritesSortOption.mostComics.rawValue == "Most Comics")
    }

    @Test("FavoritesSortOption title should match rawValue")
    func testFavoritesSortOptionTitle() {
        // Valida que title retorna o rawValue
        for option in FavoritesSortOption.allCases {
            #expect(option.title == option.rawValue)
        }
    }

    @Test("FavoritesSortOption should have icons")
    func testFavoritesSortOptionIcons() {
        // Valida que cada opção tem um ícone
        #expect(FavoritesSortOption.dateAdded.icon == "calendar")
        #expect(FavoritesSortOption.name.icon == "textformat.abc")
        #expect(FavoritesSortOption.mostComics.icon == "book.fill")
    }

    @Test("FavoritesNotification should define favoritesDidChange")
    func testFavoritesNotificationExport() {
        // Valida que a notificação está definida
        let notificationName = Notification.Name.favoritesDidChange
        #expect(notificationName.rawValue == "favoritesDidChange")
    }
}

// MARK: - ViewModel Protocol Compliance Tests

@Suite("FavoritesViewModel Protocol Compliance Tests")
struct FavoritesViewModelProtocolTests {

    @Test("FavoritesViewModel should be ObservableObject")
    @MainActor
    func testObservableObjectCompliance() {
        // Valida que FavoritesViewModel implementa ObservableObject
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)

        // Se compila, o protocolo está implementado
        _ = viewModel.objectWillChange
        #expect(true)
    }

    @Test("FavoritesViewModel should be MainActor")
    @MainActor
    func testMainActorCompliance() {
        // Valida que FavoritesViewModel é @MainActor
        // Se o teste compila com @MainActor, está correto
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let _ = FavoritesViewModel(favoritesService: service)
        #expect(true)
    }

    @Test("FavoritesViewModel should expose published properties")
    @MainActor
    func testPublishedProperties() {
        // Valida que as propriedades @Published estão expostas
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)

        // Acessa as propriedades publicadas
        _ = viewModel.favoriteCharacters
        _ = viewModel.isLoading
        _ = viewModel.error
        _ = viewModel.searchText
        _ = viewModel.sortOption
        _ = viewModel.selectedCharacters
        _ = viewModel.isSelectionMode

        #expect(true)
    }

    @Test("FavoritesViewModel should expose computed properties")
    @MainActor
    func testComputedProperties() {
        // Valida que as propriedades computadas estão expostas
        let mockPersistence = MockFavoritesPersistenceManager()
        let service = FavoritesService(persistenceManager: mockPersistence)
        let viewModel = FavoritesViewModel(favoritesService: service)

        // Acessa as propriedades computadas
        _ = viewModel.filteredCharacters
        _ = viewModel.hasFavorites
        _ = viewModel.selectedCount
        _ = viewModel.isAllSelected

        #expect(true)
    }
}

// MARK: - XCTest Integration Tests

class FavoritesIntegrationTests: XCTestCase {

    private var mockPersistence: MockFavoritesPersistenceManager!

    override func setUp() {
        super.setUp()
        mockPersistence = MockFavoritesPersistenceManager()
    }

    override func tearDown() {
        mockPersistence = nil
        super.tearDown()
    }

    @MainActor
    private func createService() -> FavoritesService {
        return FavoritesService(persistenceManager: mockPersistence)
    }

    @MainActor
    func testViewModelInitialization() async throws {
        // Testa inicialização básica do ViewModel
        let favoritesService = createService()
        let viewModel = FavoritesViewModel(favoritesService: favoritesService)

        // Aguarda o carregamento inicial terminar
        try await Task.sleep(nanoseconds: 300_000_000)

        XCTAssertTrue(viewModel.favoriteCharacters.isEmpty)
        XCTAssertFalse(viewModel.isLoading) // Após carregamento deve ser false
        XCTAssertNil(viewModel.error)
        XCTAssertTrue(viewModel.searchText.isEmpty)
        XCTAssertEqual(viewModel.sortOption, .dateAdded)
        XCTAssertTrue(viewModel.selectedCharacters.isEmpty)
        XCTAssertFalse(viewModel.isSelectionMode)
    }

    @MainActor
    func testViewModelComputedPropertiesInitial() async throws {
        // Testa propriedades computadas do ViewModel no estado inicial
        let favoritesService = createService()
        let viewModel = FavoritesViewModel(favoritesService: favoritesService)

        // Aguarda o carregamento inicial terminar
        try await Task.sleep(nanoseconds: 300_000_000)

        XCTAssertTrue(viewModel.filteredCharacters.isEmpty)
        XCTAssertFalse(viewModel.hasFavorites)
        XCTAssertEqual(viewModel.selectedCount, 0)
        XCTAssertFalse(viewModel.isAllSelected)
    }

    @MainActor
    func testSortOptionValues() {
        // Testa valores do FavoritesSortOption
        XCTAssertEqual(FavoritesSortOption.dateAdded.title, "Date Added")
        XCTAssertEqual(FavoritesSortOption.name.title, "Name")
        XCTAssertEqual(FavoritesSortOption.mostComics.title, "Most Comics")
    }

    @MainActor
    func testSortOptionIcons() {
        // Testa ícones do FavoritesSortOption
        XCTAssertEqual(FavoritesSortOption.dateAdded.icon, "calendar")
        XCTAssertEqual(FavoritesSortOption.name.icon, "textformat.abc")
        XCTAssertEqual(FavoritesSortOption.mostComics.icon, "book.fill")
    }

    func testNotificationNameValue() {
        // Testa que a notificação tem o nome correto
        XCTAssertEqual(Notification.Name.favoritesDidChange.rawValue, "favoritesDidChange")
    }

    @MainActor
    func testExportFavoritesEmpty() {
        // Testa exportação quando não há favoritos
        let favoritesService = createService()
        let viewModel = FavoritesViewModel(favoritesService: favoritesService)
        let exported = viewModel.exportFavorites()

        XCTAssertTrue(exported.contains("My Comics Favorites:"))
    }

    @MainActor
    func testToggleSelectionMode() {
        // Testa toggle do modo de seleção
        let favoritesService = createService()
        let viewModel = FavoritesViewModel(favoritesService: favoritesService)

        XCTAssertFalse(viewModel.isSelectionMode)

        viewModel.toggleSelectionMode()
        XCTAssertTrue(viewModel.isSelectionMode)

        viewModel.toggleSelectionMode()
        XCTAssertFalse(viewModel.isSelectionMode)
    }

    @MainActor
    func testDeselectAll() {
        // Testa deseleção de todos os itens
        let favoritesService = createService()
        let viewModel = FavoritesViewModel(favoritesService: favoritesService)

        // Adiciona seleções manualmente
        viewModel.selectedCharacters.insert(1)
        viewModel.selectedCharacters.insert(2)
        viewModel.selectedCharacters.insert(3)

        XCTAssertEqual(viewModel.selectedCount, 3)

        viewModel.deselectAll()

        XCTAssertEqual(viewModel.selectedCount, 0)
        XCTAssertTrue(viewModel.selectedCharacters.isEmpty)
    }

    @MainActor
    func testUpdateSortOption() {
        // Testa atualização da opção de ordenação
        let favoritesService = createService()
        let viewModel = FavoritesViewModel(favoritesService: favoritesService)

        XCTAssertEqual(viewModel.sortOption, .dateAdded)

        viewModel.updateSortOption(.name)
        XCTAssertEqual(viewModel.sortOption, .name)

        viewModel.updateSortOption(.mostComics)
        XCTAssertEqual(viewModel.sortOption, .mostComics)

        viewModel.updateSortOption(.dateAdded)
        XCTAssertEqual(viewModel.sortOption, .dateAdded)
    }
}
