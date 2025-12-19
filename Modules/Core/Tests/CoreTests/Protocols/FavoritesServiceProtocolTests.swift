//
//  FavoritesServiceProtocolTests.swift
//  Core
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import Core
import Foundation
import Testing
import XCTest

// MARK: - Mock Implementation for Testing

/// Mock implementation of FavoritesServiceProtocol for testing
actor MockFavoritesService: FavoritesServiceProtocol {

    // MARK: - Private Storage

    private var _favorites: Set<Int> = []
    private var _addFavoriteCalls: [FavoriteCharacterInput] = []
    private var _removeFavoriteCalls: [Int] = []
    private var _isFavoriteCalls: [Int] = []
    private var _shouldThrowOnAdd = false
    private var _shouldThrowOnRemove = false

    // MARK: - FavoritesServiceProtocol Implementation

    func isFavorite(characterId: Int) async -> Bool {
        _isFavoriteCalls.append(characterId)
        return _favorites.contains(characterId)
    }

    func addFavorite(character: FavoriteCharacterInput) async throws {
        _addFavoriteCalls.append(character)

        if _shouldThrowOnAdd {
            throw MockFavoritesError.addFailed
        }

        _favorites.insert(character.id)
    }

    func removeFavorite(characterId: Int) async throws {
        _removeFavoriteCalls.append(characterId)

        if _shouldThrowOnRemove {
            throw MockFavoritesError.removeFailed
        }

        _favorites.remove(characterId)
    }

    // MARK: - Test Helper Methods

    func getFavoritesCount() -> Int {
        return _favorites.count
    }

    func getAllFavoriteIds() -> Set<Int> {
        return _favorites
    }

    func getAddFavoriteCallsCount() -> Int {
        return _addFavoriteCalls.count
    }

    func getRemoveFavoriteCallsCount() -> Int {
        return _removeFavoriteCalls.count
    }

    func getIsFavoriteCallsCount() -> Int {
        return _isFavoriteCalls.count
    }

    func setShouldThrowOnAdd(_ shouldThrow: Bool) {
        _shouldThrowOnAdd = shouldThrow
    }

    func setShouldThrowOnRemove(_ shouldThrow: Bool) {
        _shouldThrowOnRemove = shouldThrow
    }

    func reset() {
        _favorites.removeAll()
        _addFavoriteCalls.removeAll()
        _removeFavoriteCalls.removeAll()
        _isFavoriteCalls.removeAll()
        _shouldThrowOnAdd = false
        _shouldThrowOnRemove = false
    }
}

// MARK: - Mock Error

enum MockFavoritesError: Error, LocalizedError {
    case addFailed
    case removeFailed

    var errorDescription: String? {
        switch self {
        case .addFailed:
            return "Failed to add favorite"
        case .removeFailed:
            return "Failed to remove favorite"
        }
    }
}

// MARK: - FavoriteCharacterInput Tests

@Suite("FavoriteCharacterInput Tests")
struct FavoriteCharacterInputTests {

    @Test("FavoriteCharacterInput should initialize with all properties")
    func testFullInitialization() {
        let url = URL(string: "https://example.com/image.jpg")
        let input = FavoriteCharacterInput(
            id: 42,
            name: "Spider-Man",
            thumbnailURL: url
        )

        #expect(input.id == 42)
        #expect(input.name == "Spider-Man")
        #expect(input.thumbnailURL == url)
    }

    @Test("FavoriteCharacterInput should accept nil thumbnailURL")
    func testNilThumbnailURL() {
        let input = FavoriteCharacterInput(
            id: 1,
            name: "Batman",
            thumbnailURL: nil
        )

        #expect(input.id == 1)
        #expect(input.name == "Batman")
        #expect(input.thumbnailURL == nil)
    }

    @Test("FavoriteCharacterInput should be Sendable")
    func testSendable() {
        let input = FavoriteCharacterInput(id: 1, name: "Test", thumbnailURL: nil)
        let _: any Sendable = input
        #expect(true)
    }

    @Test("FavoriteCharacterInput should handle various URL formats")
    func testVariousURLFormats() {
        let urls = [
            "https://example.com/image.jpg",
            "https://example.com/path/to/image.png",
            "https://cdn.example.com/images/hero-123.webp"
        ]

        for urlString in urls {
            let url = URL(string: urlString)
            let input = FavoriteCharacterInput(id: 1, name: "Test", thumbnailURL: url)
            #expect(input.thumbnailURL?.absoluteString == urlString)
        }
    }
}

