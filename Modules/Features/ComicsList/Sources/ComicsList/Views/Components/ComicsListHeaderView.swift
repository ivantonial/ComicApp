//
//  ComicsListHeaderView.swift
//  ComicsList
//
//  Created by Ivan Tonial IP.TV on 19/11/25.
//

import ComicVineAPI
import SwiftUI

struct ComicsListHeaderView: View {
    let character: Character
    let totalComics: Int
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))

                        Text("Back")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.white)
                }

                Spacer()

                if totalComics > 0 {
                    Text("\(totalComics) Comics")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.1))
                        )
                }
            }
            .padding(.horizontal)
            .padding(.top, 50)
            .padding(.bottom, 10)

            VStack(spacing: 8) {
                Text(character.name)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Comics Collection")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .background(Color.black)
    }
}
