//
//  SearchBarComponent.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 19/11/25.
//

import SwiftUI

public struct SearchBarComponent: View {
    // MARK: - Properties
    @Binding private var text: String
    private let placeholder: String
    private let showClearButton: Bool
    private let onEditingChanged: ((Bool) -> Void)?
    private let onCommit: (() -> Void)?

    @ObservedObject private var themeManager = ThemeManager.shared
    @FocusState private var isFocused: Bool

    // MARK: - Initialization
    public init(
        text: Binding<String>,
        placeholder: String = "Search...",
        showClearButton: Bool = true,
        onEditingChanged: ((Bool) -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.showClearButton = showClearButton
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }

    // MARK: - Body
    public var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(themeManager.currentTheme.tertiaryText)
                .font(.system(size: 16))

            TextField(placeholder, text: $text, onEditingChanged: { editing in
                onEditingChanged?(editing)
            }, onCommit: {
                onCommit?()
            })
            .foregroundColor(themeManager.currentTheme.primaryText)
            .autocorrectionDisabled()
            .focused($isFocused)
            .accentColor(themeManager.currentTheme.primaryAccent)

            if showClearButton && !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(themeManager.currentTheme.tertiaryText.opacity(0.8))
                        .font(.system(size: 16))
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(themeManager.currentTheme.searchBarBackground)
        .cornerRadius(10)
    }
}
