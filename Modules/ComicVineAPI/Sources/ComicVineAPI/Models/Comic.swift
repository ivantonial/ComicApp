//
//  Comic.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 13/10/25.
//

import Foundation

// MARK: - ComicVine Issue/Comic Model
public struct Comic: Decodable, Identifiable, Sendable, Hashable {
    public let id: Int
    public let name: String?
    public let issueNumber: String?
    public let description: String?
    public let deck: String?
    public let image: ComicVineImage
    public let coverDate: String?
    public let storeDate: String?
    public let apiDetailUrl: String
    public let siteDetailUrl: String
    public let volume: VolumeSummary?
    public let hasStaffReview: Bool?
    public let dateAdded: String
    public let dateLastUpdated: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case issueNumber = "issue_number"
        case description
        case deck
        case image
        case coverDate = "cover_date"
        case storeDate = "store_date"
        case apiDetailUrl = "api_detail_url"
        case siteDetailUrl = "site_detail_url"
        case volume
        case hasStaffReview = "has_staff_review"
        case dateAdded = "date_added"
        case dateLastUpdated = "date_last_updated"
    }

    public var title: String {
        if let volumeName = volume?.name, let issueNumber = issueNumber {
            return "\(volumeName) #\(issueNumber)"
        } else if let name = name {
            return name
        } else if let volumeName = volume?.name {
            return volumeName
        }
        return "Unknown Comic"
    }

    public init(
        id: Int,
        name: String?,
        issueNumber: String?,
        description: String?,
        deck: String?,
        image: ComicVineImage,
        coverDate: String?,
        storeDate: String?,
        apiDetailUrl: String,
        siteDetailUrl: String,
        volume: VolumeSummary?,
        hasStaffReview: Bool?,
        dateAdded: String,
        dateLastUpdated: String
    ) {
        self.id = id
        self.name = name
        self.issueNumber = issueNumber
        self.description = description
        self.deck = deck
        self.image = image
        self.coverDate = coverDate
        self.storeDate = storeDate
        self.apiDetailUrl = apiDetailUrl
        self.siteDetailUrl = siteDetailUrl
        self.volume = volume
        self.hasStaffReview = hasStaffReview
        self.dateAdded = dateAdded
        self.dateLastUpdated = dateLastUpdated
    }

    public static func == (lhs: Comic, rhs: Comic) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Volume Summary
public struct VolumeSummary: Decodable, Sendable {
    public let id: Int
    public let name: String
    public let apiDetailUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case apiDetailUrl = "api_detail_url"
    }

    public init(id: Int, name: String, apiDetailUrl: String?) {
        self.id = id
        self.name = name
        self.apiDetailUrl = apiDetailUrl
    }
}
