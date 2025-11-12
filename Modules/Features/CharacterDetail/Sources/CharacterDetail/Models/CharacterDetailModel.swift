//
//  CharacterDetailModel.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 10/10/25.
//

import DesignSystem
import Foundation
import ComicVineAPI
import SwiftUI

// MARK: - Main Detail Model
public struct CharacterDetailModel: Sendable {
    public let character: Character
    public let stats: CharacterStatsModel
    public let relatedContent: CharacterRelatedContentModel
    public let shareInfo: CharacterShareInfoModel

    public init(from character: Character) {
        self.character = character
        self.stats = CharacterStatsModel(from: character)
        self.relatedContent = CharacterRelatedContentModel(from: character)
        self.shareInfo = CharacterShareInfoModel(from: character)
    }

    public mutating func update(with character: Character) {
        self = CharacterDetailModel(from: character)
    }
}

// MARK: - Stats Model
public struct CharacterStatsModel: Sendable {
    /// Estatísticas do personagem baseadas nos dados disponíveis na ComicVine API
    public let comics: StatItemModel      // Total de aparições em HQs
    public let friends: StatItemModel     // Amigos do personagem
    public let powers: StatItemModel      // Poderes do personagem
    public let enemies: StatItemModel     // Inimigos do personagem

    init(from character: Character) {
        // 1) Comics: número total de aparições em quadrinhos
        self.comics = StatItemModel(
            icon: "book.fill",
            title: "Comics",
            value: character.comicsCount,
            color: .red
        )

        // 2) Friends: quantidade de amigos/aliados do personagem
        let friendsCount = character.characterFriends?.count ?? 0
        self.friends = StatItemModel(
            icon: "person.2.fill",
            title: "Friends",
            value: friendsCount,
            color: .blue
        )

        // 3) Powers: quantidade de poderes/habilidades do personagem
        let powersCount = character.powers?.count ?? 0
        self.powers = StatItemModel(
            icon: "bolt.fill",
            title: "Powers",
            value: powersCount,
            color: .yellow
        )

        // 4) Enemies: quantidade de inimigos do personagem
        let enemiesCount = character.characterEnemies?.count ?? 0
        self.enemies = StatItemModel(
            icon: "exclamationmark.triangle.fill",
            title: "Enemies",
            value: enemiesCount,
            color: .green
        )
    }

    public var allStats: [StatItemModel] {
        [comics, friends, powers, enemies]
    }
}

// MARK: - Stat Item Model
public struct StatItemModel: Sendable, Identifiable {
    public let id = UUID()
    public let icon: String
    public let title: String
    public let value: Int
    public let color: ColorType

    public var displayValue: String {
        "\(value)"
    }
}

// MARK: - Related Content Model
public struct CharacterRelatedContentModel: Sendable {
    /// Lista de edições recentes (issues) associadas ao personagem
    public let recentComics: [RelatedItemModel]

    /// Lista de volumes/séries recentes associadas ao personagem
    public let recentSeries: [RelatedItemModel]

    init(from character: Character) {
        // A ComicVine expõe issues relacionadas em issueCredits
        let issues = character.issueCredits ?? []
        self.recentComics = issues.prefix(5).map { issue in
            let resourceURI =
                issue.siteDetailUrl ??
                issue.apiDetailUrl ??
                "issue-\(issue.id)"

            return RelatedItemModel(
                name: issue.name ?? "Unknown issue",
                resourceURI: resourceURI,
                type: .comic
            )
        }

        // E volumes/séries relacionadas em volumeCredits
        let volumes = character.volumeCredits ?? []
        self.recentSeries = volumes.prefix(5).map { volume in
            let resourceURI =
                volume.siteDetailUrl ??
                volume.apiDetailUrl ??
                "volume-\(volume.id)"

            return RelatedItemModel(
                name: volume.name,
                resourceURI: resourceURI,
                type: .series
            )
        }
    }

    public var hasContent: Bool {
        !recentComics.isEmpty || !recentSeries.isEmpty
    }
}


// MARK: - Related Item Model
public struct RelatedItemModel: Sendable, Identifiable {
    public var id: String { resourceURI }
    public let name: String
    public let resourceURI: String
    public let type: RelatedItemType

    public enum RelatedItemType: Sendable {
        case comic
        case series

        public var icon: String {
            switch self {
            case .comic: return "book.circle.fill"
            case .series: return "tv.circle.fill"
            }
        }

        public var color: DesignSystem.ColorType {
            switch self {
            case .comic: return .red
            case .series: return .blue
            }
        }
    }
}

// MARK: - Share Info Model
public struct CharacterShareInfoModel: Sendable {
    public let text: String
    public let detailURL: URL?
    public let wikiURL: URL?
    public let imageURL: URL?

    init(from character: Character) {
        // Texto padrão de compartilhamento
        self.text = "Check out \(character.name) on Comic Vine!"

        // Na ComicVine temos:
        // - apiDetailUrl: URL da API
        // - siteDetailUrl: URL da página pública do personagem
        self.detailURL = URL(string: character.siteDetailUrl)

        // Não existe um campo específico de "wiki" no modelo atual,
        // então deixamos nil (ou poderíamos reutilizar siteDetailUrl).
        self.wikiURL = nil

        // ComicVineImage expõe bestQualityUrl (já usado em CharacterSummaryModel)
        self.imageURL = character.image.bestQualityUrl
    }

    public var shareItems: [Any] {
        var items: [Any] = [text]
        if let detailURL = detailURL {
            items.append(detailURL)
        }
        if let imageURL = imageURL {
            items.append(imageURL)
        }
        return items
    }
}
