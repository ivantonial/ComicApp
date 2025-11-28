//
//  FileManagerExtensionsTests.swift
//  Cache
//
//  Created by Ivan Tonial IP.TV on 27/11/25.
//

@testable import Cache
import Foundation
import Testing
import XCTest

// MARK: - DirectorySizeInfo Tests

@Suite("DirectorySizeInfo Tests")
struct DirectorySizeInfoTests {

    @Test("formattedTotalSize should format bytes correctly")
    func testFormattedTotalSize() {
        // Arrange
        let info = DirectorySizeInfo(
            totalSize: 1024 * 1024, // 1 MB
            fileCount: 10,
            directoryCount: 2,
            largestFile: nil,
            sizeByExtension: [:]
        )

        // Assert
        #expect(info.formattedTotalSize == "1 MB")
    }

    @Test("formattedTotalSize should handle zero bytes")
    func testFormattedTotalSizeZero() {
        // Arrange
        let info = DirectorySizeInfo(
            totalSize: 0,
            fileCount: 0,
            directoryCount: 0,
            largestFile: nil,
            sizeByExtension: [:]
        )

        // Assert
        #expect(info.formattedTotalSize == "Zero KB")
    }

    @Test("formattedTotalSize should handle large sizes")
    func testFormattedTotalSizeLarge() {
        // Arrange
        let info = DirectorySizeInfo(
            totalSize: 1024 * 1024 * 1024, // 1 GB
            fileCount: 100,
            directoryCount: 10,
            largestFile: nil,
            sizeByExtension: [:]
        )

        // Assert
        #expect(info.formattedTotalSize == "1 GB")
    }

    @Test("averageFileSize should calculate correctly")
    func testAverageFileSize() {
        // Arrange
        let info = DirectorySizeInfo(
            totalSize: 1000,
            fileCount: 10,
            directoryCount: 0,
            largestFile: nil,
            sizeByExtension: [:]
        )

        // Assert
        #expect(info.averageFileSize == 100)
    }

    @Test("averageFileSize should return zero for empty directory")
    func testAverageFileSizeEmpty() {
        // Arrange
        let info = DirectorySizeInfo(
            totalSize: 0,
            fileCount: 0,
            directoryCount: 0,
            largestFile: nil,
            sizeByExtension: [:]
        )

        // Assert
        #expect(info.averageFileSize == 0)
    }

    @Test("formattedAverageFileSize should format correctly")
    func testFormattedAverageFileSize() {
        // Arrange
        let info = DirectorySizeInfo(
            totalSize: 10240, // 10 KB
            fileCount: 10,
            directoryCount: 0,
            largestFile: nil,
            sizeByExtension: [:]
        )

        // Assert
        #expect(info.formattedAverageFileSize == "1 KB")
    }

    @Test("topExtensions should return sorted extensions")
    func testTopExtensions() {
        // Arrange
        let info = DirectorySizeInfo(
            totalSize: 1000,
            fileCount: 10,
            directoryCount: 0,
            largestFile: nil,
            sizeByExtension: [
                "txt": 500,
                "json": 300,
                "xml": 200
            ]
        )

        // Act
        let top = info.topExtensions

        // Assert
        #expect(top.count == 3)
        #expect(top[0].extension == "txt")
        #expect(top[0].size == 500)
        #expect(top[1].extension == "json")
        #expect(top[2].extension == "xml")
    }

    @Test("topExtensions should limit to 5 results")
    func testTopExtensionsLimit() {
        // Arrange
        let info = DirectorySizeInfo(
            totalSize: 2100,
            fileCount: 7,
            directoryCount: 0,
            largestFile: nil,
            sizeByExtension: [
                "a": 100, "b": 200, "c": 300, "d": 400,
                "e": 500, "f": 600, "g": 700
            ]
        )

        // Act
        let top = info.topExtensions

        // Assert
        #expect(top.count == 5)
        #expect(top[0].extension == "g") // Maior primeiro
        #expect(top[4].extension == "c") // Quinto maior
    }

    @Test("topExtensions should handle empty sizeByExtension")
    func testTopExtensionsEmpty() {
        // Arrange
        let info = DirectorySizeInfo(
            totalSize: 0,
            fileCount: 0,
            directoryCount: 0,
            largestFile: nil,
            sizeByExtension: [:]
        )

        // Act
        let top = info.topExtensions

        // Assert
        #expect(top.isEmpty)
    }
}

// MARK: - FileManager Extension Tests (XCTest)

class FileManagerExtensionTests: XCTestCase {

    var tempDir: URL!

