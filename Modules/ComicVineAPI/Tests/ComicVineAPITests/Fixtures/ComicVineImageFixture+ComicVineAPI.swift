//
//  ComicVineImageFixture+ComicVineAPI.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 01/12/25.
//

@testable import ComicVineAPI
import Foundation

// MARK: - ComicVineImage Fixture for ComicVineAPI Tests

extension ComicVineImage {
    /// Fixture completa para testes do módulo ComicVineAPI
    /// Cria um ComicVineImage válido com todas as URLs preenchidas
    static func apiFixture(
        iconUrl: String? = "https://comicvine.gamespot.com/a/uploads/icon/icon.jpg",
        mediumUrl: String? = "https://comicvine.gamespot.com/a/uploads/medium/medium.jpg",
        screenUrl: String? = "https://comicvine.gamespot.com/a/uploads/screen/screen.jpg",
        screenLargeUrl: String? = "https://comicvine.gamespot.com/a/uploads/screen_large/screen_large.jpg",
        smallUrl: String? = "https://comicvine.gamespot.com/a/uploads/small/small.jpg",
        superUrl: String? = "https://comicvine.gamespot.com/a/uploads/super/super.jpg",
        thumbUrl: String? = "https://comicvine.gamespot.com/a/uploads/thumb/thumb.jpg",
        tinyUrl: String? = "https://comicvine.gamespot.com/a/uploads/tiny/tiny.jpg",
        originalUrl: String? = "https://comicvine.gamespot.com/a/uploads/original/original.jpg"
    ) -> ComicVineImage {
        ComicVineImage(
            iconUrl: iconUrl,
            mediumUrl: mediumUrl,
            screenUrl: screenUrl,
            screenLargeUrl: screenLargeUrl,
            smallUrl: smallUrl,
            superUrl: superUrl,
            thumbUrl: thumbUrl,
            tinyUrl: tinyUrl,
            originalUrl: originalUrl
        )
    }

    /// Fixture com apenas URL original (melhor qualidade)
    static func originalOnlyFixture(
        originalUrl: String = "https://comicvine.gamespot.com/a/uploads/original/original.jpg"
    ) -> ComicVineImage {
        ComicVineImage(
            iconUrl: nil,
            mediumUrl: nil,
            screenUrl: nil,
            screenLargeUrl: nil,
            smallUrl: nil,
            superUrl: nil,
            thumbUrl: nil,
            tinyUrl: nil,
            originalUrl: originalUrl
        )
    }

    /// Fixture com apenas URL de média qualidade
    static func mediumOnlyFixture(
        mediumUrl: String = "https://comicvine.gamespot.com/a/uploads/medium/medium.jpg"
    ) -> ComicVineImage {
        ComicVineImage(
            iconUrl: nil,
            mediumUrl: mediumUrl,
            screenUrl: nil,
            screenLargeUrl: nil,
            smallUrl: nil,
            superUrl: nil,
            thumbUrl: nil,
            tinyUrl: nil,
            originalUrl: nil
        )
    }

    /// Fixture com apenas thumbnail
    static func thumbnailOnlyFixture(
        thumbUrl: String = "https://comicvine.gamespot.com/a/uploads/thumb/thumb.jpg"
    ) -> ComicVineImage {
        ComicVineImage(
            iconUrl: nil,
            mediumUrl: nil,
            screenUrl: nil,
            screenLargeUrl: nil,
            smallUrl: nil,
            superUrl: nil,
            thumbUrl: thumbUrl,
            tinyUrl: nil,
            originalUrl: nil
        )
    }

    /// Fixture vazia (todas URLs nil)
    static func emptyFixture() -> ComicVineImage {
        ComicVineImage(
            iconUrl: nil,
            mediumUrl: nil,
            screenUrl: nil,
            screenLargeUrl: nil,
            smallUrl: nil,
            superUrl: nil,
            thumbUrl: nil,
            tinyUrl: nil,
            originalUrl: nil
        )
    }

    /// Fixture com URLs inválidas para testes de fallback
    /// Nota: Usamos strings com caracteres que são sempre inválidos em URLs
    /// para garantir que URL(string:) retorne nil em qualquer versão do SDK
    static func invalidUrlsFixture() -> ComicVineImage {
        ComicVineImage(
            iconUrl: "://invalid",           // Falta scheme - sempre inválido
            mediumUrl: "http://[invalid",    // Bracket não fechado - sempre inválido
            screenUrl: "",                   // String vazia - sempre inválido
            screenLargeUrl: nil,
            smallUrl: nil,
            superUrl: nil,
            thumbUrl: nil,
            tinyUrl: nil,
            originalUrl: nil
        )
    }

    /// Fixture com diferentes níveis de qualidade para testes de seleção
    static func qualityLevelsFixture() -> ComicVineImage {
        ComicVineImage(
            iconUrl: "https://example.com/icon.jpg",
            mediumUrl: "https://example.com/medium.jpg",
            screenUrl: "https://example.com/screen.jpg",
            screenLargeUrl: "https://example.com/screen_large.jpg",
            smallUrl: "https://example.com/small.jpg",
            superUrl: "https://example.com/super.jpg",
            thumbUrl: "https://example.com/thumb.jpg",
            tinyUrl: "https://example.com/tiny.jpg",
            originalUrl: "https://example.com/original.jpg"
        )
    }
}
