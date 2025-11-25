//
//  SortChipView.swift
//  Favorites
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import SwiftUI
import DesignSystem

public struct SortChipView: View {
    public let title: String
    public let icon: String
    public let isSelected: Bool
    public let action: () -> Void

    @ObservedObject private var themeManager = ThemeManager.shared

    public init(
        title: String,
        icon: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon).font(.caption2)
                Text(title).font(.caption2)
            }
            .foregroundColor(
                isSelected ? themeManager.currentTheme.primaryAccent : themeManager.currentTheme.secondaryText
            )
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .overlay(
                Capsule()
                    .stroke(
                        isSelected ? themeManager.currentTheme.primaryAccent : themeManager.currentTheme.borderColor,
                        lineWidth: 1
                    )
            )
        }
    }
}
