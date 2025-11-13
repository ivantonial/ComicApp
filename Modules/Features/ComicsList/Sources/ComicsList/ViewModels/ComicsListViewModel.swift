//
//  ComicsListViewModel.swift
//  ComicsList
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import ComicVineAPI
import Core
import Foundation
import Networking
import SwiftUI

@MainActor
public final class ComicsListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published public var comics: [Comic] = []
    @Published public var isLoading = false
    @Published public var error: Error?
    @Published public var selectedFilter: ComicFilter = .all
    @Published public var hasMorePages = true
    @Published public var selectedComic: Comic?
    @Published public var loadingProgress: Double = 0.0
    @Published public var loadingMessage: String = ""

    // MARK: - Public Properties
    public let character: Character

    // MARK: - Private Properties
    private let fetchIssuesByIdsUseCase: FetchIssuesByIdsUseCase?
    private let fetchCharacterComicsUseCase: FetchCharacterComicsUseCase?
    private let comicVineService: ComicVineServiceProtocol?
    private var currentOffset = 0
    private let pageSize = 20
    private var allComics: [Comic] = []
    private var issueIdsToLoad: [Int] = []
    private var hasLoadedInitialData = false
    private var useIssueCreditsApproach = false

    // MARK: - Computed Properties
    public var filteredComics: [Comic] {
        switch selectedFilter {
        case .all:
            return comics
        case .recent:
            // Ordenar por data de lançamento (mais recentes primeiro)
            return comics.sorted { first, second in
                if let date1 = first.coverDate, let date2 = second.coverDate {
                    return date1 > date2
                }
                return first.id > second.id
            }
        case .popular:
            // Por enquanto, retorna os primeiros 10 (pode ser melhorado com dados de popularidade)
            return Array(comics.prefix(10))
        case .classic:
            // Filtrar quadrinhos mais antigos
            return comics.sorted { first, second in
                if let date1 = first.coverDate, let date2 = second.coverDate {
                    return date1 < date2
                }
                return first.id < second.id
            }.prefix(10).map { $0 }
        }
    }

    public var totalComics: Int {
        // Usar o count real de issueCredits se disponível, senão usar countOfIssueAppearances
        if !issueIdsToLoad.isEmpty {
            return issueIdsToLoad.count
        }
        return character.countOfIssueAppearances
    }

    public var hasFilters: Bool {
        comics.count > 5
    }

    // MARK: - Initialization

    // Inicializador principal com ambos os UseCases
    public init(
        character: Character,
        fetchIssuesByIdsUseCase: FetchIssuesByIdsUseCase? = nil,
        fetchCharacterComicsUseCase: FetchCharacterComicsUseCase? = nil,
        comicVineService: ComicVineServiceProtocol? = nil
    ) {
        self.character = character
        self.fetchIssuesByIdsUseCase = fetchIssuesByIdsUseCase
        self.fetchCharacterComicsUseCase = fetchCharacterComicsUseCase
        self.comicVineService = comicVineService

        // Determinar qual abordagem usar
        if let issueCredits = character.issueCredits, !issueCredits.isEmpty {
            // Tem issueCredits - usar nova abordagem
            self.issueIdsToLoad = issueCredits.map { $0.id }
            self.useIssueCreditsApproach = true
            print("✅ ComicsListViewModel: Usando abordagem issueCredits com \(issueIdsToLoad.count) IDs para \(character.name)")
        } else {
            // Não tem issueCredits - precisa buscar do personagem ou usar fallback
            self.useIssueCreditsApproach = false
            print("⚠️ ComicsListViewModel: Usando abordagem fallback para \(character.name)")
        }
    }

    // Inicializador de compatibilidade - mantém assinatura antiga
    public init(
        character: Character,
        fetchCharacterComicsUseCase: FetchCharacterComicsUseCase
    ) {
        self.character = character
        self.fetchCharacterComicsUseCase = fetchCharacterComicsUseCase
        self.fetchIssuesByIdsUseCase = nil
        self.comicVineService = nil
        self.useIssueCreditsApproach = false

        print("⚠️ ComicsListViewModel: Inicializado com UseCase antigo para \(character.name)")
    }

    // Inicializador preferido - nova abordagem
    public init(
        character: Character,
        fetchIssuesByIdsUseCase: FetchIssuesByIdsUseCase
    ) {
        self.character = character
        self.fetchIssuesByIdsUseCase = fetchIssuesByIdsUseCase
        self.fetchCharacterComicsUseCase = nil
        self.comicVineService = nil

        // Extrair IDs das issues do character.issueCredits
        if let issueCredits = character.issueCredits {
            self.issueIdsToLoad = issueCredits.map { $0.id }
            self.useIssueCreditsApproach = true
            print("🔍 ComicsListViewModel: Encontrados \(issueIdsToLoad.count) IDs de issues para \(character.name)")
        } else {
            self.useIssueCreditsApproach = false
            print("⚠️ ComicsListViewModel: Nenhum issueCredits encontrado para \(character.name)")
        }
    }

    // MARK: - Public Methods
    public func loadInitialData() {
        guard !hasLoadedInitialData else { return }
        hasLoadedInitialData = true

        Task {
            await loadComics(isInitial: true)
        }
    }

    public func loadMoreIfNeeded(currentComic: Comic) {
        guard let lastComic = comics.last,
              lastComic.id == currentComic.id,
              !isLoading,
              hasMorePages else { return }

        Task {
            await loadComics(isInitial: false)
        }
    }

    public func refresh() {
        Task {
            currentOffset = 0
            hasMorePages = true
            hasLoadedInitialData = false

            // Se não tinha issueCredits e temos o service, tentar buscar o personagem completo
            if !useIssueCreditsApproach && comicVineService != nil {
                await tryLoadIssueCredits()
            }

            await loadComics(isInitial: true)
        }
    }

    public func selectFilter(_ filter: ComicFilter) {
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedFilter = filter
        }
    }

    public func selectComic(_ comic: Comic) {
        selectedComic = comic
        // Aqui você pode navegar para uma tela de detalhes do quadrinho
        // ou mostrar um modal/sheet
        showComicDetail(comic)
    }

    // MARK: - Private Methods

    private func tryLoadIssueCredits() async {
        guard let service = comicVineService else { return }

        do {
            print("🔄 Tentando buscar personagem completo para obter issueCredits...")
            let fullCharacter = try await service.fetchCharacter(by: character.id)

            if let issueCredits = fullCharacter.issueCredits, !issueCredits.isEmpty {
                self.issueIdsToLoad = issueCredits.map { $0.id }
                self.useIssueCreditsApproach = true
                print("✅ IssueCredits carregados: \(issueIdsToLoad.count) IDs")
            }
        } catch {
            print("❌ Erro ao buscar personagem completo: \(error)")
        }
    }

    private func loadComics(isInitial: Bool) async {
        // Decidir qual método usar baseado na disponibilidade de dados
        if useIssueCreditsApproach && !issueIdsToLoad.isEmpty {
            await loadComicsFromIssueIds(isInitial: isInitial)
        } else if let fetchCharacterComicsUseCase = fetchCharacterComicsUseCase {
            await loadComicsWithFallback(isInitial: isInitial)
        } else {
            print("❌ ComicsListViewModel: Nenhum método disponível para carregar comics")
            self.error = NetworkError.serverErrorMessage(
                "Unable to load comics for this character."
            )
        }
    }

    // Método usando issueCredits e IDs
    private func loadComicsFromIssueIds(isInitial: Bool) async {
        guard let fetchIssuesByIdsUseCase = fetchIssuesByIdsUseCase else {
            print("❌ FetchIssuesByIdsUseCase não disponível")
            self.error = NetworkError.serverErrorMessage(
                "Unable to load comics."
            )
            return
        }

        isLoading = true
        error = nil

        defer {
            isLoading = false
            loadingProgress = 0.0
            loadingMessage = ""
        }

        do {
            if isInitial {
                // Limpar dados anteriores
                comics = []
                allComics = []
                currentOffset = 0
            }

            // Calcular quais IDs carregar com base no offset
            let startIndex = currentOffset
            let endIndex = min(startIndex + pageSize, issueIdsToLoad.count)

            guard startIndex < issueIdsToLoad.count else {
                hasMorePages = false
                return
            }

            let idsToLoad = Array(issueIdsToLoad[startIndex..<endIndex])

            print("📚 Carregando issues \(startIndex) a \(endIndex) de \(issueIdsToLoad.count) total")

            // Atualizar mensagem de carregamento
            loadingMessage = "Loading comics \(startIndex + 1)-\(endIndex) of \(issueIdsToLoad.count)"

            // Buscar as comics pelos IDs
            let result = try await fetchIssuesByIdsUseCase.execute(
                issueIds: idsToLoad,
                batchSize: 3 // Processar em lotes menores para melhor performance
            )

            if isInitial {
                comics = result
                allComics = result
            } else {
                comics.append(contentsOf: result)
                allComics.append(contentsOf: result)
            }

            currentOffset = endIndex
            hasMorePages = endIndex < issueIdsToLoad.count

            print("✅ Carregadas \(result.count) comics. Total atual: \(comics.count)")

        } catch {
            self.error = error
            print("❌ Erro ao carregar quadrinhos por IDs: \(error)")
        }
    }

    // Método fallback usando FetchCharacterComicsUseCase
    private func loadComicsWithFallback(isInitial: Bool) async {
        guard let fetchCharacterComicsUseCase = fetchCharacterComicsUseCase else {
            return
        }

        isLoading = true
        error = nil

        defer { isLoading = false }

        do {
            print("🔄 Usando método fallback para carregar comics...")

            let result = try await fetchCharacterComicsUseCase.execute(
                characterId: character.id,
                offset: currentOffset,
                limit: pageSize
            )

            if isInitial {
                comics = result
                allComics = result
            } else {
                comics.append(contentsOf: result)
                allComics.append(contentsOf: result)
            }

            currentOffset += pageSize
            hasMorePages = result.count == pageSize

            print("✅ Fallback: Carregadas \(result.count) comics")

        } catch {
            self.error = error
            print("❌ Erro no método fallback: \(error)")
        }
    }

    private func showComicDetail(_ comic: Comic) {
        // Implementar navegação ou apresentação de detalhes
        // Por exemplo, usando um sheet ou navegação
        print("Comic selecionado: \(comic.title)")
    }
}
