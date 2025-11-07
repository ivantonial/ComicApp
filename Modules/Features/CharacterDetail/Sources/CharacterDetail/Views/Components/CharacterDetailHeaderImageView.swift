
//
//  CharacterDetailHeaderImageView.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 10/10/25.
//

import DesignSystem
import ComicVineAPI
import SwiftUI

struct CharacterDetailHeaderImageView: View {
    let comicVineImage: ComicVineImage?

    var body: some View {
        GeometryReader { geometry in
            // Usa o novo ComicVineAsyncImageComponent com contexto de header
            ComicVineAsyncImageComponent(
                comicVineImage: comicVineImage,
                context: .detailHeader,
                contentMode: .fill
            )
            .frame(width: geometry.size.width, height: 400)
            .clipped()
            .overlay(gradientOverlay)
        }
        .frame(height: 400)
    }

    private var gradientOverlay: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.black.opacity(0),
                Color.black.opacity(0.3),
                Color.black.opacity(0.8)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
