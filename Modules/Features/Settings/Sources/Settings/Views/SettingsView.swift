//
//  SettingsView.swift
//  Settings
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

//import Core
//import DesignSystem
//import SwiftUI
//
//public struct SettingsView: View {
//    // MARK: - Properties
//    @StateObject private var viewModel: SettingsViewModel
//    @State private var showingShareSheet = false
//
//    // MARK: - Initialization
//    public init(viewModel: SettingsViewModel) {
//        self._viewModel = StateObject(wrappedValue: viewModel)
//    }
//
//    // MARK: - Body
//    public var body: some View {
//        NavigationStack {
//            List {
//                generalSection
//                displaySection
//                dataStorageSection
//                aboutSection
//                supportSection
//                legalSection
//
//                #if DEBUG
//                developerSection
//                #endif
//            }
//            .listStyle(.insetGrouped)
//            .navigationTitle("Settings")
//            .alert("Clear Cache", isPresented: $viewModel.showingClearCacheAlert) {
//                Button("Cancel", role: .cancel) {}
//                Button("Clear", role: .destructive) { viewModel.clearCache() }
//            } message: {
//                Text("This will delete all cached images and data. The app will need to download content again.")
//            }
//            .alert("Reset Settings", isPresented: $viewModel.showingResetAlert) {
//                Button("Cancel", role: .cancel) {}
//                Button("Reset", role: .destructive) { viewModel.resetSettings() }
//            } message: {
//                Text("This will reset all settings to their default values and clear your favorites and search history.")
//            }
//            .sheet(isPresented: $showingShareSheet) {
//                ShareSheetView(items: viewModel.shareApp())
//            }
//        }
//    }
//
//    // MARK: - General Section
//    private var generalSection: some View {
//        Section {
//            Toggle(isOn: $viewModel.isNotificationsEnabled) {
//                Label {
//                    VStack(alignment: .leading, spacing: 2) {
//                        Text("Notifications")
//                        Text(viewModel.notificationStatusText)
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//                } icon: {
//                    Image(systemName: "bell.fill")
//                        .foregroundColor(.red)
//                }
//            }
//            .onChange(of: viewModel.isNotificationsEnabled) { _ in
//                viewModel.toggleNotifications()
//            }
//
//            Toggle(isOn: $viewModel.isDarkModeEnabled) {
//                Label {
//                    VStack(alignment: .leading, spacing: 2) {
//                        Text("Dark Mode")
//                        Text("Use dark theme")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//                } icon: {
//                    Image(systemName: "moon.fill")
//                        .foregroundColor(.indigo)
//                }
//            }
//            .onChange(of: viewModel.isDarkModeEnabled) { newValue in
//                viewModel.applyTheme(isDark: newValue)
//            }
//        } header: {
//            SettingsSectionHeaderView(title: "General", systemImage: "gearshape.fill", color: .secondary)
//        }
//    }
//
//    // MARK: - Display Section
//    private var displaySection: some View {
//        Section {
//            Picker(selection: $viewModel.imageQuality) {
//                ForEach(ImageQuality.allCases, id: \.self) { quality in
//                    VStack(alignment: .leading) {
//                        Text(quality.title)
//                        Text(quality.description)
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//                    .tag(quality)
//                }
//            } label: {
//                Label {
//                    VStack(alignment: .leading, spacing: 2) {
//                        Text("Image Quality")
//                        Text(viewModel.imageQuality.title)
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//                } icon: {
//                    Image(systemName: "photo.fill")
//                        .foregroundColor(.blue)
//                }
//            }
//            .onChange(of: viewModel.imageQuality) { newValue in
//                viewModel.updateImageQuality(newValue)
//            }
//
//            Toggle(isOn: $viewModel.isAutoPlayVideosEnabled) {
//                Label {
//                    VStack(alignment: .leading, spacing: 2) {
//                        Text("Auto-play Videos")
//                        Text("Play videos automatically")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//                } icon: {
//                    Image(systemName: "play.circle.fill")
//                        .foregroundColor(.green)
//                }
//            }
//            .onChange(of: viewModel.isAutoPlayVideosEnabled) { _ in
//                viewModel.toggleAutoPlayVideos()
//            }
//        } header: {
//            SettingsSectionHeaderView(title: "Display", systemImage: "display", color: .secondary)
//        }
//    }
//
//    // MARK: - Data & Storage Section
//    private var dataStorageSection: some View {
//        Section {
//            HStack {
//                Label {
//                    VStack(alignment: .leading, spacing: 2) {
//                        Text("Cache Size")
//                        Text(viewModel.cacheStatusText)
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//                } icon: {
//                    Image(systemName: "externaldrive.fill")
//                        .foregroundColor(.orange)
//                }
//
//                Spacer()
//
//                Button("Clear") { viewModel.showingClearCacheAlert = true }
//                    .buttonStyle(.bordered)
//                    .controlSize(.small)
//            }
//
//            Button {
//                viewModel.showingResetAlert = true
//            } label: {
//                Label {
//                    Text("Reset All Settings")
//                        .foregroundColor(.red)
//                } icon: {
//                    Image(systemName: "arrow.counterclockwise")
//                        .foregroundColor(.red)
//                }
//            }
//        } header: {
//            SettingsSectionHeaderView(title: "Data & Storage", systemImage: "externaldrive", color: .secondary)
//        }
//    }
//
//    // MARK: - About Section
//    private var aboutSection: some View {
//        Section {
//            HStack {
//                Label("Version", systemImage: "info.circle.fill")
//                    .foregroundColor(.blue)
//                Spacer()
//                Text(viewModel.appVersion)
//                    .foregroundColor(.secondary)
//            }
//
//            HStack {
//                Label("Build", systemImage: "hammer.fill")
//                    .foregroundColor(.gray)
//                Spacer()
//                Text(viewModel.buildNumber)
//                    .foregroundColor(.secondary)
//            }
//
//            Button { viewModel.rateApp() } label: {
//                Label {
//                    Text("Rate ComicApp")
//                        .foregroundColor(.primary)
//                } icon: {
//                    Image(systemName: "star.fill")
//                        .foregroundColor(.yellow)
//                }
//            }
//
//            Button { showingShareSheet = true } label: {
//                Label {
//                    Text("Share ComicApp")
//                        .foregroundColor(.primary)
//                } icon: {
//                    Image(systemName: "square.and.arrow.up")
//                        .foregroundColor(.blue)
//                }
//            }
//        } header: {
//            SettingsSectionHeaderView(title: "About", systemImage: "info.circle", color: .secondary)
//        }
//    }
//
//    // MARK: - Support Section
//    private var supportSection: some View {
//        Section {
//            Button { viewModel.contactSupport() } label: {
//                Label {
//                    Text("Contact Support")
//                        .foregroundColor(.primary)
//                } icon: {
//                    Image(systemName: "envelope.fill")
//                        .foregroundColor(.blue)
//                }
//            }
//
//            Button { viewModel.reportBug() } label: {
//                Label {
//                    Text("Report a Bug")
//                        .foregroundColor(.primary)
//                } icon: {
//                    Image(systemName: "ladybug.fill")
//                        .foregroundColor(.red)
//                }
//            }
//
//            Link(destination: URL(string: "https://comicapp.com/faq")!) {
//                Label {
//                    HStack {
//                        Text("FAQ")
//                            .foregroundColor(.primary)
//                        Spacer()
//                        Image(systemName: "arrow.up.right.square")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//                } icon: {
//                    Image(systemName: "questionmark.circle.fill")
//                        .foregroundColor(.green)
//                }
//            }
//        } header: {
//            SettingsSectionHeaderView(title: "Support", systemImage: "questionmark.circle", color: .secondary)
//        }
//    }
//
//    // MARK: - Legal Section
//    private var legalSection: some View {
//        Section {
//            Button { viewModel.openPrivacyPolicy() } label: {
//                Label {
//                    HStack {
//                        Text("Privacy Policy")
//                            .foregroundColor(.primary)
//                        Spacer()
//                        Image(systemName: "arrow.up.right.square")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//                } icon: {
//                    Image(systemName: "lock.fill")
//                        .foregroundColor(.purple)
//                }
//            }
//
//            Button { viewModel.openTermsOfService() } label: {
//                Label {
//                    HStack {
//                        Text("Terms of Service")
//                            .foregroundColor(.primary)
//                        Spacer()
//                        Image(systemName: "arrow.up.right.square")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//                } icon: {
//                    Image(systemName: "doc.text.fill")
//                        .foregroundColor(.orange)
//                }
//            }
//
//            HStack {
//                Label {
//                    VStack(alignment: .leading) {
//                        Text("Data © ComicsVine")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                        Text("© 2025 ComicsVine")
//                            .font(.caption2)
//                            .foregroundColor(.secondary)
//                    }
//                } icon: {
//                    Image(systemName: "c.circle.fill")
//                        .foregroundColor(.gray)
//                }
//            }
//        } header: {
//            SettingsSectionHeaderView(title: "Legal", systemImage: "doc.text", color: .secondary)
//        }
//    }
//
//    // MARK: - Developer Section (Debug Only)
//    #if DEBUG
//    private var developerSection: some View {
//        Section {
//            HStack {
//                Label("API Status", systemImage: "network")
//                    .foregroundColor(.blue)
//                Spacer()
//                HStack(spacing: 8) {
//                    Circle()
//                        .fill(viewModel.apiStatus.color)
//                        .frame(width: 8, height: 8)
//                    Text(viewModel.apiStatus.text)
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                }
//            }
//
//            Button {
//                fatalError("Test crash")
//            } label: {
//                Label {
//                    Text("Force Crash")
//                        .foregroundColor(.red)
//                } icon: {
//                    Image(systemName: "exclamationmark.triangle.fill")
//                        .foregroundColor(.red)
//                }
//            }
//        } header: {
//            SettingsSectionHeaderView(title: "Developer", systemImage: "hammer.fill", color: .secondary)
//        }
//    }
//    #endif
//}
import Core
import DesignSystem
import SwiftUI

