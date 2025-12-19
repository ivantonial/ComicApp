//
//  ComicVineAsyncImageComponent.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 13/10/25.
//

import ComicVineAPI
import SwiftUI

/// Contextos de uso para imagens
public enum ImageContext {
    case thumbnail
    case listItem
    case cardSmall
    case cardMedium
    case cardLarge
    case cardSquareSmall
    case cardSquareMedium
    case cardSquareLarge
    case heroImage
    case detailHeader
    case fullScreen
}

/// Componente otimizado para carregar imagens da ComicVine API
public struct ComicVineAsyncImageComponent: View {
    // MARK: - Properties
    private let comicVineImage: ComicVineImage?
    private let imageContext: ImageContext
    private let contentMode: ContentMode
    private let cornerRadius: CGFloat
    private let showLoadingIndicator: Bool
    private let fixedSize: CGSize?

    @State private var isImageLoaded = false
    @State private var hasError = false
    @State private var retryCount = 0
    @State private var autoRetryAttempts = 0
    @State private var retryTask: Task<Void, Never>?
    @ObservedObject private var themeManager = ThemeManager.shared

    // Configuração de retry
    private let maxAutoRetries = 3
    private let retryDelayNanoseconds: UInt64 = 1_500_000_000 // 1.5 segundos

    // MARK: - URL selection
    private var imageURL: URL? {
        guard let img = comicVineImage else { return nil }

        let urlString: String? = {
            switch imageContext {
            case .thumbnail, .listItem:
                // aqui sim faz sentido usar avatar/thumbnail
                return img.thumbUrl
                    ?? img.iconUrl
                    ?? img.smallUrl
                    ?? img.mediumUrl

            case .cardSmall:
                // Card retangular pequeno (se você usar em outra tela)
                return img.mediumUrl
                    ?? img.smallUrl
                    ?? img.screenUrl
                    ?? img.originalUrl

            case .cardMedium:
                // Card retangular médio (ex: HQ em portrait)
                return img.mediumUrl
                    ?? img.superUrl
                    ?? img.screenUrl
                    ?? img.originalUrl

            case .cardLarge:
                // Card retangular grande
                return img.superUrl
                    ?? img.screenLargeUrl
                    ?? img.screenUrl
                    ?? img.originalUrl

            case .cardSquareSmall,
                 .cardSquareMedium,
                 .cardSquareLarge:
                // 🔴 AQUI é o caso da sua lista de personagens
                // Volta a priorizar SEMPRE o screen (screen_medium),
                // que é justamente o recorte landscape mais consistente
                return img.originalUrl
                    ?? img.superUrl
                    ?? img.mediumUrl
                    ?? img.screenUrl
                    ?? img.screenLargeUrl

            case .heroImage, .detailHeader:
                // Headers / hero: recortes bem amplos
                return img.originalUrl
                    ?? img.screenLargeUrl
                    ?? img.superUrl

            case .fullScreen:
                // Tela cheia: sempre prioriza o original
                return img.originalUrl
                    ?? img.superUrl
                    ?? img.screenLargeUrl
            }
        }()

        guard let urlString else { return nil }

        let secureUrlString = urlString
            .replacingOccurrences(of: "http://", with: "https://")
            .replacingOccurrences(of: "https://https://", with: "https://")

        return URL(string: secureUrlString)
    }

    // MARK: - Initialization
    public init(
        comicVineImage: ComicVineImage?,
        context: ImageContext = .cardMedium,
        contentMode: ContentMode = .fill,
        cornerRadius: CGFloat = 0,
        showLoadingIndicator: Bool = true,
        fixedSize: CGSize? = nil
    ) {
        self.comicVineImage = comicVineImage
        self.imageContext = context
        self.contentMode = contentMode
        self.cornerRadius = cornerRadius
        self.showLoadingIndicator = showLoadingIndicator
        self.fixedSize = fixedSize
    }

    // MARK: - Body
    public var body: some View {
        AsyncImage(url: imageURL) { phase in
            switch phase {
            case .empty:
                if showLoadingIndicator {
                    loadingView
                } else {
                    placeholderView
                }

            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .frame(
                        width: fixedSize?.width,
                        height: fixedSize?.height
                    )
                    .clipped()
                    .cornerRadius(cornerRadius)
                    .onAppear {
                        // Cancela qualquer retry pendente ao carregar com sucesso
                        retryTask?.cancel()
                        retryTask = nil
                        isImageLoaded = true
                        hasError = false
                        autoRetryAttempts = 0
                    }

            case .failure:
                if autoRetryAttempts < maxAutoRetries {
                    loadingView
                        .onAppear {
                            scheduleAutoRetry()
                        }
                } else {
                    errorView
                        .onTapGesture {
                            performManualRetry()
                        }
                }

            @unknown default:
                placeholderView
            }
        }
        .frame(
            width: fixedSize?.width,
            height: fixedSize?.height
        )
        .id("\(comicVineImage?.originalUrl ?? "")-\(retryCount)")
        .onDisappear {
            // Isso evita re-renders desnecessários e travamento do scroll
            retryTask?.cancel()
            retryTask = nil
        }
    }

