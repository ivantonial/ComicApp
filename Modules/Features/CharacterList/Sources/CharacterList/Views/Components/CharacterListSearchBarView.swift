//
//  CharacterListSearchBarView.swift
//  CharacterList
//
//  Created by Ivan Tonial IP.TV on 19/11/25.
//

import DesignSystem
import SwiftUI

struct CharacterListSearchBarView: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(themeManager.currentTheme.invertedText)
                .font(.system(size: 18))

            if isSearching {
                TextField("Search character", text: $searchText)
                    .foregroundColor(themeManager.currentTheme.invertedText)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .accentColor(themeManager.currentTheme.invertedText)

                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(themeManager.currentTheme.invertedText.opacity(0.8))
                    }
                }

                Button("Cancel") {
                    withAnimation(.spring()) {
                        isSearching = false
                        searchText = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
                .foregroundColor(themeManager.currentTheme.invertedText)
                .font(.system(size: 14, weight: .medium))
            } else {
                Text("Search")
                    .foregroundColor(themeManager.currentTheme.invertedText)
                    .font(.system(size: 16, weight: .medium))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: isSearching ? 25 : 30)
                .fill(themeManager.currentTheme.primaryAccent.opacity(isSearching ? 0.75 : 0.7))
                .shadow(color: themeManager.currentTheme.primaryAccent.opacity(0.5), radius: 15, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: isSearching ? 25 : 30)
                .stroke(themeManager.currentTheme.primaryAccent.opacity(0.8), lineWidth: 1.5)
        )
        .onTapGesture {
            if !isSearching {
                withAnimation(.spring()) { isSearching = true }
            }
        }
    }
}
