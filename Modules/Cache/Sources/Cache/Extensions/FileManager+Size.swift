//
//  FileManager+Size.swift
//  Cache
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import Foundation

public extension FileManager {
    /// Calcula o tamanho de um diretório incluindo todos os subdiretórios
    func sizeOfDirectory(at url: URL) throws -> Int {
        var size = 0

        guard url.hasDirectoryPath || (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true else {
            // Se não é um diretório, retorna o tamanho do arquivo
            let fileSize = try url.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0
            return fileSize
        }

        // Usa enumerator para percorrer recursivamente
        if let enumerator = self.enumerator(
            at: url,
            includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        ) {
            for case let fileURL as URL in enumerator {
                do {
                    let resourceValues = try fileURL.resourceValues(forKeys: [.fileSizeKey, .isDirectoryKey])

                    // Só adiciona o tamanho se for um arquivo (não diretório)
                    if resourceValues.isDirectory != true {
                        size += resourceValues.fileSize ?? 0
                    }
                } catch {
                    // Continua mesmo se não conseguir acessar um arquivo específico
                    print("⚠️ Could not access file at \(fileURL.path): \(error.localizedDescription)")
                    continue
                }
            }
        }

        return size
    }

    /// Calcula o tamanho de um diretório de forma assíncrona
    /// Usa FileManager.default explicitamente para evitar captura de 'self' em closure @Sendable
    func sizeOfDirectoryAsync(at url: URL) async throws -> Int {
        // Captura a URL como valor antes de entrar no contexto assíncrono
        let targetURL = url

        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    // Usa FileManager.default ao invés de self para evitar data race
                    // FileManager.default é thread-safe como instância singleton
                    let size = try FileManager.default.sizeOfDirectory(at: targetURL)
                    continuation.resume(returning: size)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    /// Versão mais detalhada que retorna informações sobre o conteúdo
    func detailedSizeOfDirectory(at url: URL) throws -> DirectorySizeInfo {
        var totalSize = 0
        var fileCount = 0
        var directoryCount = 0
        var largestFile: (url: URL, size: Int)?
        var sizeByExtension: [String: Int] = [:]

        guard url.hasDirectoryPath || (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true else {
            let fileSize = try url.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0
            return DirectorySizeInfo(
                totalSize: fileSize,
                fileCount: 1,
                directoryCount: 0,
                largestFile: (url, fileSize),
                sizeByExtension: [url.pathExtension: fileSize]
            )
        }

        if let enumerator = self.enumerator(
            at: url,
            includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        ) {
            for case let fileURL as URL in enumerator {
                do {
                    let resourceValues = try fileURL.resourceValues(forKeys: [.fileSizeKey, .isDirectoryKey])

                    if resourceValues.isDirectory == true {
                        directoryCount += 1
                    } else {
                        let fileSize = resourceValues.fileSize ?? 0
                        totalSize += fileSize
                        fileCount += 1

                        // Rastreia o maior arquivo
                        if let largest = largestFile {
                            if fileSize > largest.size {
                                largestFile = (fileURL, fileSize)
                            }
                        } else {
                            largestFile = (fileURL, fileSize)
                        }

                        // Agrupa por extensão
                        let ext = fileURL.pathExtension.isEmpty ? "no-extension" : fileURL.pathExtension
                        sizeByExtension[ext, default: 0] += fileSize
                    }
                } catch {
                    continue
                }
            }
        }

        return DirectorySizeInfo(
            totalSize: totalSize,
            fileCount: fileCount,
            directoryCount: directoryCount,
            largestFile: largestFile,
            sizeByExtension: sizeByExtension
        )
    }

    /// Remove arquivos antigos de um diretório
    func removeOldFiles(from directory: URL, olderThan days: Int) throws -> Int {
        var removedSize = 0
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()

        if let enumerator = self.enumerator(
            at: directory,
            includingPropertiesForKeys: [.contentModificationDateKey, .fileSizeKey, .isDirectoryKey],
            options: [.skipsHiddenFiles]
        ) {
            for case let fileURL as URL in enumerator {
                do {
                    let resourceValues = try fileURL.resourceValues(
                        forKeys: [.contentModificationDateKey, .fileSizeKey, .isDirectoryKey]
                    )

                    guard resourceValues.isDirectory != true,
                          let modificationDate = resourceValues.contentModificationDate,
                          modificationDate < cutoffDate else {
                        continue
                    }

                    let fileSize = resourceValues.fileSize ?? 0
                    try self.removeItem(at: fileURL)
                    removedSize += fileSize

                } catch {
                    print("⚠️ Could not remove file at \(fileURL.path): \(error.localizedDescription)")
                    continue
                }
            }
        }

        return removedSize
    }

    /// Calcula o espaço livre no dispositivo
    var deviceFreeSpace: Int64? {
        guard let systemAttributes = try? attributesOfFileSystem(forPath: NSHomeDirectory()),
              let freeSpace = systemAttributes[.systemFreeSize] as? NSNumber else {
            return nil
        }
        return freeSpace.int64Value
    }

    /// Calcula o espaço total do dispositivo
    var deviceTotalSpace: Int64? {
        guard let systemAttributes = try? attributesOfFileSystem(forPath: NSHomeDirectory()),
              let totalSpace = systemAttributes[.systemSize] as? NSNumber else {
            return nil
        }
        return totalSpace.int64Value
    }

    /// Verifica se há espaço suficiente no dispositivo
    /// - Parameter bytes: Quantidade de bytes necessários
    /// - Returns: true se há espaço suficiente (com margem de segurança de 100MB)
    func hasEnoughSpace(for bytes: Int64) -> Bool {
        guard let freeSpace = deviceFreeSpace else { return false }

        // Margem de segurança de 100MB
        let safetyMargin: Int64 = 100 * 1024 * 1024

        // Verifica overflow antes de somar
        // Se bytes é muito grande (próximo de Int64.max), a soma causaria overflow
        // Nesse caso, definitivamente não há espaço suficiente
        let (sum, overflow) = bytes.addingReportingOverflow(safetyMargin)

        if overflow {
            // Se houve overflow, o valor solicitado é absurdamente grande
            // Não há como ter espaço suficiente
            return false
        }

        return freeSpace > sum
    }
}

// MARK: - Supporting Types

public struct DirectorySizeInfo: Sendable {
    public let totalSize: Int
    public let fileCount: Int
    public let directoryCount: Int
    public let largestFile: (url: URL, size: Int)?
    public let sizeByExtension: [String: Int]

    public init(
        totalSize: Int,
        fileCount: Int,
        directoryCount: Int,
        largestFile: (url: URL, size: Int)?,
        sizeByExtension: [String: Int]
    ) {
        self.totalSize = totalSize
        self.fileCount = fileCount
        self.directoryCount = directoryCount
        self.largestFile = largestFile
        self.sizeByExtension = sizeByExtension
    }

    public var formattedTotalSize: String {
        ByteCountFormatter.string(fromByteCount: Int64(totalSize), countStyle: .binary)
    }

    public var averageFileSize: Int {
        fileCount > 0 ? totalSize / fileCount : 0
    }

    public var formattedAverageFileSize: String {
        ByteCountFormatter.string(fromByteCount: Int64(averageFileSize), countStyle: .binary)
    }

    public var topExtensions: [(extension: String, size: Int)] {
        sizeByExtension
            .sorted { $0.value > $1.value }
            .prefix(5)
            .map { ($0.key, $0.value) }
    }
}
