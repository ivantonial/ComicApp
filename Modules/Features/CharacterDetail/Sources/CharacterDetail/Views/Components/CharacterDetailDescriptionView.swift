//
//  CharacterDetailDescriptionView.swift
//  CharacterDetail
//
//  Created by Ivan Tonial IP.TV on 10/10/25.
//

//import SwiftUI
//import DesignSystem
//
//public struct CharacterDetailDescriptionView: View {
//    // MARK: - Public Inputs
//    let deck: String?
//    let description: String?
//
//    // Local state for presenting full description
//    @State private var isShowingFullDescription = false
//
//    public init(deck: String?, description: String?) {
//        self.deck = deck
//        self.description = description
//    }
//
//    public var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            // Deck - resumo curto
//            if let deck = deck, !deck.isEmpty {
//                Text(deck)
//                    .font(.system(size: 16, weight: .regular))
//                    .foregroundColor(.white)
//                    .fixedSize(horizontal: false, vertical: true)
//            }
//
//            // Description preview
//            if let description = description, !description.isEmpty {
//                Text(makeSummary(from: description))
//                    .font(.system(size: 15, weight: .regular))
//                    .foregroundColor(.gray)
//                    .fixedSize(horizontal: false, vertical: true)
//                    .lineLimit(4)
//
//                Button(action: { isShowingFullDescription = true }) {
//                    HStack(spacing: 4) {
//                        Text("View Full Description")
//                        Image(systemName: "arrow.right.circle.fill")
//                    }
//                    .font(.system(size: 15, weight: .bold))
//                    .foregroundColor(.red)
//                }
//                .padding(.top, 6)
//                .accessibilityIdentifier("viewFullDescriptionButton")
//            } else if deck == nil || deck?.isEmpty == true {
//                Text("No description available")
//                    .font(.system(size: 15, weight: .regular))
//                    .foregroundColor(.gray.opacity(0.6))
//                    .italic()
//            }
//        }
//        .sheet(isPresented: $isShowingFullDescription) {
//            if let description = description, !description.isEmpty {
//                // 🔴 TESTE: WebView original desativada
//                /*
//                CharacterDetailWebSheet(
//                    htmlContent: description,
//                    isPresented: $isShowingFullDescription
//                )
//                */
//
//                // 🟢 Versão de teste SEM WebView (apenas texto limpo)
//                ScrollView {
//                    Text(makeFullText(from: description))
//                        .font(.system(size: 15, weight: .regular))
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
//                .background(Color.black.ignoresSafeArea())
//            }
//        }
//    }
//
//    // MARK: - Helpers
//
//    /// Limpa o HTML (remove tags, scripts, styles e entidades) sem truncar.
//    private func cleanHTML(_ html: String) -> String {
//        var cleaned = html
//
//        // Remove scripts e styles
//        cleaned = cleaned.replacingOccurrences(
//            of: "<script[^>]*>.*?</script>",
//            with: "",
//            options: [.regularExpression, .caseInsensitive]
//        )
//        cleaned = cleaned.replacingOccurrences(
//            of: "<style[^>]*>.*?</style>",
//            with: "",
//            options: [.regularExpression, .caseInsensitive]
//        )
//
//        // Remove todas as tags HTML
//        cleaned = cleaned.replacingOccurrences(
//            of: "<[^>]+>",
//            with: " ",
//            options: .regularExpression
//        )
//
//        // Decodifica entidades HTML comuns
//        cleaned = cleaned
//            .replacingOccurrences(of: "&amp;", with: "&")
//            .replacingOccurrences(of: "&lt;", with: "<")
//            .replacingOccurrences(of: "&gt;", with: ">")
//            .replacingOccurrences(of: "&quot;", with: "\"")
//            .replacingOccurrences(of: "&#39;", with: "'")
//            .replacingOccurrences(of: "&nbsp;", with: " ")
//            .replacingOccurrences(of: "&mdash;", with: "—")
//            .replacingOccurrences(of: "&ndash;", with: "–")
//
//        // Remove espaços extras
//        cleaned = cleaned.replacingOccurrences(
//            of: "\\s+",
//            with: " ",
//            options: .regularExpression
//        )
//
//        // Trim
//        cleaned = cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
//
//        return cleaned
//    }
//
//    /// Usado no preview: mesmo HTML limpo, mas com limite de caracteres.
//    private func makeSummary(from html: String) -> String {
//        var cleaned = cleanHTML(html)
//
//        // Limita o tamanho do preview
//        if cleaned.count > 200 {
//            let index = cleaned.index(cleaned.startIndex, offsetBy: 200)
//            // Tenta encontrar o fim da última palavra completa
//            if let lastSpace = cleaned[..<index].lastIndex(of: " ") {
//                cleaned = String(cleaned[..<lastSpace]) + "..."
//            } else {
//                cleaned = String(cleaned[..<index]) + "..."
//            }
//        }
//
//        return cleaned.isEmpty ? "No description available" : cleaned
//    }
//
//    /// Usado no sheet: texto completo, sem truncar.
//    private func makeFullText(from html: String) -> String {
//        let cleaned = cleanHTML(html)
//        return cleaned.isEmpty ? "No description available" : cleaned
//    }
//}
//import SwiftUI
//import DesignSystem
//
//public struct CharacterDetailDescriptionView: View {
//    // MARK: - Public Inputs
//    let deck: String?
//    let description: String?   // ainda aceitamos, mas NÃO usamos (para não quebrar chamadas)
//
//    public init(deck: String?, description: String?) {
//        self.deck = deck
//        self.description = description
//    }
//
//    public var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            // 🔵 Apenas o deck (resumo curto vindo da API, normalmente sem HTML)
//            if let deck = deck, !deck.isEmpty {
//                Text(deck)
//                    .font(.system(size: 16, weight: .regular))
//                    .foregroundColor(.white)
//                    .fixedSize(horizontal: false, vertical: true)
//            } else {
//                // 🔵 Fallback simples quando não há descrição nenhuma
//                Text("No description available")
//                    .font(.system(size: 15, weight: .regular))
//                    .foregroundColor(.gray.opacity(0.6))
//                    .italic()
//            }
//        }
//    }
//}
import SwiftUI
import DesignSystem

