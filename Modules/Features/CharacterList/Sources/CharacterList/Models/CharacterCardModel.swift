//
//  CharacterCardModel.swift
//  CharacterList
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import ComicVineAPI
import DesignSystem
import Foundation
import SwiftUI

public struct CharacterCardModel: Identifiable, ContentCardConvertible {
    public let id: Int
    public let name: String
    public let comicVineImage: ComicVineImage?
    public let comicsCount: Int
    public let aspectRatio: CGFloat

    // MARK: - Constants
    // Default aspect ratio for characters is always square
    private static let defaultCharacterAspectRatio: CGFloat = 1.0

    public init(
        id: Int,
        name: String,
        comicVineImage: ComicVineImage?,
        comicsCount: Int,
        aspectRatio: CGFloat? = nil
    ) {
        self.id = id
        self.name = name
        self.comicVineImage = comicVineImage
        self.comicsCount = comicsCount
        // Force square aspect ratio for characters (or use custom if provided)
        self.aspectRatio = aspectRatio ?? Self.defaultCharacterAspectRatio
    }

    public init(from character: Character) {
        self.id = character.id
        self.name = character.name
        self.comicVineImage = character.image
        self.comicsCount = character.countOfIssueAppearances
        // Characters always use square aspect ratio
        self.aspectRatio = Self.defaultCharacterAspectRatio
    }

    // MARK: - Conversion to ContentCardModel
    public func toContentCardModel() -> ContentCardModel {
        // For characters, always use .fill to ensure the image fills the card
        ContentCardModel(
            id: id,
            title: name,
            subtitle: nil,
            comicVineImage: comicVineImage,
            aspectRatio: aspectRatio,
            contentMode: .fill,
            badge: defaultBadge(
                icon: "book.fill",
                text: "\(comicsCount) comics",
                color: .red
            ),
            fixedHeight: nil
        )
    }
}
