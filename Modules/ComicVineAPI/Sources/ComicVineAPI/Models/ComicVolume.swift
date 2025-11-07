//
//  ComicVolume.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 30/10/25.
//

import Foundation

public struct ComicVolume: Codable, Sendable {
    public let apiDetailUrl: String
    public let id: Int
    public let name: String?
    public let siteDetailUrl: String

    public init(apiDetailUrl: String, id: Int, name: String?, siteDetailUrl: String) {
        self.apiDetailUrl = apiDetailUrl
        self.id = id
        self.name = name
        self.siteDetailUrl = siteDetailUrl
    }
}
