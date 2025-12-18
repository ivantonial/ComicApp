//
//  CharacterDestinationTests.swift
//  AppCoordinator
//
//  Created by Ivan Tonial IP.TV on 27/11/25.
//

@testable import AppCoordinator
import ComicVineAPI
import SwiftUI
import Testing

// MARK: - CharacterDestination Tests

@Suite("CharacterDestination Tests")
struct CharacterDestinationTests {

    // MARK: - Hashable Tests

    @Test("CharacterDestination.detail should be hashable")
    func testDetailHashable() {
        // Arrange
        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")

        // Act
        let destination1 = CharacterDestination.detail(character)
        let destination2 = CharacterDestination.detail(character)

        // Assert
        #expect(destination1 == destination2)
        #expect(destination1.hashValue == destination2.hashValue)
    }

    @Test("CharacterDestination.comics should be hashable")
    func testComicsHashable() {
        // Arrange
        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")

        // Act
        let destination1 = CharacterDestination.comics(character)
        let destination2 = CharacterDestination.comics(character)

        // Assert
        #expect(destination1 == destination2)
        #expect(destination1.hashValue == destination2.hashValue)
    }

    // MARK: - Equality Tests

    @Test("Different CharacterDestinations should not be equal")
    func testDifferentDestinationsNotEqual() {
        // Arrange
        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")

        // Act
        let detailDestination = CharacterDestination.detail(character)
        let comicsDestination = CharacterDestination.comics(character)

        // Assert
        #expect(detailDestination != comicsDestination)
    }

    @Test("CharacterDestination with different characters should not be equal")
    func testDifferentCharactersNotEqual() {
        // Arrange
        let character1 = Character.coordinatorFixture(id: 1, name: "Spider-Man")
        let character2 = Character.coordinatorFixture(id: 2, name: "Iron Man")

        // Act
        let destination1 = CharacterDestination.detail(character1)
        let destination2 = CharacterDestination.detail(character2)

        // Assert
        #expect(destination1 != destination2)
    }

    // MARK: - Collection Tests

    @Test("CharacterDestination can be used in Set")
    func testDestinationInSet() {
        // Arrange
        let character1 = Character.coordinatorFixture(id: 1, name: "Spider-Man")
        let character2 = Character.coordinatorFixture(id: 2, name: "Iron Man")

        // Act
        var destinations: Set<CharacterDestination> = []
        destinations.insert(.detail(character1))
        destinations.insert(.detail(character2))
        destinations.insert(.comics(character1))
        destinations.insert(.detail(character1)) // Duplicata

        // Assert
        #expect(destinations.count == 3)
    }

    @Test("CharacterDestination can be used in Array")
    func testDestinationInArray() {
        // Arrange
        let character = Character.coordinatorFixture(id: 1, name: "Spider-Man")

        // Act
        let destinations: [CharacterDestination] = [
            .detail(character),
            .comics(character)
        ]

        // Assert
        #expect(destinations.count == 2)
        #expect(destinations.contains(.detail(character)))
        #expect(destinations.contains(.comics(character)))
    }

    // MARK: - Case Extraction Tests

    @Test("CharacterDestination.detail should contain correct character")
    func testDetailContainsCharacter() {
        // Arrange
        let character = Character.coordinatorFixture(id: 42, name: "Wolverine")

        // Act
        let destination = CharacterDestination.detail(character)

        // Assert
        if case .detail(let extractedCharacter) = destination {
            #expect(extractedCharacter.id == 42)
            #expect(extractedCharacter.name == "Wolverine")
        } else {
            Issue.record("Expected .detail case")
        }
    }

    @Test("CharacterDestination.comics should contain correct character")
    func testComicsContainsCharacter() {
        // Arrange
        let character = Character.coordinatorFixture(id: 99, name: "Batman")

        // Act
        let destination = CharacterDestination.comics(character)

        // Assert
        if case .comics(let extractedCharacter) = destination {
            #expect(extractedCharacter.id == 99)
            #expect(extractedCharacter.name == "Batman")
        } else {
            Issue.record("Expected .comics case")
        }
    }
}
