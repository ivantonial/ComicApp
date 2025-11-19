//
//  PersistenceManager.swift
//  Cache
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

//import ComicVineAPI
//import Core
//import CoreData
//import Foundation
//
//// MARK: - Protocolo
//public protocol PersistenceManagerProtocol: Sendable {
//    func saveCharacters(_ characters: [Character]) async throws
//    func loadCharacters(offset: Int, limit: Int) async -> [Character]
//    func saveCharacter(_ character: Character) async throws
//    func loadCharacter(withId id: Int) async -> Character?
//
//    func saveComics(_ comics: [Comic], forCharacterId characterId: Int) async throws
//    func loadComics(forCharacterId characterId: Int) async -> [Comic]
//
//    func saveFavorite(_ character: Character) async throws
//    func removeFavorite(characterId: Int) async throws
//    func loadFavorites() async -> [Character]
//    func isFavorite(characterId: Int) async -> Bool
//
//    func saveSearchHistory(_ query: String, resultCount: Int) async
//    func loadSearchHistory() async -> [String]
//    func clearSearchHistory() async
//
//    func clearAllCache() async throws
//    func getCacheAge() async -> TimeInterval?
//}
//
//// MARK: - Implementação
//public final class PersistenceManager: PersistenceManagerProtocol, @unchecked Sendable {
//    // MARK: - Propriedades
//    private let coreDataStack: CoreDataStack
//    private let cacheExpirationInterval: TimeInterval = 3600 // 1 hora
//
//    // MARK: - Inicialização
//    public init(coreDataStack: CoreDataStack = .shared) {
//        self.coreDataStack = coreDataStack
//    }
//
//    // MARK: - Characters
//    public func saveCharacters(_ characters: [Character]) async throws {
//        let context = coreDataStack.newBackgroundContext()
//        try await context.perform {
//            let fetch: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
//            let old = try context.fetch(fetch)
//            old.forEach { context.delete($0) }
//
//            for character in characters {
//                let cd = CDCharacter(context: context)
//                cd.update(from: character)
//            }
//
//            try context.save()
//        }
//    }
//
//    public func loadCharacters(offset: Int = 0, limit: Int = 20) async -> [Character] {
//        let context = coreDataStack.mainContext
//        return await context.perform {
//            let fetch: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
//            fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//            fetch.fetchOffset = offset
//            fetch.fetchLimit = limit
//            fetch.predicate = NSPredicate(format: "cachedAt > %@",
//                                          Date().addingTimeInterval(-self.cacheExpirationInterval) as CVarArg)
//
//            do {
//                let cdCharacters = try context.fetch(fetch)
//                return cdCharacters.compactMap { $0.toCharacter() }
//            } catch {
//                print("⚠️ Erro ao carregar personagens: \(error)")
//                return []
//            }
//        }
//    }
//
//    public func saveCharacter(_ character: Character) async throws {
//        let context = coreDataStack.newBackgroundContext()
//        try await context.perform {
//            let fetch: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
//            fetch.predicate = NSPredicate(format: "id == %d", character.id)
//
//            let cd: CDCharacter
//            if let existing = try context.fetch(fetch).first {
//                cd = existing
//            } else {
//                cd = CDCharacter(context: context)
//            }
//            cd.update(from: character)
//            try context.save()
//        }
//    }
//
//    public func loadCharacter(withId id: Int) async -> Character? {
//        let context = coreDataStack.mainContext
//        return await context.perform {
//            let fetch: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
//            fetch.predicate = NSPredicate(format: "id == %d", id)
//            fetch.fetchLimit = 1
//            do {
//                return try context.fetch(fetch).first?.toCharacter()
//            } catch {
//                print("⚠️ Erro ao carregar personagem: \(error)")
//                return nil
//            }
//        }
//    }
//
//    // MARK: - Comics
//    public func saveComics(_ comics: [Comic], forCharacterId characterId: Int) async throws {
//        let context = coreDataStack.newBackgroundContext()
//        try await context.perform {
//            let fetch: NSFetchRequest<CDComic> = CDComic.fetchRequest()
//            fetch.predicate = NSPredicate(format: "characterId == %d", characterId)
//            let oldComics = try context.fetch(fetch)
//            oldComics.forEach { context.delete($0) }
//
//            for comic in comics {
//                let cd = CDComic(context: context)
//                cd.update(from: comic, characterId: characterId)
//            }
//
//            try context.save()
//        }
//    }
//
//    public func loadComics(forCharacterId characterId: Int) async -> [Comic] {
//        let context = coreDataStack.mainContext
//        return await context.perform {
//            let fetch: NSFetchRequest<CDComic> = CDComic.fetchRequest()
//            fetch.predicate = NSPredicate(format: "characterId == %d", characterId)
//            fetch.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//            do {
//                let cdComics = try context.fetch(fetch)
//                return cdComics.compactMap { $0.toComic() }
//            } catch {
//                print("⚠️ Erro ao carregar quadrinhos: \(error)")
//                return []
//            }
//        }
//    }
//
//    // MARK: - Favoritos
//    public func saveFavorite(_ character: Character) async throws {
//        let context = coreDataStack.newBackgroundContext()
//        try await context.perform {
//            let fetch: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
//            fetch.predicate = NSPredicate(format: "id == %d", character.id)
//
//            let cd: CDCharacter
//            if let existing = try context.fetch(fetch).first {
//                cd = existing
//            } else {
//                cd = CDCharacter(context: context)
//                cd.update(from: character)
//            }
//            cd.isFavorite = true
//            try context.save()
//        }
//    }
//
//    public func removeFavorite(characterId: Int) async throws {
//        let context = coreDataStack.newBackgroundContext()
//        try await context.perform {
//            let fetch: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
//            fetch.predicate = NSPredicate(format: "id == %d", characterId)
//            if let cd = try context.fetch(fetch).first {
//                cd.isFavorite = false
//                try context.save()
//            }
//        }
//    }
//
//    public func loadFavorites() async -> [Character] {
//        let context = coreDataStack.mainContext
//        return await context.perform {
//            let fetch: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
//            fetch.predicate = NSPredicate(format: "isFavorite == YES")
//            fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//            do {
//                let cdCharacters = try context.fetch(fetch)
//                print("📀 [PersistenceManager] Encontrados \(cdCharacters.count) favoritos no Core Data")
//                for cd in cdCharacters {
//                    print("  💾 ID: \(cd.id) - Nome: \(cd.name ?? "sem nome") - isFavorite: \(cd.isFavorite)")
//                }
//
//                let characters = cdCharacters.compactMap { cd -> Character? in
//                    let character = cd.toCharacter()
//                    if character == nil {
//                        print("  ⚠️ Falha ao converter CDCharacter ID: \(cd.id) para Character")
//                    }
//                    return character
//                }
//
//                print("📀 [PersistenceManager] Convertidos \(characters.count) de \(cdCharacters.count) para Character")
//                return characters
//            } catch {
//                print("⚠️ Erro ao carregar favoritos: \(error)")
//                return []
//            }
//        }
//    }
//
//    public func isFavorite(characterId: Int) async -> Bool {
//        let context = coreDataStack.mainContext
//        return await context.perform {
//            let fetch: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
//            fetch.predicate = NSPredicate(format: "id == %d AND isFavorite == YES", characterId)
//            fetch.fetchLimit = 1
//            do {
//                return try context.count(for: fetch) > 0
//            } catch {
//                print("⚠️ Erro ao verificar favorito: \(error)")
//                return false
//            }
//        }
//    }
//
//    // MARK: - Histórico de busca
//    public func saveSearchHistory(_ query: String, resultCount: Int) async {
//        let context = coreDataStack.newBackgroundContext()
//        await context.perform {
//            let fetch: NSFetchRequest<CDSearchHistory> = CDSearchHistory.fetchRequest()
//            fetch.predicate = NSPredicate(format: "query == %@", query)
//
//            do {
//                if let existing = try context.fetch(fetch).first {
//                    existing.timestamp = Date()
//                    existing.resultCount = Int32(resultCount)
//                } else {
//                    let new = CDSearchHistory(context: context)
//                    new.query = query
//                    new.timestamp = Date()
//                    new.resultCount = Int32(resultCount)
//                }
//                try context.save()
//            } catch {
//                print("⚠️ Erro ao salvar histórico: \(error)")
//            }
//        }
//    }
//
//    public func loadSearchHistory() async -> [String] {
//        let context = coreDataStack.mainContext
//        return await context.perform {
//            let fetch: NSFetchRequest<CDSearchHistory> = CDSearchHistory.fetchRequest()
//            fetch.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
//            fetch.fetchLimit = 10
//            do {
//                return try context.fetch(fetch).map { $0.query }
//            } catch {
//                print("⚠️ Erro ao carregar histórico: \(error)")
//                return []
//            }
//        }
//    }
//
//    public func clearSearchHistory() async {
//        let context = coreDataStack.newBackgroundContext()
//        await context.perform {
//            let fetch: NSFetchRequest<NSFetchRequestResult> = CDSearchHistory.fetchRequest()
//            let delete = NSBatchDeleteRequest(fetchRequest: fetch)
//            do {
//                try context.execute(delete)
//                try context.save()
//            } catch {
//                print("⚠️ Erro ao limpar histórico: \(error)")
//            }
//        }
//    }
//
//    // MARK: - Cache Management
//    public func clearAllCache() async throws {
//        coreDataStack.clearAllData()
//    }
//
//    public func getCacheAge() async -> TimeInterval? {
//        let context = coreDataStack.mainContext
//        return await context.perform {
//            let fetch: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
//            fetch.sortDescriptors = [NSSortDescriptor(key: "cachedAt", ascending: true)]
//            fetch.fetchLimit = 1
//            do {
//                if let oldest = try context.fetch(fetch).first,
//                   let cached = oldest.cachedAt {
//                    return Date().timeIntervalSince(cached)
//                }
//            } catch {
//                print("⚠️ Erro ao obter idade do cache: \(error)")
//            }
//            return nil
//        }
//    }
//}
import ComicVineAPI
import Core
import CoreData
import Foundation

