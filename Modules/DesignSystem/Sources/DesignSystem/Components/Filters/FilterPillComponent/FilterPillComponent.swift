//
//  FilterPillComponent.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 10/10/25.
//

import SwiftUI

/// Estilo visual do FilterPill
public enum FilterPillStyle {
    case primary    // Fundo preenchido quando selecionado
    case outlined   // Apenas borda
    case minimal    // Sem borda, apenas mudança de cor
}

/// Componente de filtro em formato pill reutilizável
public struct FilterPillComponent: View {
    // MARK: - Properties
    public let title: String
    public let icon: String?
    public let isSelected: Bool
    public let style: FilterPillStyle
    public let useThemeColors: Bool  // Nova propriedade para usar cores do tema
    public let customSelectedColor: Color?  // Cor customizada opcional
    public let action: () -> Void

    @ObservedObject private var themeManager = ThemeManager.shared

    // MARK: - Initialization
    public init(
        title: String,
        icon: String? = nil,
        isSelected: Bool,
        style: FilterPillStyle = .primary,
        useThemeColors: Bool = true,  // Por padrão usa cores do tema
        customSelectedColor: Color? = nil,  // Permite cor customizada se necessário
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.style = style
        self.useThemeColors = useThemeColors
        self.customSelectedColor = customSelectedColor
        self.action = action
    }

    // Mantém inicializador antigo para compatibilidade
    public init(
        title: String,
        icon: String? = nil,
        isSelected: Bool,
        style: FilterPillStyle = .primary,
        selectedColor: Color = .red,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.style = style
        self.useThemeColors = false
        self.customSelectedColor = selectedColor
        self.action = action
    }

    // MARK: - Body
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                }

                Text(title)
                    .font(.caption)
                    .fontWeight(isSelected ? .medium : .regular)
            }
            .foregroundColor(foregroundColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(backgroundView)
            .overlay(overlayView)
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }

    // MARK: - Computed Properties
    private var selectedColor: Color {
        if useThemeColors {
            return themeManager.currentTheme.primaryAccent
        } else {
            return customSelectedColor ?? .red
        }
    }

    private var foregroundColor: Color {
        if useThemeColors {
            switch style {
            case .primary:
                return isSelected ?
                    themeManager.currentTheme.primaryBackground :
                    themeManager.currentTheme.primaryText
            case .outlined, .minimal:
                return isSelected ?
                    themeManager.currentTheme.primaryAccent :
                    themeManager.currentTheme.tertiaryText
            }
        } else {
            // Comportamento anterior para compatibilidade
            switch style {
            case .primary:
                return isSelected ? .black : .white
            case .outlined, .minimal:
                return isSelected ? selectedColor : .gray
            }
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        if useThemeColors {
            switch style {
            case .primary:
                Capsule()
                    .fill(
                        isSelected ?
                        themeManager.currentTheme.primaryAccent :
                        themeManager.currentTheme.secondaryBackground
                    )
            case .outlined:
                Capsule()
                    .fill(Color.clear)
            case .minimal:
                Color.clear
            }
        } else {
            // Comportamento anterior para compatibilidade
            switch style {
            case .primary:
                Capsule()
                    .fill(isSelected ? selectedColor : Color.white.opacity(0.1))
            case .outlined:
                Capsule()
                    .fill(Color.clear)
            case .minimal:
                Color.clear
            }
        }
    }

    @ViewBuilder
    private var overlayView: some View {
        switch style {
        case .primary:
            EmptyView()
        case .outlined:
            if useThemeColors {
                Capsule()
                    .stroke(
                        isSelected ?
                        themeManager.currentTheme.primaryAccent :
                        themeManager.currentTheme.borderColor,
                        lineWidth: 1
                    )
            } else {
                Capsule()
                    .stroke(
                        isSelected ? selectedColor : Color.gray.opacity(0.3),
                        lineWidth: 1
                    )
            }
        case .minimal:
            EmptyView()
        }
    }
}

// MARK: - Preview
#if DEBUG
struct FilterPillComponent_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Teste com tema
            HStack {
                FilterPillComponent(
                    title: "Heroes",
                    icon: "person.fill",
                    isSelected: true,
                    style: .primary,
                    useThemeColors: true,
                    action: {}
                )

                FilterPillComponent(
                    title: "Villains",
                    icon: "person.fill.xmark",
                    isSelected: false,
                    style: .primary,
                    useThemeColors: true,
                    action: {}
                )
            }

            // Teste com cor customizada
            HStack {
                FilterPillComponent(
                    title: "Teams",
                    icon: "person.3.fill",
                    isSelected: true,
                    style: .outlined,
                    selectedColor: .blue,
                    action: {}
                )

                FilterPillComponent(
                    title: "All",
                    isSelected: false,
                    style: .minimal,
                    selectedColor: .green,
                    action: {}
                )
            }
        }
        .padding()
        .background(Color.black)
        .environment(\.colorScheme, .dark)
    }
}
#endif