    // MARK: - Retry Logic
    private func scheduleAutoRetry() {
        guard autoRetryAttempts < maxAutoRetries else { return }
        guard retryTask == nil else { return } // Evita múltiplas tasks

        retryTask = Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: retryDelayNanoseconds)

                // Verifica se a task não foi cancelada
                guard !Task.isCancelled else { return }

                autoRetryAttempts += 1
                retryCount += 1
                retryTask = nil
            } catch {
                // Task foi cancelada, não faz nada
                retryTask = nil
            }
        }
    }

    private func performManualRetry() {
        retryTask?.cancel()
        retryTask = nil
        autoRetryAttempts = 0
        retryCount += 1
    }

    // MARK: - View Components
    private var loadingView: some View {
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            themeManager.currentTheme.tertiaryBackground.opacity(0.3),
                            themeManager.currentTheme.tertiaryBackground.opacity(0.1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            ProgressView()
                .tint(themeManager.currentTheme.primaryAccent)
                .scaleEffect(0.8)
        }
        .frame(
            width: fixedSize?.width,
            height: fixedSize?.height
        )
    }

    private var placeholderView: some View {
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            themeManager.currentTheme.tertiaryBackground.opacity(0.3),
                            themeManager.currentTheme.tertiaryBackground.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Image(systemName: iconForContext)
                .font(.system(size: iconSize))
                .foregroundColor(themeManager.currentTheme.tertiaryText.opacity(0.5))
        }
        .frame(
            width: fixedSize?.width,
            height: fixedSize?.height
        )
    }

    private var errorView: some View {
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            themeManager.currentTheme.destructiveAccent.opacity(0.2),
                            themeManager.currentTheme.destructiveAccent.opacity(0.1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: iconSize * 0.8))
                    .foregroundColor(themeManager.currentTheme.destructiveAccent.opacity(0.7))

                Text("Tap to retry")
                    .font(.caption2)
                    .foregroundColor(themeManager.currentTheme.secondaryText)
            }
        }
        .frame(
            width: fixedSize?.width,
            height: fixedSize?.height
        )
    }

    // MARK: - Helper Properties
    private var iconForContext: String {
        switch imageContext {
        case .thumbnail, .listItem:
            return "person.circle.fill"
        case .cardSmall, .cardMedium, .cardLarge:
            // Comics (portrait)
            return "book.closed.fill"
        case .cardSquareSmall, .cardSquareMedium, .cardSquareLarge:
            // Characters (square)
            return "person.crop.square.fill"
        case .heroImage, .detailHeader:
            return "photo.fill"
        case .fullScreen:
            return "photo.fill.on.rectangle.fill"
        }
    }

    private var iconSize: CGFloat {
        switch imageContext {
        case .thumbnail:
            return 20
        case .listItem:
            return 24
        case .cardSmall, .cardSquareSmall:
            return 30
        case .cardMedium, .cardSquareMedium:
            return 40
        case .cardLarge, .cardSquareLarge:
            return 50
        case .heroImage, .detailHeader:
            return 60
        case .fullScreen:
            return 80
        }
    }
}

// MARK: - Scaling Modifier
private struct ScalingModifier: ViewModifier {
    let mode: ContentMode

    func body(content: Content) -> some View {
        switch mode {
        case .fill:
            content
                .scaledToFill()
        case .fit:
            content
                .scaledToFit()
        @unknown default:
            content
                .scaledToFill()
        }
    }
}

// MARK: - Convenience Initializers
public extension ComicVineAsyncImageComponent {
    /// Inicializador para thumbnails pequenos
    static func thumbnail(
        _ comicVineImage: ComicVineImage?,
        cornerRadius: CGFloat = 8
    ) -> ComicVineAsyncImageComponent {
        ComicVineAsyncImageComponent(
            comicVineImage: comicVineImage,
            context: .thumbnail,
            cornerRadius: cornerRadius
        )
    }

    /// Inicializador para cards com tamanho fixo
    static func card(
        _ comicVineImage: ComicVineImage?,
        size: CardSize = .medium,
        isPortrait: Bool = false,
        cornerRadius: CGFloat = 0,
        fixedSize: CGSize? = nil
    ) -> ComicVineAsyncImageComponent {
        let context: ImageContext = {
            if isPortrait {
                switch size {
                case .small: return .cardSmall
                case .medium: return .cardMedium
                case .large: return .cardLarge
                }
            } else {
                switch size {
                case .small: return .cardSquareSmall
                case .medium: return .cardSquareMedium
                case .large: return .cardSquareLarge
                }
            }
        }()

        return ComicVineAsyncImageComponent(
            comicVineImage: comicVineImage,
            context: context,
            cornerRadius: cornerRadius,
            fixedSize: fixedSize
        )
    }

    /// Inicializador para imagem de cabeçalho
    static func header(
        _ comicVineImage: ComicVineImage?
    ) -> ComicVineAsyncImageComponent {
        ComicVineAsyncImageComponent(
            comicVineImage: comicVineImage,
            context: .detailHeader,
            contentMode: .fill
        )
    }

    enum CardSize {
        case small, medium, large
    }
}
