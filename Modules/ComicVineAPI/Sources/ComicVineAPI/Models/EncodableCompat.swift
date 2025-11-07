//
//  EncodableCompat.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 13/10/25.
//

import Foundation

// MARK: - Codable Wrappers para cache seguro sem modificar as models originais

public struct EncodableCharacter: Codable, Sendable {
    public let id: Int;
    public let name: String;
    public let description: String?;
    public let deck: String?;
    public let imageOriginalUrl: String?;
    public let imageMediumUrl: String?;
    public let apiDetailUrl: String;
    public let countOfIssueAppearances: Int;
    public let realName: String?;
    public let aliases: String?;
    public let dateAdded: String;
    public let dateLastUpdated: String;

    public init(from character: Character) {
        self.id = character.id;
        self.name = character.name;
        self.description = character.description;
        self.deck = character.deck;
        self.imageOriginalUrl = character.image.originalUrl;
        self.imageMediumUrl = character.image.mediumUrl;
        self.apiDetailUrl = character.apiDetailUrl;
        self.countOfIssueAppearances = character.countOfIssueAppearances;
        self.realName = character.realName;
        self.aliases = character.aliases;
        self.dateAdded = character.dateAdded;
        self.dateLastUpdated = character.dateLastUpdated;
    }

    public func toCharacter() -> Character {
        let image = ComicVineImage(
            iconUrl: nil,
            mediumUrl: imageMediumUrl,
            screenUrl: nil,
            screenLargeUrl: nil,
            smallUrl: nil,
            superUrl: nil,
            thumbUrl: nil,
            tinyUrl: nil,
            originalUrl: imageOriginalUrl
        );

        return Character(
            id: id,
            name: name,
            description: description,
            deck: deck,
            aliases: aliases,
            image: image,
            apiDetailUrl: apiDetailUrl,
            siteDetailUrl: "",
            firstAppearedInIssue: nil,
            countOfIssueAppearances: countOfIssueAppearances,
            realName: realName,
            birth: nil,
            dateAdded: dateAdded,
            dateLastUpdated: dateLastUpdated,
            gender: nil,
            origin: nil,
            publisher: nil
        );
    }
}

public struct EncodableComic: Codable, Sendable {
    public let id: Int;
    public let name: String?;
    public let issueNumber: String?;
    public let description: String?;
    public let deck: String?;
    public let imageOriginalUrl: String?;
    public let imageMediumUrl: String?;
    public let coverDate: String?;
    public let apiDetailUrl: String;
    public let volumeName: String?;
    public let volumeId: Int?;

    public init(from comic: Comic) {
        self.id = comic.id;
        self.name = comic.name;
        self.issueNumber = comic.issueNumber;
        self.description = comic.description;
        self.deck = comic.deck;
        self.imageOriginalUrl = comic.image.originalUrl;
        self.imageMediumUrl = comic.image.mediumUrl;
        self.coverDate = comic.coverDate;
        self.apiDetailUrl = comic.apiDetailUrl;
        self.volumeName = comic.volume?.name;
        self.volumeId = comic.volume?.id;
    }

    public func toComic() -> Comic {
        let image = ComicVineImage(
            iconUrl: nil,
            mediumUrl: imageMediumUrl,
            screenUrl: nil,
            screenLargeUrl: nil,
            smallUrl: nil,
            superUrl: nil,
            thumbUrl: nil,
            tinyUrl: nil,
            originalUrl: imageOriginalUrl
        );

        let volume: VolumeSummary? = {
            if let vName = volumeName, let vId = volumeId {
                return VolumeSummary(id: vId, name: vName, apiDetailUrl: nil);
            }
            return nil;
        }();

        return Comic(
            id: id,
            name: name,
            issueNumber: issueNumber,
            description: description,
            deck: deck,
            image: image,
            coverDate: coverDate,
            storeDate: nil,
            apiDetailUrl: apiDetailUrl,
            siteDetailUrl: "",
            volume: volume,
            hasStaffReview: false,
            dateAdded: "",
            dateLastUpdated: ""
        );
    }
}
