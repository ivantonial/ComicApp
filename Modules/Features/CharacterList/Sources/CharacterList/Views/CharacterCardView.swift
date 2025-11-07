//
//  CharacterCardView.swift
//  CharacterList
//
//  Created by Ivan Tonial IP.TV on 07/10/25.
//

import DesignSystem
import ComicVineAPI
import SwiftUI

/// View específica para exibir cards de personagens.
public struct CharacterCardView: View {
    let model: CharacterCardModel
    let onTap: (() -> Void)?

    public init(
        model: CharacterCardModel,
        onTap: (() -> Void)? = nil
    ) {
        self.model = model
        self.onTap = onTap
    }

    public var body: some View {
        ContentCardComponent(
            model: model.toContentCardModel(),
            onTap: onTap
        )
    }
}

//"icon_url": "https://comicvine.gamespot.com/a/uploads/square_avatar/6/68065/7666828-lightninglad05.jpg",
//"medium_url": "https://comicvine.gamespot.com/a/uploads/scale_medium/6/68065/7666828-lightninglad05.jpg",
//"screen_url": "https://comicvine.gamespot.com/a/uploads/screen_medium/6/68065/7666828-lightninglad05.jpg",
//"screen_large_url": "https://comicvine.gamespot.com/a/uploads/screen_kubrick/6/68065/7666828-lightninglad05.jpg",
//"small_url": "https://comicvine.gamespot.com/a/uploads/scale_small/6/68065/7666828-lightninglad05.jpg",
//"super_url": "https://comicvine.gamespot.com/a/uploads/scale_large/6/68065/7666828-lightninglad05.jpg",
//"thumb_url": "https://comicvine.gamespot.com/a/uploads/scale_avatar/6/68065/7666828-lightninglad05.jpg",
//"tiny_url": "https://comicvine.gamespot.com/a/uploads/square_mini/6/68065/7666828-lightninglad05.jpg",
//"original_url": "https://comicvine.gamespot.com/a/uploads/original/6/68065/7666828-lightninglad05.jpg",
