//
//  CacheManagerTests.swift
//  Cache
//
//  Created by Ivan Tonial IP.TV on 27/11/25.
//

@testable import Cache
import ComicVineAPI
import Foundation
import Testing
import XCTest

// MARK: - MockCacheManager Tests

@Suite("MockCacheManager Tests")
struct MockCacheManagerTests {

    // MARK: - Save and Load Tests

    @Test("MockCacheManager should save and load objects")
    func testSaveAndLoad() async {
        // Arrange
        let cache = MockCacheManager()
        let testData = TestCodableObject(id: 1, name: "Test")

        // Act
        await cache.save(testData, forKey: "test_key")
        let loaded = await cache.load(TestCodableObject.self, forKey: "test_key")

        // Assert
        #expect(loaded?.id == 1)
        #expect(loaded?.name == "Test")
    }

    @Test("MockCacheManager should return nil for non-existent key")
    func testLoadNonExistent() async {
        // Arrange
        let cache = MockCacheManager()

        // Act
        let loaded = await cache.load(TestCodableObject.self, forKey: "non_existent")

        // Assert
        #expect(loaded == nil)
    }

    @Test("MockCacheManager should overwrite existing value")
    func testOverwrite() async {
        // Arrange
        let cache = MockCacheManager()
        let original = TestCodableObject(id: 1, name: "Original")
        let updated = TestCodableObject(id: 1, name: "Updated")

        // Act
        await cache.save(original, forKey: "key")
        await cache.save(updated, forKey: "key")
        let loaded = await cache.load(TestCodableObject.self, forKey: "key")

        // Assert
        #expect(loaded?.name == "Updated")
    }

    // MARK: - Remove Tests

    @Test("MockCacheManager should remove objects")
    func testRemove() async {
        // Arrange
        let cache = MockCacheManager()
        let testData = TestCodableObject(id: 1, name: "Test")
        await cache.save(testData, forKey: "test_key")

        // Act
        await cache.remove(forKey: "test_key")
        let loaded = await cache.load(TestCodableObject.self, forKey: "test_key")

        // Assert
        #expect(loaded == nil)
        let wasRemoved = await cache.wasKeyRemoved("test_key")
        #expect(wasRemoved)
    }

    @Test("MockCacheManager should track removed keys")
    func testTrackRemovedKeys() async {
        // Arrange
        let cache = MockCacheManager()
        await cache.save(TestCodableObject(id: 1, name: "1"), forKey: "key1")
        await cache.save(TestCodableObject(id: 2, name: "2"), forKey: "key2")

        // Act
        await cache.remove(forKey: "key1")
        await cache.remove(forKey: "key2")

        // Assert
        let removedCount = await cache.getRemovedKeysCount()
        let wasKey1Removed = await cache.wasKeyRemoved("key1")
        let wasKey2Removed = await cache.wasKeyRemoved("key2")
        #expect(removedCount == 2)
        #expect(wasKey1Removed)
        #expect(wasKey2Removed)
    }

    // MARK: - Clear All Tests

    @Test("MockCacheManager should clear all objects")
    func testClearAll() async {
        // Arrange
        let cache = MockCacheManager()
        await cache.save(TestCodableObject(id: 1, name: "Test1"), forKey: "key1")
        await cache.save(TestCodableObject(id: 2, name: "Test2"), forKey: "key2")

        // Act
        await cache.clearAll()

        // Assert
        let clearedAll = await cache.getClearedAll()
        // CORRIGIDO: Usar getSavedObjectsCount() em vez de savedObjects.isEmpty
        let savedCount = await cache.getSavedObjectsCount()
        #expect(clearedAll)
        #expect(savedCount == 0)
    }

    @Test("MockCacheManager clearAll should set flag")
    func testClearAllFlag() async {
        // Arrange
        let cache = MockCacheManager()

        // Act
        await cache.clearAll()

        // Assert
        let clearedAll = await cache.getClearedAll()
        #expect(clearedAll == true)
    }

    // MARK: - Cache Size Tests

    @Test("MockCacheManager should return mock cache size")
    func testGetCacheSize() async {
        // Arrange
        let cache = MockCacheManager()
        await cache.setMockCacheSize(1024)

        // Act
        let size = await cache.getCacheSize()

        // Assert
        #expect(size == 1024)
    }