public struct CharacterDetailDescriptionView: View {
    // MARK: - Inputs
    let name: String
    let deck: String?
    let descriptionHTML: String?

    @State private var isShowingFullDescription = false

    public init(name: String, deck: String?, description: String?) {
        self.name = name
        self.deck = deck
        self.descriptionHTML = description
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 1) Na tela principal: só o deck
            if let deck, !deck.isEmpty {
                Text(deck)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // 2) Botão "View Full Description" se existir description
            if let descriptionHTML, !descriptionHTML.isEmpty {
                Button {
                    isShowingFullDescription = true
                } label: {
                    HStack(spacing: 4) {
                        Text("View Full Description")
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.red)
                }
                .padding(.top, 4)
                .accessibilityIdentifier("viewFullDescriptionButton")
            } else if deck == nil || deck?.isEmpty == true {
                // fallback quando não há deck nem description
                Text("No description available")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.gray.opacity(0.6))
                    .italic()
            }
        }
        // 3) Sheet com WebView formatado (DesignSystem.WebViewComponent)
        .sheet(isPresented: $isShowingFullDescription) {
            if let descriptionHTML, !descriptionHTML.isEmpty {
                DescriptionWebSheet(
                    html: descriptionHTML,
                    name: name
                )
            }
        }
    }
}

// MARK: - Sheet que usa o WebViewComponent do DesignSystem

private struct DescriptionWebSheet: View {
    let html: String
    let name: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            WebViewComponent(
                htmlContent: html,
                title: name
            )

            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
            }
        }
    }
}

