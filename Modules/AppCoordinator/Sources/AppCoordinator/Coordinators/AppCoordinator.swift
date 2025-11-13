// The Swift Programming Language
// https://docs.swift.org/swift-book

import CharacterDetail
import CharacterList
import ComicsList
import Core
import Favorites
import ComicVineAPI
import Networking
import Search
import Settings
import SwiftUI
import Cache

@MainActor
public final class AppCoordinator: ObservableObject {
    // MARK: - Tab Management
    @Published public var selectedTab: AppTab = .characters

    // MARK: - Navigation Paths for each tab
    @Published public var charactersPath = NavigationPath()
    @Published public var searchPath = NavigationPath()
    @Published public var favoritesPath = NavigationPath()
    @Published public var settingsPath = NavigationPath()

    // MARK: - Services
    private let networkService: NetworkServiceProtocol
    private let comicVineService: ComicVineAPIService
    private let persistenceManager: PersistenceManager
    private let favoritesService: FavoritesService

    // MARK: - View Models (mantém estado entre navegações)
    private var searchViewModel: SearchViewModel?
    private var favoritesViewModel: FavoritesViewModel?
    private var settingsViewModel: SettingsViewModel?

    // MARK: - Inicialização
    public init() {
        // Ler a chave da ComicVine API diretamente do Info.plist
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "COMIC_VINE_API_KEY") as? String ?? ""

        #if DEBUG
        print("🔑 ComicVine API Key:", apiKey.isEmpty ? "⚠️ Vazia" : "✅ Encontrada")
        #endif

        guard !apiKey.isEmpty else {
            fatalError("""
                ❌ COMIC_VINE_API_KEY não encontrada!
                Verifique se o arquivo Secrets.xcconfig existe e contém sua chave da API.
                """)
        }

