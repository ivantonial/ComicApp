//
//  CharacterListHeaderView.swift
//  CharacterList
//
//  Created by Ivan Tonial IP.TV on 19/11/25.
//

import DesignSystem
import SwiftUI

struct CharacterListHeaderView: View {
    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some View {
        Text("Comics Characters")
            .font(.system(size: 34, weight: .bold))
            .foregroundColor(themeManager.currentTheme.primaryText)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 10)
            .padding(.bottom, 15)
    }
}
