//
//  SettingsViewModel.swift
//  Settings
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

//import Cache
//import Combine
//import Core
//import DesignSystem
//import Foundation
//import SwiftUI
//import UserNotifications
//
//@MainActor
//public final class SettingsViewModel: ObservableObject {
//    // MARK: - Published Properties
//    @Published public var isNotificationsEnabled: Bool = false
//    @Published public var isDarkModeEnabled: Bool = true
//    @Published public var isAutoPlayVideosEnabled: Bool = false
//    @Published public var imageQuality: ImageQuality = .high
//    @Published public var cacheSize: String = "Calculating..."
//    @Published public var appVersion: String = "-"
//    @Published public var buildNumber: String = "-"
//    @Published public var showingClearCacheAlert: Bool = false
//    @Published public var showingResetAlert: Bool = false
//    @Published public var apiStatus: APIStatus = .checking
//
//    // MARK: - Private Properties
//    private let cacheManager: CacheManagerProtocol?
//    private let userDefaults = UserDefaults.standard
//    private let themeManager = ThemeManager.shared
//    private var cancellables = Set<AnyCancellable>()
//
//    // MARK: - Computed Properties
//    public var notificationStatusText: String {
//        isNotificationsEnabled ? "Enabled" : "Disabled"
//    }
//
//    public var cacheStatusText: String { cacheSize }
//
//    // MARK: - Initialization
//    public init(cacheManager: CacheManagerProtocol? = nil) {
//        self.cacheManager = cacheManager
//
//        // Sincroniza com o ThemeManager desde o início
//        self.isDarkModeEnabled = themeManager.isDarkMode
//
//        loadSettings()
//        loadAppInfo()
//        calculateCacheSize()
//        checkAPIStatus()
//        setupThemeObserver()
//    }
//
//    // MARK: - Public Methods
//    public func toggleNotifications() {
//        // Não inverte aqui, o toggle já fez isso
//        saveSettings()
//        if isNotificationsEnabled { requestNotificationPermission() }
//    }
//
//    public func applyTheme(isDark: Bool) {
//        let newTheme: ThemeType = isDark ? .dark : .light
//        themeManager.setTheme(newTheme)
//        saveSettings()
//    }
//
//    public func toggleAutoPlayVideos() {
//        isAutoPlayVideosEnabled.toggle()
//        saveSettings()
//    }
//
//    public func updateImageQuality(_ quality: ImageQuality) {
//        imageQuality = quality
//        saveSettings()
//    }
//
//    public func clearCache() {
//        Task {
//            if let manager = cacheManager {
//                await manager.clearAll()
//                calculateCacheSize()
//                let feedback = UINotificationFeedbackGenerator()
//                feedback.notificationOccurred(.success)
//            }
//        }
//    }
//
//    public func resetSettings() {
//        isNotificationsEnabled = false
//        isDarkModeEnabled = true
//        isAutoPlayVideosEnabled = false
//        imageQuality = .high
//
//        userDefaults.removeObject(forKey: "notifications_enabled")
//        userDefaults.removeObject(forKey: "auto_play_videos")
//        userDefaults.removeObject(forKey: "image_quality")
//        userDefaults.removeObject(forKey: "FavoriteCharacters")
//        userDefaults.removeObject(forKey: "RecentSearches")
//
//        // Reseta o tema para o padrão (dark)
//        themeManager.setTheme(.dark)
//
//        let feedback = UINotificationFeedbackGenerator()
//        feedback.notificationOccurred(.warning)
//    }
//
//    public func rateApp() {
//        if let url = URL(string: "itms-apps://itunes.apple.com/app/id123456789") {
//            UIApplication.shared.open(url)
//        }
//    }
//
//    public func shareApp() -> [Any] {
//        let text = "Check out ComicsApp - Your guide to the Comics Universe!"
//        let url = URL(string: "https://apps.apple.com/app/id123456789")!
//        return [text, url]
//    }
//
//    public func openPrivacyPolicy() {
//        if let url = URL(string: "https://comicapp.com/privacy") {
//            UIApplication.shared.open(url)
//        }
//    }
//
//    public func openTermsOfService() {
//        if let url = URL(string: "https://comicapp.com/terms") {
//            UIApplication.shared.open(url)
//        }
//    }
//
//    public func contactSupport() {
//        if let url = URL(string: "mailto:support@comicapp.com") {
//            UIApplication.shared.open(url)
//        }
//    }
//
//    public func reportBug() {
//        let email = "bugs@comicapp.com"
//        let subject = "Bug Report - ComicApp \(appVersion)"
//        let body = """
//        ---
//        App Version: \(appVersion)
//        Build: \(buildNumber)
//        Device: \(UIDevice.current.model)
//        iOS: \(UIDevice.current.systemVersion)
//        """
//
//        if let url = URL(
//            string: "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
//        ) {
//            UIApplication.shared.open(url)
//        }
//    }
//
//    // MARK: - Private Methods
//    private func loadSettings() {
//        isNotificationsEnabled = userDefaults.bool(forKey: "notifications_enabled")
//
//        // Sempre sincroniza com o ThemeManager
//        isDarkModeEnabled = themeManager.isDarkMode
//
//        isAutoPlayVideosEnabled = userDefaults.bool(forKey: "auto_play_videos")
//
//        if let qualityRaw = userDefaults.string(forKey: "image_quality"),
//           let quality = ImageQuality(rawValue: qualityRaw) {
//            imageQuality = quality
//        }
//    }
//
//    private func saveSettings() {
//        userDefaults.set(isNotificationsEnabled, forKey: "notifications_enabled")
//        userDefaults.set(isAutoPlayVideosEnabled, forKey: "auto_play_videos")
//        userDefaults.set(imageQuality.rawValue, forKey: "image_quality")
//    }
//
//    private func loadAppInfo() {
//        appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "-"
//        buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "-"
//    }
//
//    private func calculateCacheSize() {
//        Task {
//            if let manager = cacheManager {
//                let size = await manager.getCacheSize()
//                cacheSize = ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .binary)
//            } else {
//                let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//                if let size = try? FileManager.default.sizeOfDirectory(at: URL(fileURLWithPath: documents)) {
//                    cacheSize = ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .binary)
//                }
//            }
//        }
//    }
//
//    private func checkAPIStatus() {
//        Task {
//            apiStatus = .checking
//            try? await Task.sleep(nanoseconds: 2_000_000_000)
//
//            let apiKey = Bundle.main.object(forInfoDictionaryKey: "COMICVINE_API_KEY") as? String ?? ""
//
//            if !apiKey.isEmpty && apiKey != "YOUR_API_KEY_HERE" {
//                apiStatus = .online
//            } else {
//                apiStatus = .offline
//            }
//        }
//    }
//
//    private func requestNotificationPermission() {
//        Task {
//            let center = UNUserNotificationCenter.current()
//            do {
//                let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
//                if !granted {
//                    isNotificationsEnabled = false
//                    saveSettings()
//                }
//            } catch {
//                isNotificationsEnabled = false
//                saveSettings()
//            }
//        }
//    }
//
//    private func setupThemeObserver() {
//        // Observa mudanças no tema para manter a sincronização
//        themeManager.$currentThemeType
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] themeType in
//                guard let self = self else { return }
//                let newValue = themeType == .dark
//                if self.isDarkModeEnabled != newValue {
//                    self.isDarkModeEnabled = newValue
//                }
//            }
//            .store(in: &cancellables)
//    }
//}
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
    @Published public var cacheDetails: String = ""
    @Published public var appVersion: String = "-"
    @Published public var buildNumber: String = "-"
    @Published public var showingClearCacheAlert: Bool = false
    @Published public var showingResetAlert: Bool = false
    @Published public var apiStatus: APIStatus = .checking
    @Published public var isClearingCache: Bool = false
    @Published public var isCalculatingCache: Bool = false
    @Published public var lastCacheUpdate: Date?
    @Published public var cacheBreakdown: CacheSizeBreakdown?
    @Published public var showCacheDetails: Bool = false

    // MARK: - Private Properties
    private let cacheManager: CacheManagerProtocol?
    private let cacheUseCase: CacheUseCase
    private let userDefaults = UserDefaults.standard
    private let themeManager = ThemeManager.shared
    private var cancellables = Set<AnyCancellable>()
    private var cacheUpdateTimer: Timer?

    // Cache automático
    private let cacheRefreshInterval: TimeInterval = 60 // Atualiza a cada minuto quando a tela está visível

    // MARK: - Computed Properties
    public var notificationStatusText: String {
        isNotificationsEnabled ? "Enabled" : "Disabled"
    }

    public var cacheStatusText: String {
        if isCalculatingCache {
            return "Calculating..."
        }

        if cacheDetails.isEmpty {
            return cacheSize
        }

        return cacheSize
    }

    public var canClearCache: Bool {
        !isClearingCache && !isCalculatingCache && cacheSize != "0 bytes"
    }

    public var cacheInfoIcon: String {
        if let breakdown = cacheBreakdown, breakdown.hasDetails {
            return "info.circle.fill"
        }
        return ""
    }

    public var formattedLastUpdate: String? {
        guard let lastUpdate = lastCacheUpdate else { return nil }

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return "Updated \(formatter.localizedString(for: lastUpdate, relativeTo: Date()))"
    }

    // MARK: - Initialization
    public init(cacheManager: CacheManagerProtocol? = nil) {
        self.cacheManager = cacheManager
        self.cacheUseCase = CacheUseCase(cacheManager: cacheManager)

        // Sincroniza com o ThemeManager desde o início
        self.isDarkModeEnabled = themeManager.isDarkMode

        loadSettings()
        loadAppInfo()
        Task {
            await calculateCacheSize()
        }
        checkAPIStatus()
        setupThemeObserver()
        setupCacheUpdateTimer()
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
        guard canClearCache else { return }

        Task {
            await performCacheClear()
        }
    }

    public func clearCacheType(_ type: CacheType) {
        guard canClearCache else { return }

        Task {
            await performCacheClear(cacheType: type)
        }
    }

    public func refreshCacheSize() {
        Task {
            await calculateCacheSize()
        }
    }

    public func toggleCacheDetails() {
        showCacheDetails.toggle()
    }

    @MainActor
    private func performCacheClear(cacheType: CacheType = .all) async {
        isClearingCache = true

        // Haptic feedback inicial
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()

        do {
            // Pequena pausa para mostrar o estado de loading
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5s

            let result = await cacheUseCase.clearCacheByType(cacheType)

            if result.success {
                // Feedback de sucesso
                let successFeedback = UINotificationFeedbackGenerator()
                successFeedback.notificationOccurred(.success)

                // Mostra mensagem temporária
                withAnimation {
                    cacheSize = "Cleared \(result.formattedClearedSize)"
                    cacheDetails = ""
                    cacheBreakdown = nil
                }

                // Aguarda um pouco antes de recalcular
                try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5s

                // Recalcula o tamanho
                await calculateCacheSize()

            } else {
                // Feedback de erro
                let errorFeedback = UINotificationFeedbackGenerator()
                errorFeedback.notificationOccurred(.error)

                // Ainda assim, recalcula o tamanho
                await calculateCacheSize()
            }
        } catch {
            print("🔴 Error clearing cache: \(error)")

            let errorFeedback = UINotificationFeedbackGenerator()
            errorFeedback.notificationOccurred(.error)
        }

        isClearingCache = false
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

        // Limpa o cache também
        Task {
            await performCacheClear()
        }

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
        Cache Size: \(cacheSize)
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

    @MainActor
    private func calculateCacheSize() async {
        isCalculatingCache = true

        let cacheInfo = await cacheUseCase.calculateTotalCacheSize()

        withAnimation(.easeInOut(duration: 0.3)) {
            cacheSize = cacheInfo.formattedSize
            cacheBreakdown = cacheInfo.breakdown
            lastCacheUpdate = cacheInfo.lastCalculated

            // Cria uma descrição detalhada se houver breakdown
            if cacheInfo.breakdown.hasDetails {
                var details: [String] = []

                if cacheInfo.breakdown.imageCache > 0 {
                    details.append("Images: \(formatBytes(cacheInfo.breakdown.imageCache))")
                }
                if cacheInfo.breakdown.managedCache > 0 {
                    details.append("Data: \(formatBytes(cacheInfo.breakdown.managedCache))")
                }
                if cacheInfo.breakdown.coreDataCache > 0 {
                    details.append("Database: \(formatBytes(cacheInfo.breakdown.coreDataCache))")
                }

                cacheDetails = details.joined(separator: " • ")
            } else {
                cacheDetails = ""
            }
        }

        isCalculatingCache = false
    }

    private func formatBytes(_ bytes: Int64) -> String {
        ByteCountFormatter.string(fromByteCount: bytes, countStyle: .binary)
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

    private func setupCacheUpdateTimer() {
        // Atualiza o cache automaticamente quando a view está ativa
        NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                Task { [weak self] in
                    await self?.calculateCacheSize()
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Methods for View State
    public func onAppear() {
        Task {
            await calculateCacheSize()
        }

        // Inicia timer para atualização periódica
        stopCacheTimer() // Para qualquer timer existente primeiro
        cacheUpdateTimer = Timer.scheduledTimer(withTimeInterval: cacheRefreshInterval, repeats: true) { [weak self] _ in
            Task { [weak self] in
                await self?.calculateCacheSize()
            }
        }
    }

    public func onDisappear() {
        stopCacheTimer()
    }

    // Helper method para parar o timer de forma segura
    private func stopCacheTimer() {
        cacheUpdateTimer?.invalidate()
        cacheUpdateTimer = nil
    }
}