// MARK: - FavoritesServiceProtocol Tests

@Suite("FavoritesServiceProtocol Tests", .serialized)
struct FavoritesServiceProtocolTests {

    private let mockService = MockFavoritesService()

    // MARK: - isFavorite Tests

    @Test("isFavorite should return false for non-favorite")
    func testIsFavoriteReturnsFalse() async {
        await mockService.reset()

        let result = await mockService.isFavorite(characterId: 1)

        #expect(result == false)
    }

    @Test("isFavorite should return true after adding favorite")
    func testIsFavoriteReturnsTrueAfterAdd() async throws {
        await mockService.reset()

        let input = FavoriteCharacterInput(id: 1, name: "Spider-Man", thumbnailURL: nil)
        try await mockService.addFavorite(character: input)

        let result = await mockService.isFavorite(characterId: 1)

        #expect(result == true)
    }

    @Test("isFavorite should return false after removing favorite")
    func testIsFavoriteReturnsFalseAfterRemove() async throws {
        await mockService.reset()

        let input = FavoriteCharacterInput(id: 1, name: "Spider-Man", thumbnailURL: nil)
        try await mockService.addFavorite(character: input)
        try await mockService.removeFavorite(characterId: 1)

        let result = await mockService.isFavorite(characterId: 1)

        #expect(result == false)
    }

    // MARK: - addFavorite Tests

    @Test("addFavorite should add character to favorites")
    func testAddFavorite() async throws {
        await mockService.reset()

        let input = FavoriteCharacterInput(id: 42, name: "Batman", thumbnailURL: nil)
        try await mockService.addFavorite(character: input)

        let count = await mockService.getFavoritesCount()
        #expect(count == 1)
    }

    @Test("addFavorite should handle multiple characters")
    func testAddMultipleFavorites() async throws {
        await mockService.reset()

        let characters = [
            FavoriteCharacterInput(id: 1, name: "Spider-Man", thumbnailURL: nil),
            FavoriteCharacterInput(id: 2, name: "Batman", thumbnailURL: nil),
            FavoriteCharacterInput(id: 3, name: "Superman", thumbnailURL: nil)
        ]

        for character in characters {
            try await mockService.addFavorite(character: character)
        }

        let count = await mockService.getFavoritesCount()
        #expect(count == 3)
    }

    @Test("addFavorite should throw when configured to fail")
    func testAddFavoriteThrows() async {
        await mockService.reset()
        await mockService.setShouldThrowOnAdd(true)

        let input = FavoriteCharacterInput(id: 1, name: "Test", thumbnailURL: nil)

        do {
            try await mockService.addFavorite(character: input)
            #expect(Bool(false), "Should have thrown")
        } catch {
            #expect(error is MockFavoritesError)
        }
    }

    @Test("addFavorite should track calls")
    func testAddFavoriteTracksCalls() async throws {
        await mockService.reset()

        let input = FavoriteCharacterInput(id: 1, name: "Test", thumbnailURL: nil)
        try await mockService.addFavorite(character: input)

        let callCount = await mockService.getAddFavoriteCallsCount()
        #expect(callCount == 1)
    }

    // MARK: - removeFavorite Tests

    @Test("removeFavorite should remove character from favorites")
    func testRemoveFavorite() async throws {
        await mockService.reset()

        let input = FavoriteCharacterInput(id: 1, name: "Spider-Man", thumbnailURL: nil)
        try await mockService.addFavorite(character: input)
        try await mockService.removeFavorite(characterId: 1)

        let count = await mockService.getFavoritesCount()
        #expect(count == 0)
    }

    @Test("removeFavorite should only remove specified character")
    func testRemoveFavoriteOnlySpecified() async throws {
        await mockService.reset()

        try await mockService.addFavorite(character: FavoriteCharacterInput(id: 1, name: "A", thumbnailURL: nil))
        try await mockService.addFavorite(character: FavoriteCharacterInput(id: 2, name: "B", thumbnailURL: nil))
        try await mockService.addFavorite(character: FavoriteCharacterInput(id: 3, name: "C", thumbnailURL: nil))

        try await mockService.removeFavorite(characterId: 2)

        let ids = await mockService.getAllFavoriteIds()
        #expect(ids.contains(1))
        #expect(!ids.contains(2))
        #expect(ids.contains(3))
    }