    @Test("MockCacheManager should return zero for empty cache")
    func testEmptyCacheSize() async {
        // Arrange
        let cache = MockCacheManager()

        // Act
        let size = await cache.getCacheSize()

        // Assert
        #expect(size == 0)
    }

    // MARK: - Expiration Tests

    @Test("MockCacheManager should set expiration date")
    func testSetExpirationDate() async {
        // Arrange
        let cache = MockCacheManager()
        let futureDate = Date().addingTimeInterval(3600)

        // Act
        await cache.setExpirationDate(futureDate, forKey: "key")

        // Assert
        let storedDate = await cache.getExpirationDate(forKey: "key")
        #expect(storedDate == futureDate)
    }

    @Test("MockCacheManager should check if key is expired")
    func testIsExpired() async {
        // Arrange
        let cache = MockCacheManager()
        await cache.markAsExpired("expired_key")

        // Act
        let isExpired = await cache.isExpired(forKey: "expired_key")
        let isNotExpired = await cache.isExpired(forKey: "valid_key")

        // Assert
        #expect(isExpired == true)
        #expect(isNotExpired == false)
    }

    // MARK: - Method Call Tracking Tests

    @Test("MockCacheManager should track method calls")
    func testMethodCallTracking() async {
        // Arrange
        let cache = MockCacheManager()
        let testData = TestCodableObject(id: 1, name: "Test")

        // Act
        await cache.save(testData, forKey: "key")
        _ = await cache.load(TestCodableObject.self, forKey: "key")
        _ = await cache.getCacheSize()

        // Assert
        let saveCount = await cache.callCount(for: "save")
        let loadCount = await cache.callCount(for: "load")
        let getSizeCount = await cache.callCount(for: "getCacheSize")

        #expect(saveCount == 1)
        #expect(loadCount == 1)
        #expect(getSizeCount == 1)
    }

    // MARK: - Reset Tests

    @Test("MockCacheManager reset should clear all state")
    func testReset() async {
        // Arrange
        let cache = MockCacheManager()
        await cache.save(TestCodableObject(id: 1, name: "Test"), forKey: "key")
        await cache.remove(forKey: "other")
        await cache.clearAll()
        await cache.setMockCacheSize(1024)

        // Act
        await cache.reset()

        // Assert
        // CORRIGIDO: Usar métodos auxiliares em vez de acessar propriedades non-Sendable
        let savedCount = await cache.getSavedObjectsCount()
        let removedCount = await cache.getRemovedKeysCount()
        let clearedAll = await cache.getClearedAll()
        let mockCacheSize = await cache.getMockCacheSize()

        #expect(savedCount == 0)
        #expect(removedCount == 0)
        #expect(clearedAll == false)
        #expect(mockCacheSize == 0)
    }

    // MARK: - Helper Method Tests

    @Test("MockCacheManager hasKey should check existence")
    func testHasKey() async {
        // Arrange
        let cache = MockCacheManager()
        await cache.save(TestCodableObject(id: 1, name: "Test"), forKey: "existing")

        // Assert
        let hasExisting = await cache.hasKey("existing")
        let hasNonExisting = await cache.hasKey("non_existing")
        #expect(hasExisting == true)
        #expect(hasNonExisting == false)
    }
}

// MARK: - Async Cache Operations Tests

@Suite("Async Cache Operations Tests")
struct AsyncCacheOperationsTests {

    @Test("Concurrent cache operations should not crash")
    func testConcurrentOperations() async {
        // Arrange
        let cache = MockCacheManager()

        // Act - Executa operações concorrentes
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<50 {
                group.addTask {
                    let obj = TestCodableObject(id: i, name: "Object \(i)")
                    await cache.save(obj, forKey: "key_\(i)")
                }
            }
        }