// MARK: - Protocolo
public protocol PersistenceManagerProtocol: Sendable {
    func saveCharacters(_ characters: [Character]) async throws
    func loadCharacters(offset: Int, limit: Int) async -> [Character]
    func saveCharacter(_ character: Character) async throws
    func loadCharacter(withId id: Int) async -> Character?

    func saveComics(_ comics: [Comic], forCharacterId characterId: Int) async throws
    func loadComics(forCharacterId characterId: Int) async -> [Comic]

    func saveFavorite(_ character: Character) async throws
    func removeFavorite(characterId: Int) async throws
    func loadFavorites() async -> [Character]
    func isFavorite(characterId: Int) async -> Bool

    func saveSearchHistory(_ query: String, resultCount: Int) async
    func loadSearchHistory() async -> [String]
    func clearSearchHistory() async

    func clearAllCache() async throws
    func getCacheAge() async -> TimeInterval?
}

// MARK: - Implementação
public final class PersistenceManager: PersistenceManagerProtocol, @unchecked Sendable {
    // MARK: - Propriedades
    private let coreDataStack: CoreDataStack
    private let cacheExpirationInterval: TimeInterval = 3600 // 1 hora

    // CORREÇÃO: Usar um único background context serial para evitar conflitos
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = coreDataStack.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        // Importante: configurar o context para merge automático
        context.automaticallyMergesChangesFromParent = true
        return context
    }()

    // MARK: - Inicialização
    public init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }

    // MARK: - Characters
    public func saveCharacters(_ characters: [Character]) async throws {
        // CORREÇÃO: Usar perform ao invés de criar novo context
        try await backgroundContext.perform { [weak self] in
            guard let self = self else { return }

            let fetch: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
            let old = try self.backgroundContext.fetch(fetch)
            old.forEach { self.backgroundContext.delete($0) }

            for character in characters {
                let cd = CDCharacter(context: self.backgroundContext)
                cd.update(from: character)
            }

            // IMPORTANTE: Verificar se há mudanças antes de salvar
            if self.backgroundContext.hasChanges {
                try self.backgroundContext.save()
            }
        }
    }

    public func loadCharacters(offset: Int = 0, limit: Int = 20) async -> [Character] {
        // Usar viewContext para leitura (thread-safe)
        let context = coreDataStack.mainContext
        return await context.perform {
            let fetch: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
            fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            fetch.fetchOffset = offset
            fetch.fetchLimit = limit
            fetch.predicate = NSPredicate(format: "cachedAt > %@",
                                          Date().addingTimeInterval(-self.cacheExpirationInterval) as CVarArg)

            do {
                let cdCharacters = try context.fetch(fetch)
                return cdCharacters.compactMap { $0.toCharacter() }
            } catch {
                print("⚠️ Erro ao carregar personagens: \(error)")
                return []
            }
        }
    }

    public func saveCharacter(_ character: Character) async throws {
        // CORREÇÃO: Usar backgroundContext único ao invés de criar novo
        try await backgroundContext.perform { [weak self] in
            guard let self = self else { return }

            let fetch: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
            fetch.predicate = NSPredicate(format: "id == %d", character.id)

            let cd: CDCharacter
            if let existing = try self.backgroundContext.fetch(fetch).first {
                cd = existing
            } else {
                cd = CDCharacter(context: self.backgroundContext)
            }
            cd.update(from: character)

            // IMPORTANTE: Verificar mudanças antes de salvar
            if self.backgroundContext.hasChanges {
                try self.backgroundContext.save()
            }
        }
    }

    public func loadCharacter(withId id: Int) async -> Character? {
        let context = coreDataStack.mainContext
        return await context.perform {
            let fetch: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
            fetch.predicate = NSPredicate(format: "id == %d", id)
            fetch.fetchLimit = 1

            do {
                return try context.fetch(fetch).first?.toCharacter()
            } catch {
                print("⚠️ Erro ao carregar personagem \(id): \(error)")
                return nil
            }
        }
    }

    // MARK: - Comics
    public func saveComics(_ comics: [Comic], forCharacterId characterId: Int) async throws {
        try await backgroundContext.perform { [weak self] in
            guard let self = self else { return }

            // Limpa comics antigos
            let fetchOld: NSFetchRequest<CDComic> = CDComic.fetchRequest()
            fetchOld.predicate = NSPredicate(format: "characterId == %d", characterId)
            let oldComics = try self.backgroundContext.fetch(fetchOld)
            oldComics.forEach { self.backgroundContext.delete($0) }

            // Salva novos comics
            for comic in comics {
                let cd = CDComic(context: self.backgroundContext)
                cd.update(from: comic, characterId: characterId)
            }

            if self.backgroundContext.hasChanges {
                try self.backgroundContext.save()
            }
        }
    }

    public func loadComics(forCharacterId characterId: Int) async -> [Comic] {
        let context = coreDataStack.mainContext
        return await context.perform {
            let fetch: NSFetchRequest<CDComic> = CDComic.fetchRequest()
            fetch.predicate = NSPredicate(format: "characterId == %d", characterId)
            fetch.sortDescriptors = [NSSortDescriptor(key: "coverDate", ascending: false)]

            do {
                let cdComics = try context.fetch(fetch)
                return cdComics.compactMap { $0.toComic() }
            } catch {
                print("⚠️ Erro ao carregar comics: \(error)")
                return []
            }
        }
    }

    // MARK: - Favorites
    public func saveFavorite(_ character: Character) async throws {
        try await backgroundContext.perform { [weak self] in
            guard let self = self else { return }

            let fetch: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
            fetch.predicate = NSPredicate(format: "id == %d", character.id)

            let cd: CDCharacter
            if let existing = try self.backgroundContext.fetch(fetch).first {
                cd = existing
            } else {
                cd = CDCharacter(context: self.backgroundContext)
            }

            cd.update(from: character)
            cd.isFavorite = true
            cd.favoritedAt = Date()

            if self.backgroundContext.hasChanges {
                try self.backgroundContext.save()
            }
        }
    }

    public func removeFavorite(characterId: Int) async throws {
        try await backgroundContext.perform { [weak self] in
            guard let self = self else { return }

            let fetch: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
            fetch.predicate = NSPredicate(format: "id == %d", characterId)

            if let cd = try self.backgroundContext.fetch(fetch).first {
                cd.isFavorite = false
                cd.favoritedAt = nil

                if self.backgroundContext.hasChanges {
                    try self.backgroundContext.save()
                }
            }
        }
    }

    public func loadFavorites() async -> [Character] {
        let context = coreDataStack.mainContext
        return await context.perform {
            let fetch: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
            fetch.predicate = NSPredicate(format: "isFavorite == true")
            fetch.sortDescriptors = [NSSortDescriptor(key: "favoritedAt", ascending: false)]

            do {
                let favorites = try context.fetch(fetch)
                return favorites.compactMap { $0.toCharacter() }
            } catch {
                print("⚠️ Erro ao carregar favoritos: \(error)")
                return []
            }
        }
    }

    public func isFavorite(characterId: Int) async -> Bool {
        let context = coreDataStack.mainContext
        return await context.perform {
            let fetch: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
            fetch.predicate = NSPredicate(format: "id == %d AND isFavorite == true", characterId)
            fetch.fetchLimit = 1

            do {
                return try context.count(for: fetch) > 0
            } catch {
                print("⚠️ Erro ao verificar favorito: \(error)")
                return false
            }
        }
    }

    // MARK: - Search History
    public func saveSearchHistory(_ query: String, resultCount: Int) async {
        await backgroundContext.perform { [weak self] in
            guard let self = self else { return }

            do {
                // Remove duplicatas antigas
                let fetch: NSFetchRequest<CDSearchHistory> = CDSearchHistory.fetchRequest()
                fetch.predicate = NSPredicate(format: "query == %@", query)
                let old = try self.backgroundContext.fetch(fetch)
                old.forEach { self.backgroundContext.delete($0) }

                // Adiciona nova entrada
                let history = CDSearchHistory(context: self.backgroundContext)
                history.query = query
                history.searchedAt = Date()
                history.resultCount = Int32(resultCount)

                if self.backgroundContext.hasChanges {
                    try self.backgroundContext.save()
                }
            } catch {
                print("⚠️ Erro ao salvar histórico de busca: \(error)")
            }
        }
    }

    public func loadSearchHistory() async -> [String] {
        let context = coreDataStack.mainContext
        return await context.perform {
            let fetch: NSFetchRequest<CDSearchHistory> = CDSearchHistory.fetchRequest()
            fetch.sortDescriptors = [NSSortDescriptor(key: "searchedAt", ascending: false)]
            fetch.fetchLimit = 20

            do {
                let history = try context.fetch(fetch)
                return history.compactMap { $0.query }
            } catch {
                print("⚠️ Erro ao carregar histórico: \(error)")
                return []
            }
        }
    }

    public func clearSearchHistory() async {
        await backgroundContext.perform { [weak self] in
            guard let self = self else { return }

            do {
                let fetch: NSFetchRequest<CDSearchHistory> = CDSearchHistory.fetchRequest()
                let history = try self.backgroundContext.fetch(fetch)
                history.forEach { self.backgroundContext.delete($0) }

                if self.backgroundContext.hasChanges {
                    try self.backgroundContext.save()
                }
            } catch {
                print("⚠️ Erro ao limpar histórico: \(error)")
            }
        }
    }

    // MARK: - Cache Management
    public func clearAllCache() async throws {
        try await backgroundContext.perform { [weak self] in
            guard let self = self else { return }

            // Limpa todos os personagens
            let fetchCharacters: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
            let characters = try self.backgroundContext.fetch(fetchCharacters)
            characters.forEach { self.backgroundContext.delete($0) }

            // Limpa todos os comics
            let fetchComics: NSFetchRequest<CDComic> = CDComic.fetchRequest()
            let comics = try self.backgroundContext.fetch(fetchComics)
            comics.forEach { self.backgroundContext.delete($0) }

            // Limpa histórico
            let fetchHistory: NSFetchRequest<CDSearchHistory> = CDSearchHistory.fetchRequest()
            let history = try self.backgroundContext.fetch(fetchHistory)
            history.forEach { self.backgroundContext.delete($0) }

            if self.backgroundContext.hasChanges {
                try self.backgroundContext.save()
            }
        }
    }

    public func getCacheAge() async -> TimeInterval? {
        let context = coreDataStack.mainContext
        return await context.perform {
            let fetch: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
            fetch.sortDescriptors = [NSSortDescriptor(key: "cachedAt", ascending: true)]
            fetch.fetchLimit = 1

            do {
                if let oldest = try context.fetch(fetch).first,
                   let cachedAt = oldest.cachedAt {
                    return Date().timeIntervalSince(cachedAt)
                }
            } catch {
                print("⚠️ Erro ao verificar idade do cache: \(error)")
            }

            return nil
        }
    }
}
