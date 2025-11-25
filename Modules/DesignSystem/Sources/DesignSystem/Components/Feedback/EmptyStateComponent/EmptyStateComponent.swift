//
//  EmptyStateComponent.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 19/11/25.
//

import SwiftUI

public struct EmptyStateComponent: View {
    // MARK: - Properties
    private let icon: String
    private let title: String
    private let message: String
    private let iconSize: CGFloat
    private let action: (() -> Void)?
    private let actionTitle: String?

    @ObservedObject private var themeManager = ThemeManager.shared

    // MARK: - Initialization
    public init(
        icon: String,
        title: String,
        message: String,
        iconSize: CGFloat = 80,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.iconSize = iconSize
        self.actionTitle = actionTitle
        self.action = action
    }

    // MARK: - Body
    public var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: icon)
                .font(.system(size: iconSize))
                .foregroundColor(themeManager.currentTheme.tertiaryText)

            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.currentTheme.primaryText)

            Text(message)
                .font(.body)
                .foregroundColor(themeManager.currentTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(themeManager.currentTheme.primaryBackground)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(themeManager.currentTheme.primaryAccent)
                        .cornerRadius(25)
                }
                .padding(.top, 10)
            }

            Spacer()
        }
        .padding()
    }
}
