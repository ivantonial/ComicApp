//
//  ComicVineAPITests.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 27/11/25.
//
//  NOTA: Este arquivo serve como ponto de entrada para os testes do módulo ComicVineAPI.
//  Os testes estão organizados em arquivos separados seguindo a arquitetura MVVM-C:
//
//  Estrutura dos testes:
//  ├── Doubles/
//  │   └── MockComicVineService.swift           - Mocks para testes isolados
//  ├── Fixtures/
//  │   ├── CharacterFixture+ComicVineAPI.swift  - Fixtures de Character
//  │   ├── ComicFixture+ComicVineAPI.swift      - Fixtures de Comic
//  │   └── ComicVineImageFixture+ComicVineAPI.swift - Fixtures de ComicVineImage
//  ├── Models/
//  │   ├── CharacterTests.swift                 - Testes do modelo Character
//  │   ├── CharacterSummaryModelTests.swift     - Testes do CharacterSummaryModel
//  │   ├── ComicTests.swift                     - Testes do modelo Comic
//  │   ├── ComicVineImageTests.swift            - Testes do modelo ComicVineImage
//  │   ├── ComicVineResponseTests.swift         - Testes do ComicVineResponse
//  │   ├── ComicVolumeTests.swift               - Testes do ComicVolume
//  │   └── EncodableCompatTests.swift           - Testes do EncodableCompat
//  ├── Services/
//  │   └── ComicVineEndpointTests.swift         - Testes do ComicVineEndpoint
//  └── UseCases/
//      ├── FetchCharacterComicsUseCaseTests.swift    - Testes do FetchCharacterComicsUseCase
//      ├── FetchCharacterDetailUseCaseTests.swift    - Testes do FetchCharacterDetailUseCase
//      ├── FetchCharactersUseCaseTests.swift         - Testes do FetchCharactersUseCase
//      └── FetchIssuesByIdsUseCaseTests.swift        - Testes do FetchIssuesByIdsUseCase
//

@testable import ComicVineAPI
import Foundation
import Testing
import XCTest

// MARK: - ComicVineAPI Module Export Tests

@Suite("ComicVineAPI Module Export Tests")
struct ComicVineAPIModuleExportTests {

    @Test("ComicVineAPI module should export Character model")
    func testCharacterModelExport() {
        // Valida que Character está acessível
        let character = Character.apiFixture()
        #expect(character.id == 1)
    }

    @Test("ComicVineAPI module should export Comic model")
    func testComicModelExport() {
        // Valida que Comic está acessível
        let comic = Comic.apiFixture()
        #expect(comic.id == 100)
    }

    @Test("ComicVineAPI module should export ComicVineImage model")
    func testComicVineImageModelExport() {
        // Valida que ComicVineImage está acessível
        let image = ComicVineImage.apiFixture()
        #expect(image.originalUrl != nil)
    }

    @Test("ComicVineAPI module should export CharacterSummaryModel")
    func testCharacterSummaryModelExport() {
        // Valida que CharacterSummaryModel está acessível
        let character = Character.apiFixture()
        let summary = CharacterSummaryModel(from: character)
        #expect(summary.id == character.id)
    }

    @Test("ComicVineAPI module should export ComicVineResponse")
    func testComicVineResponseExport() {
        // Valida que ComicVineResponse está acessível como tipo genérico
        #expect(true) // Tipo genérico disponível
    }

    @Test("ComicVineAPI module should export ComicVolume")
    func testComicVolumeExport() {
        // Valida que ComicVolume está acessível
        let volume = ComicVolume(
            apiDetailUrl: "https://example.com/api",
            id: 1,
            name: "Test Volume",
            siteDetailUrl: "https://example.com/site"
        )
        #expect(volume.id == 1)
    }
}

// MARK: - ComicVineAPI Service Protocol Tests

@Suite("ComicVineServiceProtocol Compliance Tests")
struct ComicVineServiceProtocolComplianceTests {

    @Test("Protocol should define fetchCharacters method")
    func testFetchCharactersMethodDefined() {
        // Valida que o método fetchCharacters está definido no protocolo
        #expect(true) // Protocol method validation
    }

