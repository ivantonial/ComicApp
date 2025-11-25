//
//  HeaderComponent.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 19/11/25.
//

import SwiftUI

public struct HeaderComponent: View {
    // MARK: - Properties
    private let title: String
    private let subtitle: String?
    private let alignment: HorizontalAlignment
    private let showBackButton: Bool
    private let backButtonAction: (() -> Void)?
    private let trailingContent: AnyView?

    @ObservedObject private var themeManager = ThemeManager.shared

    // MARK: - Initialization
    public init(
        title: String,
        subtitle: String? = nil,
        alignment: HorizontalAlignment = .leading,
        showBackButton: Bool = false,
        backButtonAction: (() -> Void)? = nil,
        trailingContent: AnyView? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.alignment = alignment
        self.showBackButton = showBackButton
        self.backButtonAction = backButtonAction
        self.trailingContent = trailingContent
    }

    // MARK: - Body
    public var body: some View {
        VStack(spacing: 0) {
            if showBackButton || trailingContent != nil {
                HStack {
                    if showBackButton {
                        Button(action: {
                            backButtonAction?()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Back")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(themeManager.currentTheme.primaryText)
                        }
                    }

                    Spacer()

                    if let trailingContent = trailingContent {
                        trailingContent
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }

            VStack(alignment: alignment, spacing: 8) {
                Text(title)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(themeManager.currentTheme.primaryText)
                    .frame(maxWidth: .infinity, alignment: alignment == .center ? .center : .leading)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(themeManager.currentTheme.secondaryText)
                        .frame(maxWidth: .infinity, alignment: alignment == .center ? .center : .leading)
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Convenience Initializers
public extension HeaderComponent {
    init(
        title: String,
        subtitle: String? = nil,
        alignment: HorizontalAlignment = .leading
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            alignment: alignment,
            showBackButton: false,
            backButtonAction: nil,
            trailingContent: nil
        )
    }

    init<Content: View>(
        title: String,
        subtitle: String? = nil,
        alignment: HorizontalAlignment = .leading,
        @ViewBuilder trailingContent: () -> Content
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            alignment: alignment,
            showBackButton: false,
            backButtonAction: nil,
            trailingContent: AnyView(trailingContent())
        )
    }
}
