//
//  ComicVineImage.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 30/10/25.
//

import Foundation

// MARK: - ComicVine Image Model
public struct ComicVineImage: Decodable, Sendable {
    public let iconUrl: String?
    public let mediumUrl: String?
    public let screenUrl: String?
    public let screenLargeUrl: String?
    public let smallUrl: String?
    public let superUrl: String?
    public let thumbUrl: String?
    public let tinyUrl: String?
    public let originalUrl: String?

    enum CodingKeys: String, CodingKey {
        case iconUrl = "icon_url"
        case mediumUrl = "medium_url"
        case screenUrl = "screen_url"
        case screenLargeUrl = "screen_large_url"
        case smallUrl = "small_url"
        case superUrl = "super_url"
        case thumbUrl = "thumb_url"
        case tinyUrl = "tiny_url"
        case originalUrl = "original_url"
    }

    // MARK: - Public Initializer
    public init(
        iconUrl: String? = nil,
        mediumUrl: String? = nil,
        screenUrl: String? = nil,
        screenLargeUrl: String? = nil,
        smallUrl: String? = nil,
        superUrl: String? = nil,
        thumbUrl: String? = nil,
        tinyUrl: String? = nil,
        originalUrl: String? = nil
    ) {
        self.iconUrl = iconUrl
        self.mediumUrl = mediumUrl
        self.screenUrl = screenUrl
        self.screenLargeUrl = screenLargeUrl
        self.smallUrl = smallUrl
        self.superUrl = superUrl
        self.thumbUrl = thumbUrl
        self.tinyUrl = tinyUrl
        self.originalUrl = originalUrl
    }

    // MARK: - Computed Properties for Different Quality Levels
    public var bestQualityUrl: URL? {
        let urls = [originalUrl, superUrl, screenLargeUrl, screenUrl, mediumUrl, smallUrl, thumbUrl]
        for urlString in urls {
            if let urlString = urlString, let url = URL(string: urlString) {
                return url
            }
        }
        return nil
    }

    public var mediumQualityUrl: URL? {
        let urls = [mediumUrl, screenUrl, smallUrl]
        for urlString in urls {
            if let urlString = urlString, let url = URL(string: urlString) {
                return url
            }
        }
        return bestQualityUrl
    }

    public var thumbnailUrl: URL? {
        if let thumbUrl = thumbUrl, let url = URL(string: thumbUrl) {
            return url
        }
        return mediumQualityUrl
    }
}
