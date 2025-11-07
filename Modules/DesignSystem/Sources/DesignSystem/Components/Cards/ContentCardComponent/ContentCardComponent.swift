//
//  ContentCardComponent.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 13/10/25.
//

import ComicVineAPI
import SwiftUI

// MARK: - Card Configuration Model
public struct ContentCardModel: Identifiable {
    public let id: Int
    public let title: String
    public let subtitle: String?
    public let imageURL: URL?
    public let comicVineImage: ComicVineImage?
    public let aspectRatio: CGFloat
    public let contentMode: ContentMode
    public let badge: BadgeModel?
    public let fixedHeight: CGFloat? // Nova propriedade para altura fixa

    public struct BadgeModel {
        public let icon: String
        public let text: String
        public let color: Color

        public init(icon: String, text: String, color: Color = .gray) {
            self.icon = icon
            self.text = text
            self.color = color
        }
    }

    // MARK: - Initializers
    public init(
        id: Int,
        title: String,
        subtitle: String? = nil,
        imageURL: URL?,
        aspectRatio: CGFloat = 1.0,
        contentMode: ContentMode = .fill,
        badge: BadgeModel? = nil,
        fixedHeight: CGFloat? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.comicVineImage = nil
        self.aspectRatio = aspectRatio
        self.contentMode = contentMode
        self.badge = badge
        self.fixedHeight = fixedHeight
    }

    public init(
        id: Int,
        title: String,
        subtitle: String? = nil,
        comicVineImage: ComicVineImage?,
        aspectRatio: CGFloat = 1.0,
        contentMode: ContentMode = .fill,
        badge: BadgeModel? = nil,
        fixedHeight: CGFloat? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.imageURL = nil
        self.comicVineImage = comicVineImage
        self.aspectRatio = aspectRatio
        self.contentMode = contentMode
        self.badge = badge
        self.fixedHeight = fixedHeight
    }
}

// MARK: - Content Card Component
public struct ContentCardComponent: View {
    private let model: ContentCardModel
    private let onTap: (() -> Void)?

    @State private var isPressed = false
    @State private var retryCount = 0

    public init(model: ContentCardModel, onTap: (() -> Void)? = nil) {
        self.model = model
        self.onTap = onTap
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Container da imagem com proporção fixa
            imageContainer
                .aspectRatio(model.aspectRatio, contentMode: .fill)
                .clipped()
                .cornerRadius(12, corners: [.topLeft, .topRight])

            cardInfo
        }
        .frame(height: model.fixedHeight) // Aplica altura fixa se especificada
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .red.opacity(0.2), radius: 5, x: 0, y: 2)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .contentShape(Rectangle())
        .onTapGesture {
            animateTap {
                onTap?()
            }
        }
    }

    // MARK: - Image Container
    @ViewBuilder
    private var imageContainer: some View {
        GeometryReader { geometry in
            ZStack {
                // Background sempre presente para manter proporção
                placeholderBackground

                // Conteúdo da imagem
                if let comicVineImage = model.comicVineImage {
                    ComicVineAsyncImageComponent(
                        comicVineImage: comicVineImage,
                        context: determineImageContext(),
                        contentMode: model.contentMode,
                        cornerRadius: 0,
                        fixedSize: geometry.size // Passa o tamanho fixo
                    )
                } else if let imageURL = model.imageURL {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            loadingView
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: model.contentMode)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                        case .failure:
                            errorViewWithRetry
                        @unknown default:
                            errorView
                        }
                    }
                    .id(retryCount)
                } else {
                    errorView
                }
            }
        }
    }

    // MARK: - Context Detection
    private func determineImageContext() -> ImageContext {
        switch model.aspectRatio {
        case 0.6...0.8:  // Portrait (comics) - ~0.67
            return .cardMedium
        case 0.9...1.1:  // Square (characters) - 1.0
            return .cardSquareMedium
        case 1.5...2.0:  // Landscape
            return .heroImage
        default:
            return .cardSquareMedium
        }
    }

    // MARK: - Helpers
    private func animateTap(_ action: @escaping () -> Void) {
        withAnimation(.easeInOut(duration: 0.1)) {
            isPressed = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = false
            }
            action()
        }
    }

    // MARK: - Loading View
    private var loadingView: some View {
        ZStack {
            placeholderBackground

            ProgressView()
                .tint(.red)
                .scaleEffect(0.8)
        }
    }

    // MARK: - Error Views
    private var errorView: some View {
        ZStack {
            placeholderBackground

            Image(systemName: placeholderIcon)
                .font(.system(size: placeholderIconSize))
                .foregroundColor(.gray.opacity(0.5))
        }
    }

    private var errorViewWithRetry: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.red.opacity(0.2),
                    Color.red.opacity(0.1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: placeholderIconSize * 0.8))
                    .foregroundColor(.red.opacity(0.7))

                Text("Tap to retry")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .onTapGesture {
            retryCount += 1
        }
    }

    private var placeholderBackground: some View {
        LinearGradient(
            colors: [
                Color.gray.opacity(0.3),
                Color.gray.opacity(0.1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var placeholderIcon: String {
        switch model.aspectRatio {
        case 0.6...0.8: return "book.closed.fill"
        case 0.9...1.1: return "person.crop.square.fill"
        default: return "photo"
        }
    }

    private var placeholderIconSize: CGFloat {
        switch model.aspectRatio {
        case 0.6...0.8: return 40
        case 0.9...1.1: return 36
        default: return 32
        }
    }

    // MARK: - Info Section
    private var cardInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(model.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.9)
                .fixedSize(horizontal: false, vertical: true)

            if let subtitle = model.subtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            } else if let badge = model.badge {
                HStack(spacing: 4) {
                    Image(systemName: badge.icon)
                        .font(.system(size: 10, weight: .medium))

                    Text(badge.text)
                        .font(.caption2)
                        .fontWeight(.medium)
                }
                .foregroundColor(badge.color)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(badge.color.opacity(0.2))
                .cornerRadius(4)
            }

            // Caso tenha subtitle E badge
            if model.badge != nil && model.subtitle != nil {
                HStack(spacing: 4) {
                    Image(systemName: model.badge!.icon)
                        .font(.system(size: 10, weight: .medium))

                    Text(model.badge!.text)
                        .font(.caption2)
                        .fontWeight(.medium)
                }
                .foregroundColor(model.badge!.color)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(model.badge!.color.opacity(0.2))
                .cornerRadius(4)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading) // Altura mínima para a info
        .background(
            LinearGradient(
                colors: [
                    Color.black,
                    Color.black.opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
