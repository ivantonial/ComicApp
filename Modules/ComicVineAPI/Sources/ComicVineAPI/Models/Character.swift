//
//  Character.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 13/10/25.
//

import Foundation

// MARK: - ComicVine Character Model
public struct Character: Decodable, Identifiable, Sendable, Hashable {
    public let id: Int
    public let name: String
    public let description: String?
    public let deck: String?
    public let aliases: String?
    public let image: ComicVineImage
    public let apiDetailUrl: String
    public let siteDetailUrl: String
    public let firstAppearedInIssue: IssueSummary?
    public let countOfIssueAppearances: Int
    public let realName: String?
    public let birth: String?
    public let dateAdded: String
    public let dateLastUpdated: String
    public let gender: Int?
    public let origin: OriginSummary?
    public let publisher: PublisherSummary?

    // Novos campos da API real
    public let characterEnemies: [CharacterReference]?
    public let characterFriends: [CharacterReference]?
    public let creators: [CreatorReference]?
    public let issueCredits: [IssueCredit]?
    public let powers: [PowerReference]?
    public let teams: [TeamReference]?
    public let volumeCredits: [VolumeCredit]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case deck
        case aliases
        case image
        case apiDetailUrl = "api_detail_url"
        case siteDetailUrl = "site_detail_url"
        case firstAppearedInIssue = "first_appeared_in_issue"
        case countOfIssueAppearances = "count_of_issue_appearances"
        case realName = "real_name"
        case birth
        case dateAdded = "date_added"
        case dateLastUpdated = "date_last_updated"
        case gender
        case origin
        case publisher
        case characterEnemies = "character_enemies"
        case characterFriends = "character_friends"
        case creators
        case issueCredits = "issue_credits"
        case powers
        case teams
        case volumeCredits = "volume_credits"
    }

    public init(
        id: Int,
        name: String,
        description: String?,
        deck: String?,
        aliases: String?,
        image: ComicVineImage,
        apiDetailUrl: String,
        siteDetailUrl: String,
        firstAppearedInIssue: IssueSummary?,
        countOfIssueAppearances: Int,
        realName: String?,
        birth: String?,
        dateAdded: String,
        dateLastUpdated: String,
        gender: Int?,
        origin: OriginSummary?,
        publisher: PublisherSummary?,
        characterEnemies: [CharacterReference]? = nil,
        characterFriends: [CharacterReference]? = nil,
        creators: [CreatorReference]? = nil,
        issueCredits: [IssueCredit]? = nil,
        powers: [PowerReference]? = nil,
        teams: [TeamReference]? = nil,
        volumeCredits: [VolumeCredit]? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.deck = deck
        self.aliases = aliases
        self.image = image
        self.apiDetailUrl = apiDetailUrl
        self.siteDetailUrl = siteDetailUrl
        self.firstAppearedInIssue = firstAppearedInIssue
        self.countOfIssueAppearances = countOfIssueAppearances
        self.realName = realName
        self.birth = birth
        self.dateAdded = dateAdded
        self.dateLastUpdated = dateLastUpdated
        self.gender = gender
        self.origin = origin
        self.publisher = publisher
        self.characterEnemies = characterEnemies
        self.characterFriends = characterFriends
        self.creators = creators
        self.issueCredits = issueCredits
        self.powers = powers
        self.teams = teams
        self.volumeCredits = volumeCredits
    }

    public static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Supporting Structures (existentes)
public struct IssueSummary: Decodable, Sendable {
    public let id: Int
    public let name: String?
    public let apiDetailUrl: String?
    public let issueNumber: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case apiDetailUrl = "api_detail_url"
        case issueNumber = "issue_number"
    }
}

public struct OriginSummary: Decodable, Sendable {
    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

public struct PublisherSummary: Decodable, Sendable {
    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

// MARK: - New Supporting Structures
public struct CharacterReference: Decodable, Sendable {
    public let id: Int
    public let name: String
    public let apiDetailUrl: String?
    public let siteDetailUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case apiDetailUrl = "api_detail_url"
        case siteDetailUrl = "site_detail_url"
    }
}

public struct CreatorReference: Decodable, Sendable {
    public let id: Int
    public let name: String
    public let apiDetailUrl: String?
    public let siteDetailUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case apiDetailUrl = "api_detail_url"
        case siteDetailUrl = "site_detail_url"
    }
}

public struct IssueCredit: Decodable, Sendable {
    public let id: Int
    public let name: String?
    public let apiDetailUrl: String?
    public let siteDetailUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case apiDetailUrl = "api_detail_url"
        case siteDetailUrl = "site_detail_url"
    }
}

public struct PowerReference: Decodable, Sendable {
    public let id: Int
    public let name: String
    public let apiDetailUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case apiDetailUrl = "api_detail_url"
    }
}

public struct TeamReference: Decodable, Sendable {
    public let id: Int
    public let name: String
    public let apiDetailUrl: String?
    public let siteDetailUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case apiDetailUrl = "api_detail_url"
        case siteDetailUrl = "site_detail_url"
    }
}

public struct VolumeCredit: Decodable, Sendable {
    public let id: Int
    public let name: String
    public let apiDetailUrl: String?
    public let siteDetailUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case apiDetailUrl = "api_detail_url"
        case siteDetailUrl = "site_detail_url"
    }
}

// MARK: - Computed Properties convenientes
public extension Character {
    /// Imagem do personagem
    var thumbnail: ComicVineImage {
        image
    }

    /// Total de aparições em quadrinhos
    var comicsCount: Int {
        countOfIssueAppearances
    }

    /// Se tem descrição disponível
    var hasDescription: Bool {
        description != nil && !description!.isEmpty
    }

    /// Se tem deck (resumo) disponível
    var hasDeck: Bool {
        deck != nil && !deck!.isEmpty
    }
}
