//
//  LoadingManager.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 24/11/25.
//

import Foundation
import SwiftUI
import Combine

/// Gerenciador centralizado para estados de loading em toda a aplicação
@MainActor
public final class LoadingManager: ObservableObject {

    // MARK: - Singleton
    public static let shared = LoadingManager()

    // MARK: - Published Properties
    @Published public private(set) var isLoading = false
    @Published public private(set) var loadingMessage = "Loading"
    @Published public private(set) var currentLoadingContext: LoadingContext?

    // MARK: - Private Properties
    private var loadingCount = 0
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Loading Context
    public enum LoadingContext: String {
        case characterList = "Loading heroes"
        case characterDetail = "Loading character"
        case comicsList = "Loading comics"
        case favorites = "Loading favorites"
        case search = "Searching"
        case settings = "Loading settings"
        case general = "Loading"

        public var message: String {
            return self.rawValue + "..."
        }
    }

    // MARK: - Initialization
    private init() {
        setupDebugLogging()
    }

    // MARK: - Public Methods

    /// Inicia o loading com contexto e mensagem específicos
    public func startLoading(context: LoadingContext, customMessage: String? = nil) {
        loadingCount += 1
        isLoading = true
        currentLoadingContext = context
        loadingMessage = customMessage ?? context.message

        debugPrint("🔄 [LoadingManager] Started loading: \(context.rawValue) - Count: \(loadingCount)")
    }

    /// Para o loading
    public func stopLoading() {
        loadingCount = max(0, loadingCount - 1)

        if loadingCount == 0 {
            isLoading = false
            currentLoadingContext = nil
            loadingMessage = "Loading"
            debugPrint("✅ [LoadingManager] All loading stopped")
        } else {
            debugPrint("⏳ [LoadingManager] Loading count: \(loadingCount)")
        }
    }

    /// Para todo loading forçadamente
    public func forceStopAllLoading() {
        loadingCount = 0
        isLoading = false
        currentLoadingContext = nil
        loadingMessage = "Loading"
        debugPrint("🛑 [LoadingManager] Force stopped all loading")
    }

    /// Executa uma operação async com loading automático
    public func withLoading<T>(
        context: LoadingContext,
        customMessage: String? = nil,
        operation: () async throws -> T
    ) async throws -> T {
        startLoading(context: context, customMessage: customMessage)
        defer { stopLoading() }

        do {
            let result = try await operation()
            return result
        } catch {
            debugPrint("❌ [LoadingManager] Error during loading: \(error)")
            throw error
        }
    }

    /// Executa uma operação com loading temporário
    public func withTemporaryLoading(
        context: LoadingContext,
        duration: TimeInterval = 0.5,
        operation: () -> Void
    ) {
        startLoading(context: context)
        operation()

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.stopLoading()
        }
    }

    // MARK: - Private Methods

    private func setupDebugLogging() {
        #if DEBUG
        $isLoading
            .sink { isLoading in
                print("📊 [LoadingManager] isLoading: \(isLoading)")
            }
            .store(in: &cancellables)
        #endif
    }

    private func debugPrint(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
}
