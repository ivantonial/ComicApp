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
