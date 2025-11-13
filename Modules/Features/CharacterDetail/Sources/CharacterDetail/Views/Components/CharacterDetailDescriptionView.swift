//
//  CharacterDetailDescriptionView.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 10/10/25.
//

import DesignSystem
import SwiftUI

public struct CharacterDetailDescriptionView: View {
    // MARK: - Inputs
    let name: String
    let deck: String?
    let descriptionHTML: String?

    @State private var isShowingFullDescription = false

    public init(name: String, deck: String?, description: String?) {
        self.name = name
        self.deck = deck
        self.descriptionHTML = description
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 1) Na tela principal: só o deck
            if let deck, !deck.isEmpty {
                Text(deck)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // 2) Botão "View Full Description" se existir description
            if let descriptionHTML, !descriptionHTML.isEmpty {
                Button {
                    isShowingFullDescription = true
                } label: {
                    HStack(spacing: 4) {
                        Text("View Full Description")
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.red)
                }
                .padding(.top, 4)
                .accessibilityIdentifier("viewFullDescriptionButton")
            } else if deck == nil || deck?.isEmpty == true {
                // fallback quando não há deck nem description
                Text("No description available")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.gray.opacity(0.6))
                    .italic()
            }
        }
        // 3) Sheet com WebView formatado (DesignSystem.WebViewComponent)
        .sheet(isPresented: $isShowingFullDescription) {
            if let descriptionHTML, !descriptionHTML.isEmpty {
                DescriptionWebSheet(
                    html: descriptionHTML,
                    name: name
                )
            }
        }
    }
}

// MARK: - Sheet que usa o WebViewComponent do DesignSystem

private struct DescriptionWebSheet: View {
    let html: String
    let name: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            WebViewComponent(
                htmlContent: html,
                title: name
            )

            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
            }
        }
    }
}
