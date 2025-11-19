//
//  CacheUseCase.swift
//  Settings
//
//  Created by Ivan Tonial IP.TV on 18/11/25.
//

import Cache
import Foundation
import UIKit

@MainActor
public final class CacheUseCase: Sendable {
    // MARK: - Properties
    private let cacheManager: CacheManagerProtocol?
    private let fileManager = FileManager.default

    // Diretórios de cache do sistema
    private var systemCacheDirectory: URL? {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
    }

    private var temporaryDirectory: URL {
        fileManager.temporaryDirectory
    }

    // MARK: - Initialization
    public init(cacheManager: CacheManagerProtocol? = nil) {
        self.cacheManager = cacheManager
    }

    // MARK: - Public Methods

    /// Calcula o tamanho total do cache incluindo todos os componentes
    public func calculateTotalCacheSize() async -> CacheSizeInfo {
        var totalSize: Int64 = 0
        var breakdown = CacheSizeBreakdown()

        // 1. Cache gerenciado pelo CacheManager
        if let manager = cacheManager {
            let managedCacheSize = await manager.getCacheSize()
            breakdown.managedCache = Int64(managedCacheSize)
            totalSize += breakdown.managedCache
        }

        // 2. Cache de imagens do AsyncImage/URLCache
        let urlCacheSize = calculateURLCacheSize()
        breakdown.imageCache = urlCacheSize
        totalSize += urlCacheSize

        // 3. Cache do sistema (Caches directory)
        if let systemCache = calculateSystemCacheSize() {
            breakdown.systemCache = systemCache
            totalSize += systemCache
        }

        // 4. Arquivos temporários
        let tempSize = calculateTemporaryFilesSize()
        breakdown.temporaryFiles = tempSize
        totalSize += tempSize

        // 5. Core Data (se houver cache separado)
        let coreDataSize = calculateCoreDataSize()
        breakdown.coreDataCache = coreDataSize
        totalSize += coreDataSize

        return CacheSizeInfo(
            totalSize: totalSize,
            formattedSize: formatByteCount(totalSize),
            breakdown: breakdown,
            lastCalculated: Date()
        )
    }

    /// Limpa todo o cache do aplicativo
    public func clearAllCache() async -> ClearCacheResult {
        var clearedSize: Int64 = 0
        var errors: [String] = []

        // Calcula o tamanho antes de limpar
        let sizeBefore = await calculateTotalCacheSize()

        // 1. Limpa cache gerenciado
        if let manager = cacheManager {
            let managedSize = await manager.getCacheSize()
            await manager.clearAll()
            clearedSize += Int64(managedSize)
        }

        // 2. Limpa URLCache (cache de imagens do AsyncImage)
        let urlCacheCleared = clearURLCache()
        clearedSize += urlCacheCleared

        // 3. Limpa cache do sistema
        if let systemCleared = clearSystemCache() {
            clearedSize += systemCleared
        } else {
            errors.append("Failed to clear some system cache files")
        }

        // 4. Limpa arquivos temporários
        let tempCleared = clearTemporaryFiles()
        clearedSize += tempCleared

        // 5. Limpa cache de imagens específico do ComicVine
        clearComicVineImageCache()

        // Calcula o tamanho depois de limpar
        let sizeAfter = await calculateTotalCacheSize()

        return ClearCacheResult(
            success: errors.isEmpty,
            clearedSize: sizeBefore.totalSize - sizeAfter.totalSize,
            formattedClearedSize: formatByteCount(sizeBefore.totalSize - sizeAfter.totalSize),
            errors: errors,
            timestamp: Date()
        )
    }

    /// Limpa cache seletivamente por tipo
    public func clearCacheByType(_ type: CacheType) async -> ClearCacheResult {
        var clearedSize: Int64 = 0
        var errors: [String] = []

        switch type {
        case .managed:
            if let manager = cacheManager {
                let size = await manager.getCacheSize()
                await manager.clearAll()
                clearedSize = Int64(size)
            }

        case .images:
            clearedSize = clearURLCache()
            clearComicVineImageCache()

        case .temporary:
            clearedSize = clearTemporaryFiles()

        case .system:
            if let cleared = clearSystemCache() {
                clearedSize = cleared
            } else {
                errors.append("Failed to clear system cache")
            }

        case .all:
            return await clearAllCache()
        }

        return ClearCacheResult(
            success: errors.isEmpty,
            clearedSize: clearedSize,
            formattedClearedSize: formatByteCount(clearedSize),
            errors: errors,
            timestamp: Date()
        )
    }

    // MARK: - Private Methods

    private func calculateURLCacheSize() -> Int64 {
        let urlCache = URLCache.shared
        let currentDiskUsage = Int64(urlCache.currentDiskUsage)
        let currentMemoryUsage = Int64(urlCache.currentMemoryUsage)
        return currentDiskUsage + currentMemoryUsage
    }

    private func calculateSystemCacheSize() -> Int64? {
        guard let cacheDir = systemCacheDirectory else { return nil }

        do {
            let size = try fileManager.sizeOfDirectory(at: cacheDir)
            return Int64(size)
        } catch {
            print("🔴 Error calculating system cache size: \(error)")
            return nil
        }
    }

    private func calculateTemporaryFilesSize() -> Int64 {
        do {
            let size = try fileManager.sizeOfDirectory(at: temporaryDirectory)
            return Int64(size)
        } catch {
            print("🔴 Error calculating temporary files size: \(error)")
            return 0
        }
    }

