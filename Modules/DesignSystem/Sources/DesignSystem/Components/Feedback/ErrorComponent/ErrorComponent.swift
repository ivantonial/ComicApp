//
//  ErrorComponent.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import SwiftUI

public struct ErrorComponent: View {
    public let title: String
    public let message: String
    public let retryAction: (() -> Void)?
    @ObservedObject private var themeManager = ThemeManager.shared

    public init(title: String = "Erro",
                message: String,
                retryAction: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.retryAction = retryAction
    }

    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(themeManager.currentTheme.destructiveAccent)

            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.currentTheme.primaryText)

            Text(message)
                .font(.body)
                .foregroundColor(themeManager.currentTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if let retryAction {
                PrimaryButtonComponent(
                    title: "Tentar Novamente",
                    action: retryAction
                )
                .padding(.horizontal)
            }
        }
        .padding()
    }
}
