//
//  CharacterDetailInfoSectionView.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 19/11/25.
//

import ComicVineAPI
import DesignSystem
import SwiftUI

struct CharacterDetailInfoSectionView: View {
    // MARK: - Properties
    let character: Character
    @ObservedObject private var themeManager = ThemeManager.shared

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Character Name
            Text(character.name)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(themeManager.currentTheme.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Real Name (se disponível)
            if let realName = character.realName,
               !realName.isEmpty {
                Text("Real Name: \(realName)")
                    .font(.system(size: 14))
                    .foregroundColor(themeManager.currentTheme.secondaryText)
            }

            // Publisher (se disponível)
            if let publisher = character.publisher?.name {
                HStack(spacing: 4) {
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 12))
                    Text(publisher)
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(themeManager.currentTheme.primaryAccent.opacity(0.8))
                .padding(.top, 4)
            }
        }
        .onAppear {
            print("🔍 Displaying character: \(character.name)")
        }
    }
}