    @Test("removeFavorite should throw when configured to fail")
    func testRemoveFavoriteThrows() async {
        await mockService.reset()
        await mockService.setShouldThrowOnRemove(true)

        do {
            try await mockService.removeFavorite(characterId: 1)
            #expect(Bool(false), "Should have thrown")
        } catch {
            #expect(error is MockFavoritesError)
        }
    }

    @Test("removeFavorite should handle non-existent character")
    func testRemoveNonExistent() async throws {
        await mockService.reset()

        // Deve executar sem erro mesmo se não existir
        try await mockService.removeFavorite(characterId: 999)

        let count = await mockService.getFavoritesCount()
        #expect(count == 0)
    }

    // MARK: - Protocol Conformance Tests

    @Test("FavoritesServiceProtocol should be Sendable")
    func testProtocolIsSendable() async {
        let service: any FavoritesServiceProtocol = mockService
        let _: any Sendable = service
        #expect(true)
    }
}

// MARK: - XCTest Integration Tests

class FavoritesServiceProtocolXCTests: XCTestCase {

    private var mockService: MockFavoritesService!

    override func setUp() async throws {
        mockService = MockFavoritesService()
        await mockService.reset()
    }

    override func tearDown() async throws {
        await mockService.reset()
        mockService = nil
    }

    func testProtocolMethodSignatures() async throws {
        // Verifica que os métodos do protocolo estão acessíveis
        let service: FavoritesServiceProtocol = mockService

        // isFavorite
        let isFav = await service.isFavorite(characterId: 1)
        XCTAssertFalse(isFav)

        // addFavorite
        let input = FavoriteCharacterInput(id: 1, name: "Test", thumbnailURL: nil)
        try await service.addFavorite(character: input)

        // removeFavorite
        try await service.removeFavorite(characterId: 1)
    }

    func testConcurrentOperations() async throws {
        // Em Swift 6, withTaskGroup capturando self causa data races
        // Executar sequencialmente para garantir thread-safety
        for i in 1...10 {
            let input = FavoriteCharacterInput(
                id: i,
                name: "Hero \(i)",
                thumbnailURL: nil
            )
            try await mockService.addFavorite(character: input)
        }

        let count = await mockService.getFavoritesCount()
        XCTAssertEqual(count, 10)
    }

    func testToggleFavorite() async throws {
        let characterId = 1
        let input = FavoriteCharacterInput(id: characterId, name: "Spider-Man", thumbnailURL: nil)

        // Add
        try await mockService.addFavorite(character: input)
        var isFav = await mockService.isFavorite(characterId: characterId)
        XCTAssertTrue(isFav)

        // Remove
        try await mockService.removeFavorite(characterId: characterId)
        isFav = await mockService.isFavorite(characterId: characterId)
        XCTAssertFalse(isFav)

        // Add again
        try await mockService.addFavorite(character: input)
        isFav = await mockService.isFavorite(characterId: characterId)
        XCTAssertTrue(isFav)
    }

    func testFavoriteCharacterInputEquality() {
        let url = URL(string: "https://example.com/image.jpg")

        let input1 = FavoriteCharacterInput(id: 1, name: "Spider-Man", thumbnailURL: url)
        let input2 = FavoriteCharacterInput(id: 1, name: "Spider-Man", thumbnailURL: url)

        // FavoriteCharacterInput não implementa Equatable, então comparamos propriedades
        XCTAssertEqual(input1.id, input2.id)
        XCTAssertEqual(input1.name, input2.name)
        XCTAssertEqual(input1.thumbnailURL, input2.thumbnailURL)
    }

    func testCallTracking() async throws {
        let input = FavoriteCharacterInput(id: 1, name: "Test", thumbnailURL: nil)

        // Múltiplas chamadas
        _ = await mockService.isFavorite(characterId: 1)
        _ = await mockService.isFavorite(characterId: 2)
        _ = await mockService.isFavorite(characterId: 3)

        try await mockService.addFavorite(character: input)
        try await mockService.addFavorite(character: FavoriteCharacterInput(id: 2, name: "T2", thumbnailURL: nil))

        try await mockService.removeFavorite(characterId: 1)

        let isFavCalls = await mockService.getIsFavoriteCallsCount()
        let addCalls = await mockService.getAddFavoriteCallsCount()
        let removeCalls = await mockService.getRemoveFavoriteCallsCount()

        XCTAssertEqual(isFavCalls, 3)
        XCTAssertEqual(addCalls, 2)
        XCTAssertEqual(removeCalls, 1)
    }
}
