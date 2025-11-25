//
//  CharacterDetailAdditionalInfoView.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 19/11/25.
//

import ComicVineAPI
import DesignSystem
import SwiftUI

struct CharacterDetailAdditionalInfoView: View {
    // MARK: - Properties
    let character: Character
    @ObservedObject private var themeManager = ThemeManager.shared
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Teams
            if let teams = character.teams, !teams.isEmpty {
                teamsSection(teams: teams)
            }
            
            // Powers
            if let powers = character.powers, !powers.isEmpty {
                powersSection(powers: powers)
            }
        }
    }
    
    // MARK: - Teams Section
    @ViewBuilder
    private func teamsSection(teams: [TeamReference]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TEAMS")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(themeManager.currentTheme.primaryAccent)
                .tracking(2)
            
            ForEach(teams.prefix(3), id: \.id) { team in
                HStack {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 12))
                        .foregroundColor(themeManager.currentTheme.warningAccent)
                    Text(team.name)
                        .font(.system(size: 14))
                        .foregroundColor(themeManager.currentTheme.primaryText)
                }
            }
        }
    }
    
    // MARK: - Powers Section
    @ViewBuilder
    private func powersSection(powers: [PowerReference]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("POWERS")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(themeManager.currentTheme.primaryAccent)
                .tracking(2)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(powers, id: \.id) { power in
                        Text(power.name)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(themeManager.currentTheme.primaryBackground)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(themeManager.currentTheme.warningAccent)
                            )
                    }
                }
            }
        }
    }
}