    override func setUp() {
        super.setUp()
        tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("FileManagerTest_\(UUID().uuidString)")
        try? FileManager.default.createDirectory(
            at: tempDir,
            withIntermediateDirectories: true
        )
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: tempDir)
        super.tearDown()
    }

    // MARK: - sizeOfDirectory Tests

    func testSizeOfEmptyDirectory() throws {
        let size = try FileManager.default.sizeOfDirectory(at: tempDir)
        XCTAssertEqual(size, 0)
    }

    func testSizeOfDirectoryWithFiles() throws {
        // Arrange
        let data = Data(repeating: 0xAB, count: 1024)
        for i in 0..<5 {
            let fileURL = tempDir.appendingPathComponent("file_\(i).txt")
            try data.write(to: fileURL)
        }

        // Act
        let size = try FileManager.default.sizeOfDirectory(at: tempDir)

        // Assert
        XCTAssertEqual(size, 1024 * 5)
    }

    func testSizeOfDirectoryWithSubdirectories() throws {
        // Arrange
        let subDir = tempDir.appendingPathComponent("subdir")
        try FileManager.default.createDirectory(at: subDir, withIntermediateDirectories: true)

        let data = Data(repeating: 0xCD, count: 512)
        try data.write(to: tempDir.appendingPathComponent("root_file.txt"))
        try data.write(to: subDir.appendingPathComponent("sub_file.txt"))

        // Act
        let size = try FileManager.default.sizeOfDirectory(at: tempDir)

        // Assert
        XCTAssertEqual(size, 512 * 2)
    }

    // MARK: - detailedSizeOfDirectory Tests

    func testDetailedSizeOfEmptyDirectory() throws {
        let info = try FileManager.default.detailedSizeOfDirectory(at: tempDir)

        XCTAssertEqual(info.totalSize, 0)
        XCTAssertEqual(info.fileCount, 0)
        XCTAssertEqual(info.directoryCount, 0)
        XCTAssertNil(info.largestFile)
    }

    func testDetailedSizeWithVariousExtensions() throws {
        // Arrange
        try Data(repeating: 0x11, count: 100).write(to: tempDir.appendingPathComponent("a.txt"))
        try Data(repeating: 0x22, count: 200).write(to: tempDir.appendingPathComponent("b.txt"))
        try Data(repeating: 0x33, count: 300).write(to: tempDir.appendingPathComponent("c.json"))

        // Act
        let info = try FileManager.default.detailedSizeOfDirectory(at: tempDir)

        // Assert
        XCTAssertEqual(info.totalSize, 600)
        XCTAssertEqual(info.fileCount, 3)
        XCTAssertEqual(info.sizeByExtension["txt"], 300)
        XCTAssertEqual(info.sizeByExtension["json"], 300)
    }

    func testDetailedSizeLargestFile() throws {
        // Arrange
        try Data(repeating: 0x11, count: 100).write(to: tempDir.appendingPathComponent("small.txt"))
        try Data(repeating: 0x22, count: 500).write(to: tempDir.appendingPathComponent("large.txt"))
        try Data(repeating: 0x33, count: 200).write(to: tempDir.appendingPathComponent("medium.txt"))

        // Act
        let info = try FileManager.default.detailedSizeOfDirectory(at: tempDir)

        // Assert
        XCTAssertNotNil(info.largestFile)
        XCTAssertEqual(info.largestFile?.size, 500)
        XCTAssertTrue(info.largestFile?.url.lastPathComponent == "large.txt")
    }

    // MARK: - Async Tests

    func testSizeOfDirectoryAsync() async throws {
        // Arrange
        let data = Data(repeating: 0xFF, count: 256)
        for i in 0..<3 {
            let fileURL = tempDir.appendingPathComponent("async_\(i).txt")
            try data.write(to: fileURL)
        }

        // Act
        let size = try await FileManager.default.sizeOfDirectoryAsync(at: tempDir)

        // Assert
        XCTAssertEqual(size, 256 * 3)
    }

    // MARK: - removeOldFiles Tests

    func testRemoveOldFiles() throws {
        // Arrange
        let data = Data(repeating: 0xEE, count: 128)
        let oldFile = tempDir.appendingPathComponent("old.txt")
        let newFile = tempDir.appendingPathComponent("new.txt")

        try data.write(to: oldFile)
        try data.write(to: newFile)

        // Modificar a data do arquivo antigo para 10 dias atrás
        let oldDate = Date().addingTimeInterval(-10 * 24 * 3600)
        try FileManager.default.setAttributes(
            [.modificationDate: oldDate],
            ofItemAtPath: oldFile.path
        )

        // Act
        let removedSize = try FileManager.default.removeOldFiles(from: tempDir, olderThan: 5)

        // Assert
        XCTAssertEqual(removedSize, 128)
        XCTAssertFalse(FileManager.default.fileExists(atPath: oldFile.path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: newFile.path))
    }

    // MARK: - Device Space Tests

    func testDeviceFreeSpace() {
        let freeSpace = FileManager.default.deviceFreeSpace
        XCTAssertNotNil(freeSpace)
        XCTAssertGreaterThan(freeSpace ?? 0, 0)
    }

    func testDeviceTotalSpace() {
        let totalSpace = FileManager.default.deviceTotalSpace
        XCTAssertNotNil(totalSpace)
        XCTAssertGreaterThan(totalSpace ?? 0, 0)
    }

    func testHasEnoughSpace() {
        // Deve haver espaço para 1 byte
        XCTAssertTrue(FileManager.default.hasEnoughSpace(for: 1))

        // Não deve haver espaço para um valor absurdamente grande
        XCTAssertFalse(FileManager.default.hasEnoughSpace(for: Int64.max))
    }
}

// MARK: - Swift Testing Extension Tests

@Suite("FileManager Size Calculations")
struct FileManagerSizeCalculationsTests {

    @Test("Size of directory should handle non-existent path gracefully")
    func testNonExistentPath() async throws {
        // Arrange
        let nonExistentURL = URL(fileURLWithPath: "/non/existent/path/\(UUID().uuidString)")

        // Act & Assert
        do {
            _ = try FileManager.default.sizeOfDirectory(at: nonExistentURL)
            Issue.record("Should have thrown an error")
        } catch {
            // Esperado
            #expect(true)
        }
    }

    @Test("Size calculation should be consistent")
    func testConsistentSizeCalculation() throws {
        // Arrange
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("ConsistentTest_\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let data = Data(repeating: 0xAA, count: 1000)
        try data.write(to: tempDir.appendingPathComponent("test.bin"))

        // Act
        let size1 = try FileManager.default.sizeOfDirectory(at: tempDir)
        let size2 = try FileManager.default.sizeOfDirectory(at: tempDir)

        // Assert
        #expect(size1 == size2)
        #expect(size1 == 1000)
    }
}