        // Assert
        let savedCount = await cache.getSavedObjectsCount()
        #expect(savedCount == 50)
    }

    @Test("Sequential cache operations should work correctly")
    func testSequentialOperations() async {
        // Arrange
        let cache = MockCacheManager()

        // Act
        for i in 0..<10 {
            let obj = TestCodableObject(id: i, name: "Object \(i)")
            await cache.save(obj, forKey: "key_\(i)")
        }

        let count = await cache.getSavedObjectsCount()
        #expect(count == 10)

        // Verify saved correctly
        let loaded = await cache.load(TestCodableObject.self, forKey: "key_5")
        #expect(loaded?.id == 5)
        #expect(loaded?.name == "Object 5")
    }

    @Test("Cache clear should reset state")
    func testClearResetsState() async {
        // Arrange
        let cache = MockCacheManager()
        for i in 0..<5 {
            let obj = TestCodableObject(id: i, name: "Object \(i)")
            await cache.save(obj, forKey: "key_\(i)")
        }

        let countBefore = await cache.getSavedObjectsCount()
        #expect(countBefore == 5)

        // Act
        await cache.clearAll()

        // Assert
        let clearedAll = await cache.getClearedAll()
        let countAfter = await cache.getSavedObjectsCount()

        #expect(clearedAll == true)
        #expect(countAfter == 0)
    }

    @Test("Concurrent read and write should be safe")
    func testConcurrentReadWrite() async {
        // Arrange
        let cache = MockCacheManager()
        let testData = TestCodableObject(id: 1, name: "Test")
        await cache.save(testData, forKey: "shared_key")

        // Act - Concurrent reads and writes
        await withTaskGroup(of: Void.self) { group in
            // Readers
            for _ in 0..<10 {
                group.addTask {
                    _ = await cache.load(TestCodableObject.self, forKey: "shared_key")
                }
            }
            // Writers
            for i in 0..<10 {
                group.addTask {
                    await cache.save(TestCodableObject(id: i, name: "Updated \(i)"), forKey: "key_\(i)")
                }
            }
        }

        // Assert - Should complete without crash
        let count = await cache.getSavedObjectsCount()
        #expect(count >= 1)
    }
}

// MARK: - Integration Tests (XCTest)

class CacheIntegrationTests: XCTestCase {

    var tempCacheDir: URL!

    override func setUp() {
        super.setUp()
        tempCacheDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("TestCache_\(UUID().uuidString)")
        try? FileManager.default.createDirectory(
            at: tempCacheDir,
            withIntermediateDirectories: true
        )
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: tempCacheDir)
        super.tearDown()
    }

    func testCacheDirectoryCreation() {
        XCTAssertTrue(FileManager.default.fileExists(atPath: tempCacheDir.path))
    }

    func testWriteAndReadFromDisk() throws {
        let testData = "Test cache data".data(using: .utf8)!
        let fileURL = tempCacheDir.appendingPathComponent("test.cache")

        try testData.write(to: fileURL)
        let readData = try Data(contentsOf: fileURL)

        XCTAssertEqual(testData, readData)
    }

    func testEncodableObjectCaching() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let testObject = TestCodableObject(id: 42, name: "Cached Object")
        let fileURL = tempCacheDir.appendingPathComponent("object.json")

        let data = try encoder.encode(testObject)
        try data.write(to: fileURL)

        let readData = try Data(contentsOf: fileURL)
        let decodedObject = try decoder.decode(TestCodableObject.self, from: readData)

        XCTAssertEqual(testObject, decodedObject)
    }

    func testMultipleFilesInCache() throws {
        let testData = Data(repeating: 0xFF, count: 256)

        for i in 0..<5 {
            let fileURL = tempCacheDir.appendingPathComponent("file_\(i).cache")
            try testData.write(to: fileURL)
        }

        let size = try FileManager.default.sizeOfDirectory(at: tempCacheDir)
        XCTAssertEqual(size, 256 * 5)
    }

    func testCacheMetadataWithFile() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let metadata = CacheMetadata(expirationDate: Date().addingTimeInterval(3600))
        let fileURL = tempCacheDir.appendingPathComponent("test.meta")

        let data = try encoder.encode(metadata)
        try data.write(to: fileURL)

        let readData = try Data(contentsOf: fileURL)
        let decodedMeta = try decoder.decode(CacheMetadata.self, from: readData)

        XCTAssertEqual(
            decodedMeta.expirationDate.timeIntervalSince1970,
            metadata.expirationDate.timeIntervalSince1970,
            accuracy: 0.001
        )
    }
}
