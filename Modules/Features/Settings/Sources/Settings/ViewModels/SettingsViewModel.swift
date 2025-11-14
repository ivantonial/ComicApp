//
//  SettingsViewModel.swift
//  Settings
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import Cache
import Combine
import Core
import DesignSystem
import Foundation
import SwiftUI
import UserNotifications

@MainActor
public final class SettingsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published public var isNotificationsEnabled: Bool = false
    @Published public var isDarkModeEnabled: Bool = true
    @Published public var isAutoPlayVideosEnabled: Bool = false
    @Published public var imageQuality: ImageQuality = .high
    @Published public var cacheSize: String = "Calculating..."
    @Published public var appVersion: String = "-"
    @Published public var buildNumber: String = "-"
    @Published public var showingClearCacheAlert: Bool = false
    @Published public var showingResetAlert: Bool = false
    @Published public var apiStatus: APIStatus = .checking

    // MARK: - Private Properties
    private let cacheManager: CacheManagerProtocol?
    private let userDefaults = UserDefaults.standard
    private let themeManager = ThemeManager.shared
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Computed Properties
    public var notificationStatusText: String {
        isNotificationsEnabled ? "Enabled" : "Disabled"
    }

    public var cacheStatusText: String { cacheSize }

    // MARK: - Initialization
    public init(cacheManager: CacheManagerProtocol? = nil) {
        self.cacheManager = cacheManager

        // Sincroniza com o ThemeManager desde o início
        self.isDarkModeEnabled = themeManager.isDarkMode

        loadSettings()
        loadAppInfo()
        calculateCacheSize()
        checkAPIStatus()
        setupThemeObserver()
    }

    // MARK: - Public Methods
    public func toggleNotifications() {
        // Não inverte aqui, o toggle já fez isso
        saveSettings()
        if isNotificationsEnabled { requestNotificationPermission() }
    }

    public func applyTheme(isDark: Bool) {
        let newTheme: ThemeType = isDark ? .dark : .light
        themeManager.setTheme(newTheme)
        saveSettings()
    }

    public func toggleAutoPlayVideos() {
        isAutoPlayVideosEnabled.toggle()
        saveSettings()
    }

    public func updateImageQuality(_ quality: ImageQuality) {
        imageQuality = quality
        saveSettings()
    }

    public func clearCache() {
        Task {
            if let manager = cacheManager {
                await manager.clearAll()
                calculateCacheSize()
                let feedback = UINotificationFeedbackGenerator()
                feedback.notificationOccurred(.success)
            }
        }
    }

    public func resetSettings() {
        isNotificationsEnabled = false
        isDarkModeEnabled = true
        isAutoPlayVideosEnabled = false
        imageQuality = .high

        userDefaults.removeObject(forKey: "notifications_enabled")
        userDefaults.removeObject(forKey: "auto_play_videos")
        userDefaults.removeObject(forKey: "image_quality")
        userDefaults.removeObject(forKey: "FavoriteCharacters")
        userDefaults.removeObject(forKey: "RecentSearches")

        // Reseta o tema para o padrão (dark)
        themeManager.setTheme(.dark)

        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.warning)
    }

    public func rateApp() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id123456789") {
            UIApplication.shared.open(url)
        }
    }

    public func shareApp() -> [Any] {
        let text = "Check out ComicsApp - Your guide to the Comics Universe!"
        let url = URL(string: "https://apps.apple.com/app/id123456789")!
        return [text, url]
    }

    public func openPrivacyPolicy() {
        if let url = URL(string: "https://comicapp.com/privacy") {
            UIApplication.shared.open(url)
        }
    }

    public func openTermsOfService() {
        if let url = URL(string: "https://comicapp.com/terms") {
            UIApplication.shared.open(url)
        }
    }

    public func contactSupport() {
        if let url = URL(string: "mailto:support@comicapp.com") {
            UIApplication.shared.open(url)
        }
    }

    public func reportBug() {
        let email = "bugs@comicapp.com"
        let subject = "Bug Report - ComicApp \(appVersion)"
        let body = """
        ---
        App Version: \(appVersion)
        Build: \(buildNumber)
        Device: \(UIDevice.current.model)
        iOS: \(UIDevice.current.systemVersion)
        """

        if let url = URL(
            string: "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        ) {
            UIApplication.shared.open(url)
        }
    }

    // MARK: - Private Methods
    private func loadSettings() {
        isNotificationsEnabled = userDefaults.bool(forKey: "notifications_enabled")

        // Sempre sincroniza com o ThemeManager
        isDarkModeEnabled = themeManager.isDarkMode

        isAutoPlayVideosEnabled = userDefaults.bool(forKey: "auto_play_videos")

        if let qualityRaw = userDefaults.string(forKey: "image_quality"),
           let quality = ImageQuality(rawValue: qualityRaw) {
            imageQuality = quality
        }
    }

    private func saveSettings() {
        userDefaults.set(isNotificationsEnabled, forKey: "notifications_enabled")
        userDefaults.set(isAutoPlayVideosEnabled, forKey: "auto_play_videos")
        userDefaults.set(imageQuality.rawValue, forKey: "image_quality")
    }

    private func loadAppInfo() {
        appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "-"
        buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "-"
    }

    private func calculateCacheSize() {
        Task {
            if let manager = cacheManager {
                let size = await manager.getCacheSize()
                cacheSize = ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .binary)
            } else {
                let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                if let size = try? FileManager.default.sizeOfDirectory(at: URL(fileURLWithPath: documents)) {
                    cacheSize = ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .binary)
                }
            }
        }
    }

    private func checkAPIStatus() {
        Task {
            apiStatus = .checking
            try? await Task.sleep(nanoseconds: 2_000_000_000)

            let apiKey = Bundle.main.object(forInfoDictionaryKey: "COMICVINE_API_KEY") as? String ?? ""

            if !apiKey.isEmpty && apiKey != "YOUR_API_KEY_HERE" {
                apiStatus = .online
            } else {
                apiStatus = .offline
            }
        }
    }

    private func requestNotificationPermission() {
        Task {
            let center = UNUserNotificationCenter.current()
            do {
                let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
                if !granted {
                    isNotificationsEnabled = false
                    saveSettings()
                }
            } catch {
                isNotificationsEnabled = false
                saveSettings()
            }
        }
    }

    private func setupThemeObserver() {
        // Observa mudanças no tema para manter a sincronização
        themeManager.$currentThemeType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] themeType in
                guard let self = self else { return }
                let newValue = themeType == .dark
                if self.isDarkModeEnabled != newValue {
                    self.isDarkModeEnabled = newValue
                }
            }
            .store(in: &cancellables)
    }
}
