//
//  ComicCardModel.swift
//  ComicsList
//
//  Created by Ivan Tonial IP.TV on 10/10/25.
//

import ComicVineAPI
import DesignSystem
import SwiftUI

public struct ComicCardModel: Identifiable, Sendable {
    public let id: Int
    public let title: String
    public let issueNumber: String?
    public let imageURL: URL?
    public let coverDate: String?

    public init(from comic: Comic) {
        self.id = comic.id
        self.title = comic.title
        self.issueNumber = comic.issueNumber
        self.imageURL = comic.image.bestQualityUrl
        self.coverDate = comic.coverDate
    }
}

// MARK: - ContentCardConvertible Conformance
extension ComicCardModel: ContentCardConvertible {
    public func toContentCardModel() -> ContentCardModel {
        ContentCardModel(
            id: id,
            title: title,
            subtitle: issueNumber.map { "Issue #\($0)" },
            imageURL: imageURL,
            aspectRatio: 3.0 / 4.0,
            badge: coverDate.map {
                ContentCardModel.BadgeModel(
                    icon: "calendar",
                    text: formatDate($0),
                    color: .blue
                )
            }
        )
    }

    private func formatDate(_ dateString: String) -> String {
        let components = dateString.split(separator: "-")
        guard components.count >= 2 else { return dateString }

        let months = [
            "",
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec"
        ]

        if let monthIndex = Int(components[1]),
           monthIndex > 0 && monthIndex <= 12 {
            return "\(months[monthIndex]) \(components[0])"
        }

        return dateString
    }
}