    private func calculateCoreDataSize() -> Int64 {
        guard let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return 0
        }

        let coreDataFiles = ["ComicVine.sqlite", "ComicVine.sqlite-shm", "ComicVine.sqlite-wal"]
        var totalSize: Int64 = 0

        for fileName in coreDataFiles {
            let fileURL = documentsDir.appendingPathComponent(fileName)
            if let attributes = try? fileManager.attributesOfItem(atPath: fileURL.path),
               let fileSize = attributes[.size] as? Int64 {
                totalSize += fileSize
            }
        }

        return totalSize
    }

    private func clearURLCache() -> Int64 {
        let urlCache = URLCache.shared
        let sizeBefore = Int64(urlCache.currentDiskUsage + urlCache.currentMemoryUsage)
        urlCache.removeAllCachedResponses()
        return sizeBefore
    }

    private func clearSystemCache() -> Int64? {
        guard let cacheDir = systemCacheDirectory else { return nil }

        var clearedSize: Int64 = 0

        do {
            let contents = try fileManager.contentsOfDirectory(at: cacheDir, includingPropertiesForKeys: [.fileSizeKey])

            for fileURL in contents {
                // Pula diretórios importantes do sistema
                let fileName = fileURL.lastPathComponent
                if fileName == "Snapshots" || fileName.hasPrefix("com.apple") {
                    continue
                }

                // Calcula o tamanho antes de deletar
                if let attributes = try? fileManager.attributesOfItem(atPath: fileURL.path),
                   let fileSize = attributes[.size] as? Int64 {
                    clearedSize += fileSize
                }

                // Tenta remover o arquivo/diretório
                try? fileManager.removeItem(at: fileURL)
            }

            return clearedSize
        } catch {
            print("🔴 Error clearing system cache: \(error)")
            return nil
        }
    }

    private func clearTemporaryFiles() -> Int64 {
        var clearedSize: Int64 = 0

        do {
            let contents = try fileManager.contentsOfDirectory(at: temporaryDirectory, includingPropertiesForKeys: [.fileSizeKey])

            for fileURL in contents {
                if let attributes = try? fileManager.attributesOfItem(atPath: fileURL.path),
                   let fileSize = attributes[.size] as? Int64 {
                    clearedSize += fileSize
                }

                try? fileManager.removeItem(at: fileURL)
            }
        } catch {
            print("🔴 Error clearing temporary files: \(error)")
        }

        return clearedSize
    }

    private func clearComicVineImageCache() {
        // Limpa cache específico de imagens da ComicVine se houver diretório dedicado
        guard let cacheDir = systemCacheDirectory else { return }
        let comicVineCache = cacheDir.appendingPathComponent("ComicVineImages")

        if fileManager.fileExists(atPath: comicVineCache.path) {
            try? fileManager.removeItem(at: comicVineCache)
        }
    }

    private func formatByteCount(_ bytes: Int64) -> String {
        ByteCountFormatter.string(fromByteCount: bytes, countStyle: .binary)
    }
}

// MARK: - Supporting Types

public struct CacheSizeInfo {
    public let totalSize: Int64
    public let formattedSize: String
    public let breakdown: CacheSizeBreakdown
    public let lastCalculated: Date

    public var isEmpty: Bool {
        totalSize == 0
    }

    public var detailedDescription: String {
        var description = "Total: \(formattedSize)"

        if breakdown.hasDetails {
            description += "\n"

            if breakdown.managedCache > 0 {
                description += "\n• App Data: \(formatBytes(breakdown.managedCache))"
            }
            if breakdown.imageCache > 0 {
                description += "\n• Images: \(formatBytes(breakdown.imageCache))"
            }
            if breakdown.systemCache > 0 {
                description += "\n• System: \(formatBytes(breakdown.systemCache))"
            }
            if breakdown.temporaryFiles > 0 {
                description += "\n• Temporary: \(formatBytes(breakdown.temporaryFiles))"
            }
            if breakdown.coreDataCache > 0 {
                description += "\n• Database: \(formatBytes(breakdown.coreDataCache))"
            }
        }

        return description
    }

    private func formatBytes(_ bytes: Int64) -> String {
        ByteCountFormatter.string(fromByteCount: bytes, countStyle: .binary)
    }
}

public struct CacheSizeBreakdown {
    public var managedCache: Int64 = 0
    public var imageCache: Int64 = 0
    public var systemCache: Int64 = 0
    public var temporaryFiles: Int64 = 0
    public var coreDataCache: Int64 = 0

    // Propriedade única, sem duplicação
    public var hasDetails: Bool {
        managedCache > 0 || imageCache > 0 || systemCache > 0 ||
        temporaryFiles > 0 || coreDataCache > 0
    }
}

public struct ClearCacheResult {
    public let success: Bool
    public let clearedSize: Int64
    public let formattedClearedSize: String
    public let errors: [String]
    public let timestamp: Date

    public var message: String {
        if success {
            return "Successfully cleared \(formattedClearedSize)"
        } else if !errors.isEmpty {
            return "Cleared \(formattedClearedSize) with some errors"
        } else {
            return "Cache cleared"
        }
    }
}

public enum CacheType {
    case managed
    case images
    case temporary
    case system
    case all
}