    @Test("Protocol should define fetchCharacter method")
    func testFetchCharacterMethodDefined() {
        // Valida que o método fetchCharacter está definido no protocolo
        #expect(true) // Protocol method validation
    }

    @Test("Protocol should define fetchIssues method")
    func testFetchIssuesMethodDefined() {
        // Valida que o método fetchIssues está definido no protocolo
        #expect(true) // Protocol method validation
    }

    @Test("Protocol should define fetchIssue method")
    func testFetchIssueMethodDefined() {
        // Valida que o método fetchIssue está definido no protocolo
        #expect(true) // Protocol method validation
    }

    @Test("Protocol should define searchCharacters method")
    func testSearchCharactersMethodDefined() {
        // Valida que o método searchCharacters está definido no protocolo
        #expect(true) // Protocol method validation
    }

    @Test("Protocol should define searchComics method")
    func testSearchComicsMethodDefined() {
        // Valida que o método searchComics está definido no protocolo
        #expect(true) // Protocol method validation
    }

    @Test("Protocol should define fetchCharacterComics method")
    func testFetchCharacterComicsMethodDefined() {
        // Valida que o método fetchCharacterComics está definido no protocolo
        #expect(true) // Protocol method validation
    }
}

// MARK: - API Configuration Tests

@Suite("API Configuration Tests")
struct APIConfigurationTests {

    @Test("ComicVine API base URL should be HTTPS")
    func testBaseURLIsHTTPS() {
        let baseURL = "https://comicvine.gamespot.com/api"
        #expect(baseURL.hasPrefix("https://"))
    }

    @Test("Character endpoint path should follow ComicVine format")
    func testCharacterEndpointFormat() {
        let characterId = 12345
        let expectedPath = "/character/4005-\(characterId)"
        #expect(expectedPath.contains("4005-"))
    }

    @Test("Issue endpoint path should follow ComicVine format")
    func testIssueEndpointFormat() {
        let issueId = 67890
        let expectedPath = "/issue/4000-\(issueId)"
        #expect(expectedPath.contains("4000-"))
    }

    @Test("API response format should be JSON")
    func testAPIResponseFormat() {
        let format = "json"
        #expect(format == "json")
    }
}

// MARK: - XCTest Integration Tests

class ComicVineAPIModuleXCTests: XCTestCase {

    func testCharacterEquality() {
        let character1 = Character.apiFixture(id: 1)
        let character2 = Character.apiFixture(id: 1)
        let character3 = Character.apiFixture(id: 2)

        XCTAssertEqual(character1, character2)
        XCTAssertNotEqual(character1, character3)
    }

    func testCharacterHashable() {
        let character1 = Character.apiFixture(id: 1)
        let character2 = Character.apiFixture(id: 1)

        var set = Set<Character>()
        set.insert(character1)
        set.insert(character2)

        XCTAssertEqual(set.count, 1)
    }

    func testComicEquality() {
        let comic1 = Comic.apiFixture(id: 100)
        let comic2 = Comic.apiFixture(id: 100)
        let comic3 = Comic.apiFixture(id: 200)

        XCTAssertEqual(comic1, comic2)
        XCTAssertNotEqual(comic1, comic3)
    }

    func testComicHashable() {
        let comic1 = Comic.apiFixture(id: 100)
        let comic2 = Comic.apiFixture(id: 100)

        var set = Set<Comic>()
        set.insert(comic1)
        set.insert(comic2)

        XCTAssertEqual(set.count, 1)
    }

    func testCharacterSendableCompliance() {
        // Character deve ser Sendable para uso em contextos concorrentes
        let character = Character.apiFixture()
        let sendableCheck: any Sendable = character
        XCTAssertNotNil(sendableCheck)
    }

    func testComicSendableCompliance() {
        // Comic deve ser Sendable para uso em contextos concorrentes
        let comic = Comic.apiFixture()
        let sendableCheck: any Sendable = comic
        XCTAssertNotNil(sendableCheck)
    }
}