public struct SettingsView: View {
    // MARK: - Properties
    @StateObject private var viewModel: SettingsViewModel
    @State private var showingShareSheet = false
    @State private var showingCacheDetailsSheet = false
    @ObservedObject private var themeManager = ThemeManager.shared

    // MARK: - Initialization
    public init(viewModel: SettingsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Body
    public var body: some View {
        NavigationStack {
            List {
                generalSection
                displaySection
                dataStorageSection
                aboutSection
                supportSection
                legalSection

                #if DEBUG
                developerSection
                #endif
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
            .alert("Clear Cache", isPresented: $viewModel.showingClearCacheAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Clear All", role: .destructive) {
                    viewModel.clearCache()
                }
            } message: {
                Text("This will delete all cached images and data. The app will need to download content again.")
            }
            .alert("Reset Settings", isPresented: $viewModel.showingResetAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) { viewModel.resetSettings() }
            } message: {
                Text("This will reset all settings to their default values and clear your favorites, search history, and all cached data.")
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheetView(items: viewModel.shareApp())
            }
            .sheet(isPresented: $showingCacheDetailsSheet) {
                CacheDetailsView(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    // MARK: - General Section
    private var generalSection: some View {
        Section {
            Toggle(isOn: $viewModel.isNotificationsEnabled) {
                Label {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Notifications")
                        Text(viewModel.notificationStatusText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } icon: {
                    Image(systemName: "bell.fill")
                        .foregroundColor(.red)
                }
            }
            .onChange(of: viewModel.isNotificationsEnabled) { _ in
                viewModel.toggleNotifications()
            }

            Toggle(isOn: $viewModel.isDarkModeEnabled) {
                Label {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Dark Mode")
                        Text("Use dark theme")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } icon: {
                    Image(systemName: "moon.fill")
                        .foregroundColor(.indigo)
                }
            }
            .onChange(of: viewModel.isDarkModeEnabled) { newValue in
                viewModel.applyTheme(isDark: newValue)
            }
        } header: {
            SettingsSectionHeaderView(title: "General", systemImage: "gearshape.fill", color: .secondary)
        }
    }

    // MARK: - Display Section
    private var displaySection: some View {
        Section {
            Picker(selection: $viewModel.imageQuality) {
                ForEach(ImageQuality.allCases, id: \.self) { quality in
                    VStack(alignment: .leading) {
                        Text(quality.title)
                        Text(quality.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .tag(quality)
                }
            } label: {
                Label {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Image Quality")
                        Text(viewModel.imageQuality.title)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } icon: {
                    Image(systemName: "photo.fill")
                        .foregroundColor(.blue)
                }
            }
            .onChange(of: viewModel.imageQuality) { newValue in
                viewModel.updateImageQuality(newValue)
            }

            Toggle(isOn: $viewModel.isAutoPlayVideosEnabled) {
                Label {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Auto-play Videos")
                        Text("Play videos automatically")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } icon: {
                    Image(systemName: "play.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .onChange(of: viewModel.isAutoPlayVideosEnabled) { _ in
                viewModel.toggleAutoPlayVideos()
            }
        } header: {
            SettingsSectionHeaderView(title: "Display", systemImage: "display", color: .secondary)
        }
    }

    // MARK: - Data & Storage Section
    private var dataStorageSection: some View {
        Section {
            // Cache Size Row com visual aprimorado
            Button(action: { showingCacheDetailsSheet = true }) {
                HStack(spacing: 12) {
                    Label {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 4) {
                                Text("Cache Size")
                                    .foregroundColor(themeManager.currentTheme.primaryText)

                                if viewModel.isCalculatingCache {
                                    ProgressView()
                                        .scaleEffect(0.7)
                                        .frame(width: 14, height: 14)
                                }
                            }

                            if !viewModel.cacheDetails.isEmpty {
                                Text(viewModel.cacheDetails)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            } else if let lastUpdate = viewModel.formattedLastUpdate {
                                Text(lastUpdate)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    } icon: {
                        ZStack {
                            Image(systemName: "externaldrive.fill")
                                .foregroundColor(.orange)

                            if viewModel.isClearingCache {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(0.6)
                                    .background(
                                        Circle()
                                            .fill(themeManager.currentTheme.secondaryBackground)
                                            .frame(width: 20, height: 20)
                                    )
                            }
                        }
                    }

                    Spacer()

                    HStack(spacing: 8) {
                        // Cache size badge
                        Text(viewModel.cacheSize)
                            .font(.system(.footnote, design: .monospaced))
                            .fontWeight(.medium)
                            .foregroundColor(getCacheSizeColor())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(getCacheSizeColor().opacity(0.15))
                            )

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isCalculatingCache || viewModel.isClearingCache)

            // Clear Cache Button
            Button {
                viewModel.showingClearCacheAlert = true
            } label: {
                HStack {
                    Label {
                        Text("Clear All Cache")
                            .foregroundColor(viewModel.canClearCache ? themeManager.currentTheme.destructiveAccent : .secondary)
                    } icon: {
                        Image(systemName: "trash")
                            .foregroundColor(viewModel.canClearCache ? themeManager.currentTheme.destructiveAccent : .secondary)
                    }

                    Spacer()

                    if viewModel.isClearingCache {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                }
            }
            .disabled(!viewModel.canClearCache)

            // Reset All Settings
            Button {
                viewModel.showingResetAlert = true
            } label: {
                Label {
                    Text("Reset All Settings")
                        .foregroundColor(.red)
                } icon: {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(.red)
                }
            }
        } header: {
            SettingsSectionHeaderView(title: "Data & Storage", systemImage: "externaldrive", color: .secondary)
        } footer: {
            if let breakdown = viewModel.cacheBreakdown, breakdown.hasDetails {
                Text("Tap cache size for detailed breakdown")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }

    // MARK: - About Section
    private var aboutSection: some View {
        Section {
            HStack {
                Label("Version", systemImage: "info.circle.fill")
                    .foregroundColor(.blue)
                Spacer()
                Text(viewModel.appVersion)
                    .foregroundColor(.secondary)
            }

            HStack {
                Label("Build", systemImage: "hammer.fill")
                    .foregroundColor(.gray)
                Spacer()
                Text(viewModel.buildNumber)
                    .foregroundColor(.secondary)
            }

            Button { viewModel.rateApp() } label: {
                Label {
                    Text("Rate ComicApp")
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }

            Button { showingShareSheet = true } label: {
                Label {
                    Text("Share ComicApp")
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.blue)
                }
            }
        } header: {
            SettingsSectionHeaderView(title: "About", systemImage: "info.circle", color: .secondary)
        }
    }

    // MARK: - Support Section
    private var supportSection: some View {
        Section {
            Button { viewModel.contactSupport() } label: {
                Label {
                    Text("Contact Support")
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.blue)
                }
            }

            Button { viewModel.reportBug() } label: {
                Label {
                    Text("Report a Bug")
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "ladybug.fill")
                        .foregroundColor(.red)
                }
            }

            Link(destination: URL(string: "https://comicapp.com/faq")!) {
                Label {
                    HStack {
                        Text("FAQ")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } icon: {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
        } header: {
            SettingsSectionHeaderView(title: "Support", systemImage: "questionmark.circle", color: .secondary)
        }
    }

    // MARK: - Legal Section
    private var legalSection: some View {
        Section {
            Button { viewModel.openPrivacyPolicy() } label: {
                Label {
                    HStack {
                        Text("Privacy Policy")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } icon: {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.purple)
                }
            }

            Button { viewModel.openTermsOfService() } label: {
                Label {
                    HStack {
                        Text("Terms of Service")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } icon: {
                    Image(systemName: "doc.text.fill")
                        .foregroundColor(.orange)
                }
            }

            HStack {
                Label {
                    VStack(alignment: .leading) {
                        Text("Data © ComicsVine")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("© 2025 ComicsVine")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                } icon: {
                    Image(systemName: "c.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        } header: {
            SettingsSectionHeaderView(title: "Legal", systemImage: "doc.text", color: .secondary)
        }
    }

    // MARK: - Developer Section (Debug Only)
    #if DEBUG
    private var developerSection: some View {
        Section {
            HStack {
                Label("API Status", systemImage: "network")
                    .foregroundColor(.blue)
                Spacer()
                HStack(spacing: 8) {
                    Circle()
                        .fill(viewModel.apiStatus.color)
                        .frame(width: 8, height: 8)
                    Text(viewModel.apiStatus.text)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            // Quick Cache Actions for testing
            HStack {
                Label("Quick Actions", systemImage: "bolt.fill")
                    .foregroundColor(.orange)
                Spacer()

                HStack(spacing: 8) {
                    Button("Refresh") {
                        viewModel.refreshCacheSize()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.mini)

                    Button("Clear") {
                        viewModel.clearCache()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.mini)
                    .tint(.red)
                }
            }

            Button {
                fatalError("Test crash")
            } label: {
                Label {
                    Text("Force Crash")
                        .foregroundColor(.red)
                } icon: {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                }
            }
        } header: {
            SettingsSectionHeaderView(title: "Developer", systemImage: "hammer.fill", color: .secondary)
        }
    }
    #endif

    // MARK: - Helper Methods
    private func getCacheSizeColor() -> Color {
        guard let cacheBreakdown = viewModel.cacheBreakdown else {
            return themeManager.currentTheme.primaryText
        }

        let totalMB = Double(cacheBreakdown.managedCache + cacheBreakdown.imageCache +
                           cacheBreakdown.systemCache + cacheBreakdown.temporaryFiles +
                           cacheBreakdown.coreDataCache) / (1024 * 1024)

        switch totalMB {
        case 0..<50:
            return .green
        case 50..<200:
            return .orange
        default:
            return .red
        }
    }
}

// MARK: - Cache Details View
struct CacheDetailsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some View {
        NavigationStack {
            List {
                // Summary Section
                Section {
                    HStack {
                        Label("Total Cache", systemImage: "externaldrive.fill")
                            .foregroundColor(.orange)
                        Spacer()
                        Text(viewModel.cacheSize)
                            .font(.system(.body, design: .monospaced))
                            .fontWeight(.semibold)
                    }

                    if let lastUpdate = viewModel.formattedLastUpdate {
                        HStack {
                            Label("Last Updated", systemImage: "clock.fill")
                                .foregroundColor(.blue)
                            Spacer()
                            Text(lastUpdate)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Summary")
                }

                // Breakdown Section
                if let breakdown = viewModel.cacheBreakdown {
                    Section {
                        if breakdown.imageCache > 0 {
                            CacheBreakdownRow(
                                title: "Images",
                                size: breakdown.imageCache,
                                icon: "photo.fill",
                                color: .blue
                            )
                        }

                        if breakdown.managedCache > 0 {
                            CacheBreakdownRow(
                                title: "App Data",
                                size: breakdown.managedCache,
                                icon: "square.and.arrow.down.fill",
                                color: .green
                            )
                        }

                        if breakdown.coreDataCache > 0 {
                            CacheBreakdownRow(
                                title: "Database",
                                size: breakdown.coreDataCache,
                                icon: "cylinder.fill",
                                color: .purple
                            )
                        }

                        if breakdown.systemCache > 0 {
                            CacheBreakdownRow(
                                title: "System Cache",
                                size: breakdown.systemCache,
                                icon: "gear",
                                color: .gray
                            )
                        }

                        if breakdown.temporaryFiles > 0 {
                            CacheBreakdownRow(
                                title: "Temporary Files",
                                size: breakdown.temporaryFiles,
                                icon: "clock.arrow.circlepath",
                                color: .orange
                            )
                        }
                    } header: {
                        Text("Cache Breakdown")
                    }
                }

                // Actions Section
                Section {
                    Button(action: {
                        viewModel.clearCacheType(.images)
                    }) {
                        Label("Clear Image Cache", systemImage: "photo.fill")
                            .foregroundColor(.blue)
                    }
                    .disabled(!viewModel.canClearCache)

                    Button(action: {
                        viewModel.clearCacheType(.temporary)
                    }) {
                        Label("Clear Temporary Files", systemImage: "clock.arrow.circlepath")
                            .foregroundColor(.orange)
                    }
                    .disabled(!viewModel.canClearCache)

                    Button(action: {
                        viewModel.showingClearCacheAlert = true
                        dismiss()
                    }) {
                        Label("Clear All Cache", systemImage: "trash.fill")
                            .foregroundColor(.red)
                    }
                    .disabled(!viewModel.canClearCache)
                } header: {
                    Text("Actions")
                } footer: {
                    Text("Clearing cache will free up storage space but may increase loading times temporarily.")
                        .font(.caption)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Cache Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Cache Breakdown Row
struct CacheBreakdownRow: View {
    let title: String
    let size: Int64
    let icon: String
    let color: Color
    @ObservedObject private var themeManager = ThemeManager.shared

    private var formattedSize: String {
        ByteCountFormatter.string(fromByteCount: size, countStyle: .binary)
    }

    private var percentage: Double {
        // Este cálculo seria feito com o total, mas simplificado aqui
        return 0.0
    }

    var body: some View {
        HStack {
            Label {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .foregroundColor(themeManager.currentTheme.primaryText)

                    Text(formattedSize)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } icon: {
                Image(systemName: icon)
                    .foregroundColor(color)
            }

            Spacer()

            // Visual size indicator
            RoundedRectangle(cornerRadius: 4)
                .fill(color.opacity(0.2))
                .frame(width: 60, height: 6)
                .overlay(
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(color)
                            .frame(width: min(CGFloat(size) / 100_000_000 * geometry.size.width, geometry.size.width))
                    }
                )
        }
    }
}
