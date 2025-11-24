//
//  ComicsListEmptyStateView.swift
//  ComicsList
//
//  Created by Ivan Tonial IP.TV on 19/11/25.
//

import DesignSystem
import SwiftUI

struct ComicsListEmptyStateView: View {
    var body: some View {
        EmptyStateComponent(
            icon: "book.closed",
            title: "No Comics Available",
            message: "This character doesn't have any comics yet."
        )
    }
}