        // Configurar serviços
        self.networkService = NetworkService()
        self.comicVineService = ComicVineAPIService(networkService: networkService, apiKey: apiKey)
        self.persistenceManager = PersistenceManager()
        self.favoritesService = FavoritesService(persistenceManager: persistenceManager)
    }

    // MARK: - Private Bindings Helpers
    private var selectedTabBinding: Binding<AppTab> {
        Binding<AppTab>(
            get: { self.selectedTab },
            set: { self.selectedTab = $0 }
        )
    }

    private var charactersPathBinding: Binding<NavigationPath> {
        Binding<NavigationPath>(
            get: { self.charactersPath },
            set: { self.charactersPath = $0 }
        )
    }

    private var searchPathBinding: Binding<NavigationPath> {
        Binding<NavigationPath>(
            get: { self.searchPath },
            set: { self.searchPath = $0 }
        )
    }

    private var favoritesPathBinding: Binding<NavigationPath> {
        Binding<NavigationPath>(
            get: { self.favoritesPath },
            set: { self.favoritesPath = $0 }
        )
    }

    private var settingsPathBinding: Binding<NavigationPath> {
        Binding<NavigationPath>(
            get: { self.settingsPath },
            set: { self.settingsPath = $0 }
        )
    }

    // MARK: - Main View
    public func start() -> some View {
        TabView(selection: selectedTabBinding) {
            // Tab 1: Characters
            NavigationStack(path: charactersPathBinding) {
                makeCharacterListView()
                    .navigationDestination(for: CharacterDestination.self) { destination in
                        switch destination {
                        case .detail(let character):
                            self.makeCharacterDetailView(character: character)
                        case .comics(let character):
                            self.makeComicsListView(for: character)
                        }
                    }
            }
            .tabItem {
                Label(AppTab.characters.rawValue, systemImage: AppTab.characters.icon)
            }
            .tag(AppTab.characters)

            // Tab 2: Search
            NavigationStack(path: searchPathBinding) {
                makeSearchView()
                    .navigationDestination(for: CharacterDestination.self) { destination in
                        switch destination {
                        case .detail(let character):
                            self.makeCharacterDetailView(character: character)
                        case .comics(let character):
                            self.makeComicsListView(for: character)
                        }
                    }
            }
            .tabItem {
                Label(AppTab.search.rawValue, systemImage: AppTab.search.icon)
            }
            .tag(AppTab.search)

            // Tab 3: Favorites
            NavigationStack(path: favoritesPathBinding) {
                makeFavoritesView()
                    .navigationDestination(for: CharacterDestination.self) { destination in
                        switch destination {
                        case .detail(let character):
                            self.makeCharacterDetailView(character: character)
                        case .comics(let character):
                            self.makeComicsListView(for: character)
                        }
                    }
            }
            .tabItem {
                Label(AppTab.favorites.rawValue, systemImage: AppTab.favorites.icon)
            }
            .tag(AppTab.favorites)

            // Tab 4: Settings
            NavigationStack(path: settingsPathBinding) {
                makeSettingsView()
            }
            .tabItem {
                Label(AppTab.settings.rawValue, systemImage: AppTab.settings.icon)
            }
            .tag(AppTab.settings)
        }
        .tint(.red)
    }

    // MARK: - Navigation Methods
    public func navigateToCharacter(_ character: Character, in tab: AppTab) {
        print("🧭 [Navigation] Navigating to character: \(character.name) in tab: \(tab)")
        print("🧭 [Navigation] Current favoritesPath count before: \(favoritesPath.count)")

        switch tab {
        case .characters:
            charactersPath.append(CharacterDestination.detail(character))
        case .search:
            searchPath.append(CharacterDestination.detail(character))
        case .favorites:
            favoritesPath.append(CharacterDestination.detail(character))
            print("🧭 [Navigation] favoritesPath count after: \(favoritesPath.count)")
        case .settings:
            break
        }
    }

    public func navigateToComics(for character: Character) {
        // Detecta qual tab está ativa e navega na path correta
        switch selectedTab {
        case .characters:
            charactersPath.append(CharacterDestination.comics(character))
        case .search:
            searchPath.append(CharacterDestination.comics(character))
        case .favorites:
            favoritesPath.append(CharacterDestination.comics(character))
        case .settings:
            break
        }
    }

    public func navigateBack() {
        switch selectedTab {
        case .characters:
            if !charactersPath.isEmpty {
                charactersPath.removeLast()
            }
        case .search:
            if !searchPath.isEmpty {
                searchPath.removeLast()
            }
        case .favorites:
            if !favoritesPath.isEmpty {
                favoritesPath.removeLast()
            }
        case .settings:
            if !settingsPath.isEmpty {
                settingsPath.removeLast()
            }
        }
    }

    public func navigateToRoot(in tab: AppTab? = nil) {
        let targetTab = tab ?? selectedTab
        switch targetTab {
        case .characters:
            charactersPath.removeLast(charactersPath.count)
        case .search:
            searchPath.removeLast(searchPath.count)
        case .favorites:
            favoritesPath.removeLast(favoritesPath.count)
        case .settings:
            settingsPath.removeLast(settingsPath.count)
        }
    }

    // MARK: - Factory Methods
    public func makeCharacterListView() -> some View {
        let fetchUseCase = FetchCharactersUseCase(service: comicVineService)
        let viewModel = CharacterListViewModel(
            fetchCharactersUseCase: fetchUseCase,
            comicVineService: comicVineService
        )

        // ✅ Adiciona callback para navegação ao clicar em um personagem
        return CharacterListView(
            viewModel: viewModel,
            onCharacterSelected: { character in
                self.navigateToCharacter(character, in: .characters)
            }
        )
    }

    public func makeSearchView() -> some View {
        if searchViewModel == nil {
            searchViewModel = SearchViewModel(comicVineService: comicVineService)
        }

        // ✅ Adiciona callbacks para navegação
        return SearchView(
            viewModel: searchViewModel!,
            onCharacterSelected: { character in
                self.navigateToCharacter(character, in: .search)
            },
            onComicSelected: { comic in
                // TODO: Implementar navegação para detalhes do quadrinho quando a tela existir
                print("Comic selecionado: \(comic.title)")
            }
        )
    }

    public func makeCharacterDetailView(character: Character) -> some View {
        let fetchCharacterDetailUseCase = FetchCharacterDetailUseCase(service: comicVineService)
        let fetchCharacterComicsUseCase = FetchCharacterComicsUseCase(service: comicVineService)
        let viewModel = CharacterDetailViewModel(
            character: character,
            fetchCharacterDetailUseCase: fetchCharacterDetailUseCase,
            fetchCharacterComicsUseCase: fetchCharacterComicsUseCase,
            favoritesService: favoritesService,
            persistenceManager: persistenceManager
        )

        // ✅ Adiciona callback para navegação aos quadrinhos
        return CharacterDetailView(
            viewModel: viewModel,
            onComicsSelected: {
                self.navigateToComics(for: character)
            }
        )
    }

    public func makeFavoritesView() -> some View {
        if favoritesViewModel == nil {
            favoritesViewModel = FavoritesViewModel(
                favoritesService: favoritesService
            )
        }

        // ✅ Adiciona callback para navegação ao clicar em um favorito
        return FavoritesView(
            viewModel: favoritesViewModel!,
            onCharacterSelected: { character in
                self.navigateToCharacter(character, in: .favorites)
            }
        )
    }

    public func makeSettingsView() -> some View {
        if settingsViewModel == nil {
            settingsViewModel = SettingsViewModel()
        }

        return SettingsView(viewModel: settingsViewModel!)
    }

    // ✅ MÉTODO ATUALIZADO - Abordagem Híbrida
    public func makeComicsListView(for character: Character) -> some View {
        // Cria AMBOS os UseCases
        let fetchIssuesByIdsUseCase = FetchIssuesByIdsUseCase(service: comicVineService)
        let fetchCharacterComicsUseCase = FetchCharacterComicsUseCase(service: comicVineService)

        // Cria o ViewModel com ambos os UseCases e o service
        // O ViewModel decidirá qual usar baseado na disponibilidade de issueCredits
        let viewModel = ComicsListViewModel(
            character: character,
            fetchIssuesByIdsUseCase: fetchIssuesByIdsUseCase,
            fetchCharacterComicsUseCase: fetchCharacterComicsUseCase,
            comicVineService: comicVineService
        )

        return ComicsListView(viewModel: viewModel)
    }
}

// MARK: - App Tabs
public enum AppTab: String, CaseIterable {
    case characters = "Characters"
    case search = "Search"
    case favorites = "Favorites"
    case settings = "Settings"

    public var icon: String {
        switch self {
        case .characters: return "person.3.fill"
        case .search: return "magnifyingglass"
        case .favorites: return "star.fill"
        case .settings: return "gearshape.fill"
        }
    }
}
