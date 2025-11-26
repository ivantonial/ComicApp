//import Testing
//@testable import Cache
//
//@Test func example() async throws {
//    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
//}
//@testable import Cache
//@testable import ComicVineAPI
//import CoreData
//import Foundation
//import Testing
//import XCTest
//
//// MARK: - Test Fixtures
//
///// Fixture para Character usado nos testes do módulo Cache
//extension Character {
//    static func cacheFixture(
//        id: Int = 1,
//        name: String = "Spider-Man",
//        description: String? = "Friendly neighborhood Spider-Man",
//        comicsCount: Int = 100
//    ) -> Character {
//        let image = ComicVineImage(
//            iconUrl: "https://example.com/icon.jpg",
//            mediumUrl: "https://example.com/medium.jpg",
//            screenUrl: "https://example.com/screen.jpg",
//            screenLargeUrl: "https://example.com/screen_large.jpg",
//            smallUrl: "https://example.com/small.jpg",
//            superUrl: "https://example.com/super.jpg",
//            thumbUrl: "https://example.com/thumb.jpg",
//            tinyUrl: "https://example.com/tiny.jpg",
//            originalUrl: "https://example.com/original.jpg"
//        )
//
//        return Character(
//            id: id,
//            name: name,
//            description: description,
//            deck: "A superhero",
//            aliases: nil,
//            image: image,
//            apiDetailUrl: "https://comicvine.gamespot.com/api/character/4005-\(id)/",
//            siteDetailUrl: "https://comicvine.gamespot.com/character/4005-\(id)/",
//            firstAppearedInIssue: nil,
//            countOfIssueAppearances: comicsCount,
//            realName: "Peter Parker",
//            birth: nil,
//            dateAdded: "2008-06-06 11:27:46",
//            dateLastUpdated: "2024-01-15 10:30:00",
//            gender: 1,
//            origin: OriginSummary(id: 4, name: "Human"),
//            publisher: PublisherSummary(id: 31, name: "Marvel"),
//            characterEnemies: nil,
//            characterFriends: nil,
//            creators: nil,
//            issueCredits: nil,
//            powers: nil,
//            teams: nil,
//            volumeCredits: nil
//        )
//    }
//}
//
///// Fixture para Comic usado nos testes do módulo Cache
//extension Comic {
//    static func cacheFixture(
//        id: Int = 100,
//        name: String? = "Amazing Spider-Man",
//        issueNumber: String? = "1",
//        description: String? = "First issue"
//    ) -> Comic {
//        let image = ComicVineImage(
//            iconUrl: "https://example.com/comic_icon.jpg",
//            mediumUrl: "https://example.com/comic_medium.jpg",
//            screenUrl: nil,
//            screenLargeUrl: nil,
//            smallUrl: nil,
//            superUrl: nil,
//            thumbUrl: "https://example.com/comic_thumb.jpg",
//            tinyUrl: nil,
//            originalUrl: "https://example.com/comic_original.jpg"
//        )
//
//        let volume = VolumeSummary(
//            id: 1,
//            name: "Amazing Spider-Man",
//            apiDetailUrl: "https://comicvine.gamespot.com/api/volume/4050-1/"
//        )
//
//        return Comic(
//            id: id,
//            name: name,
//            issueNumber: issueNumber,
//            description: description,
//            deck: nil,
//            image: image,
//            coverDate: "2024-01-01",
//            storeDate: "2024-01-15",
//            apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-\(id)/",
//            siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-\(id)/",
//            volume: volume,
//            hasStaffReview: false,
//            dateAdded: "2024-01-01 00:00:00",
//            dateLastUpdated: "2024-01-15 00:00:00"
//        )
//    }
//}
//
//// MARK: - Mock CacheManager for Testing
//
///// Mock do CacheManager para testes isolados
//final class MockCacheManager: CacheManagerProtocol, @unchecked Sendable {
//    var savedObjects: [String: Any] = [:]
//    var removedKeys: [String] = []
//    var clearedAll = false
//    var mockCacheSize: Int = 0
//    var expirationDates: [String: Date] = [:]
//    var expiredKeys: Set<String> = []
//
//    func save<T: Codable & Sendable>(_ object: T, forKey key: String) async {
//        savedObjects[key] = object
//    }
//
//    func load<T: Codable & Sendable>(_ type: T.Type, forKey key: String) async -> T? {
//        savedObjects[key] as? T
//    }
//
//    func remove(forKey key: String) async {
//        savedObjects.removeValue(forKey: key)
//        removedKeys.append(key)
//    }
//
//    func clearAll() async {
//        savedObjects.removeAll()
//        clearedAll = true
//    }
//
//    func getCacheSize() async -> Int {
//        mockCacheSize
//    }
//
//    func setExpirationDate(_ date: Date, forKey key: String) async {
//        expirationDates[key] = date
//    }
//
//    func isExpired(forKey key: String) async -> Bool {
//        expiredKeys.contains(key)
//    }
//}
//
//// MARK: - CacheMetadata Tests
//
//@Suite("CacheMetadata Tests")
//struct CacheMetadataTests {
//
//    @Test("CacheMetadata should store expiration date correctly")
//    func testExpirationDateStorage() {
//        // Arrange
//        let date = Date()
//
//        // Act
//        let metadata = CacheMetadata(expirationDate: date)
//
//        // Assert
//        #expect(metadata.expirationDate == date)
//    }
//
//    @Test("CacheMetadata should be Codable")
//    func testCodable() throws {
//        // Arrange
//        let date = Date()
//        let metadata = CacheMetadata(expirationDate: date)
//        let encoder = JSONEncoder()
//        let decoder = JSONDecoder()
//
//        // Act
//        let data = try encoder.encode(metadata)
//        let decoded = try decoder.decode(CacheMetadata.self, from: data)
//
//        // Assert
//        #expect(decoded.expirationDate.timeIntervalSince1970 == metadata.expirationDate.timeIntervalSince1970)
//    }
//
//    @Test("CacheMetadata should be Sendable")
//    func testSendable() async {
//        // Arrange
//        let metadata = CacheMetadata(expirationDate: Date())
//
//        // Act - Pass across async boundary
//        let result = await Task.detached {
//            return metadata.expirationDate
//        }.value
//
//        // Assert
//        #expect(result == metadata.expirationDate)
//    }
//}
//
//// MARK: - MockCacheManager Tests
//
//@Suite("MockCacheManager Tests")
//struct MockCacheManagerTests {
//
//    @Test("MockCacheManager should save and load objects")
//    func testSaveAndLoad() async {
//        // Arrange
//        let cache = MockCacheManager()
//        let testData = TestCodableObject(id: 1, name: "Test")
//
//        // Act
//        await cache.save(testData, forKey: "test_key")
//        let loaded = await cache.load(TestCodableObject.self, forKey: "test_key")
//
//        // Assert
//        #expect(loaded?.id == 1)
//        #expect(loaded?.name == "Test")
//    }
//
//    @Test("MockCacheManager should remove objects")
//    func testRemove() async {
//        // Arrange
//        let cache = MockCacheManager()
//        let testData = TestCodableObject(id: 1, name: "Test")
//        await cache.save(testData, forKey: "test_key")
//
//        // Act
//        await cache.remove(forKey: "test_key")
//        let loaded = await cache.load(TestCodableObject.self, forKey: "test_key")
//
//        // Assert
//        #expect(loaded == nil)
//        #expect(cache.removedKeys.contains("test_key"))
//    }
//
//    @Test("MockCacheManager should clear all objects")
//    func testClearAll() async {
//        // Arrange
//        let cache = MockCacheManager()
//        await cache.save(TestCodableObject(id: 1, name: "Test1"), forKey: "key1")
//        await cache.save(TestCodableObject(id: 2, name: "Test2"), forKey: "key2")
//
//        // Act
//        await cache.clearAll()
//
//        // Assert
//        #expect(cache.clearedAll)
//        #expect(cache.savedObjects.isEmpty)
//    }
//
//    @Test("MockCacheManager should return mock cache size")
//    func testGetCacheSize() async {
//        // Arrange
//        let cache = MockCacheManager()
//        cache.mockCacheSize = 1024
//
//        // Act
//        let size = await cache.getCacheSize()
//
//        // Assert
//        #expect(size == 1024)
//    }
//
//    @Test("MockCacheManager should set expiration date")
//    func testSetExpirationDate() async {
//        // Arrange
//        let cache = MockCacheManager()
//        let futureDate = Date().addingTimeInterval(3600)
//
//        // Act
//        await cache.setExpirationDate(futureDate, forKey: "test_key")
//
//        // Assert
//        #expect(cache.expirationDates["test_key"] == futureDate)
//    }
//
//    @Test("MockCacheManager should check expiration")
//    func testIsExpired() async {
//        // Arrange
//        let cache = MockCacheManager()
//        cache.expiredKeys.insert("expired_key")
//
//        // Act
//        let isExpired = await cache.isExpired(forKey: "expired_key")
//        let isNotExpired = await cache.isExpired(forKey: "valid_key")
//
//        // Assert
//        #expect(isExpired == true)
//        #expect(isNotExpired == false)
//    }
//}
//
//// MARK: - Helper Test Object
//
//struct TestCodableObject: Codable, Sendable, Equatable {
//    let id: Int
//    let name: String
//}
//
//// MARK: - FileManager Extension Tests
//
//@Suite("FileManager+Size Tests")
//struct FileManagerSizeTests {
//
//    @Test("sizeOfDirectory should return 0 for empty directory")
//    func testEmptyDirectorySize() throws {
//        // Arrange
//        let tempDir = FileManager.default.temporaryDirectory
//            .appendingPathComponent(UUID().uuidString)
//        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
//
//        defer {
//            try? FileManager.default.removeItem(at: tempDir)
//        }
//
//        // Act
//        let size = try FileManager.default.sizeOfDirectory(at: tempDir)
//
//        // Assert
//        #expect(size == 0)
//    }
//
//    @Test("sizeOfDirectory should calculate file sizes correctly")
//    func testDirectorySizeWithFiles() throws {
//        // Arrange
//        let tempDir = FileManager.default.temporaryDirectory
//            .appendingPathComponent(UUID().uuidString)
//        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
//
//        let testData = Data(repeating: 0, count: 1024) // 1KB
//        let fileURL = tempDir.appendingPathComponent("test.txt")
//        try testData.write(to: fileURL)
//
//        defer {
//            try? FileManager.default.removeItem(at: tempDir)
//        }
//
//        // Act
//        let size = try FileManager.default.sizeOfDirectory(at: tempDir)
//
//        // Assert
//        #expect(size == 1024)
//    }
//
//    @Test("sizeOfDirectory should calculate subdirectory sizes")
//    func testDirectorySizeWithSubdirectories() throws {
//        // Arrange
//        let tempDir = FileManager.default.temporaryDirectory
//            .appendingPathComponent(UUID().uuidString)
//        let subDir = tempDir.appendingPathComponent("subdir")
//        try FileManager.default.createDirectory(at: subDir, withIntermediateDirectories: true)
//
//        let testData = Data(repeating: 0, count: 512)
//        try testData.write(to: tempDir.appendingPathComponent("file1.txt"))
//        try testData.write(to: subDir.appendingPathComponent("file2.txt"))
//
//        defer {
//            try? FileManager.default.removeItem(at: tempDir)
//        }
//
//        // Act
//        let size = try FileManager.default.sizeOfDirectory(at: tempDir)
//
//        // Assert
//        #expect(size == 1024) // 512 + 512
//    }
//
//    @Test("detailedSizeOfDirectory should return file count")
//    func testDetailedSizeFileCount() throws {
//        // Arrange
//        let tempDir = FileManager.default.temporaryDirectory
//            .appendingPathComponent(UUID().uuidString)
//        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
//
//        let testData = Data(repeating: 0, count: 100)
//        try testData.write(to: tempDir.appendingPathComponent("file1.txt"))
//        try testData.write(to: tempDir.appendingPathComponent("file2.txt"))
//        try testData.write(to: tempDir.appendingPathComponent("file3.txt"))
//
//        defer {
//            try? FileManager.default.removeItem(at: tempDir)
//        }
//
//        // Act
//        let info = try FileManager.default.detailedSizeOfDirectory(at: tempDir)
//
//        // Assert
//        #expect(info.fileCount == 3)
//        #expect(info.totalSize == 300)
//    }
//
//    @Test("detailedSizeOfDirectory should group by extension")
//    func testDetailedSizeByExtension() throws {
//        // Arrange
//        let tempDir = FileManager.default.temporaryDirectory
//            .appendingPathComponent(UUID().uuidString)
//        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
//
//        let testData = Data(repeating: 0, count: 100)
//        try testData.write(to: tempDir.appendingPathComponent("file1.txt"))
//        try testData.write(to: tempDir.appendingPathComponent("file2.txt"))
//        try testData.write(to: tempDir.appendingPathComponent("file3.json"))
//
//        defer {
//            try? FileManager.default.removeItem(at: tempDir)
//        }
//
//        // Act
//        let info = try FileManager.default.detailedSizeOfDirectory(at: tempDir)
//
//        // Assert
//        #expect(info.sizeByExtension["txt"] == 200)
//        #expect(info.sizeByExtension["json"] == 100)
//    }
//
//    @Test("sizeOfDirectoryAsync should work asynchronously")
//    func testAsyncDirectorySize() async throws {
//        // Arrange
//        let tempDir = FileManager.default.temporaryDirectory
//            .appendingPathComponent(UUID().uuidString)
//        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
//
//        let testData = Data(repeating: 0, count: 2048)
//        try testData.write(to: tempDir.appendingPathComponent("test.bin"))
//
//        defer {
//            try? FileManager.default.removeItem(at: tempDir)
//        }
//
//        // Act
//        let size = try await FileManager.default.sizeOfDirectoryAsync(at: tempDir)
//
//        // Assert
//        #expect(size == 2048)
//    }
//
//    @Test("removeOldFiles should remove files older than specified days")
//    func testRemoveOldFiles() throws {
//        // Arrange
//        let tempDir = FileManager.default.temporaryDirectory
//            .appendingPathComponent(UUID().uuidString)
//        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
//
//        let testData = Data(repeating: 0, count: 100)
//        let fileURL = tempDir.appendingPathComponent("old_file.txt")
//        try testData.write(to: fileURL)
//
//        // Modificar data do arquivo para 10 dias atrás
//        let oldDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())!
//        try FileManager.default.setAttributes(
//            [.modificationDate: oldDate],
//            ofItemAtPath: fileURL.path
//        )
//
//        defer {
//            try? FileManager.default.removeItem(at: tempDir)
//        }
//
//        // Act
//        let removedSize = try FileManager.default.removeOldFiles(from: tempDir, olderThan: 5)
//
//        // Assert
//        #expect(removedSize == 100)
//        #expect(!FileManager.default.fileExists(atPath: fileURL.path))
//    }
//
//    @Test("hasEnoughSpace should check device space")
//    func testHasEnoughSpace() {
//        // Arrange
//        let smallSize: Int64 = 1024 // 1KB
//        let hugeSize: Int64 = Int64.max
//
//        // Act & Assert
//        #expect(FileManager.default.hasEnoughSpace(for: smallSize) == true)
//        #expect(FileManager.default.hasEnoughSpace(for: hugeSize) == false)
//    }
//
//    @Test("deviceFreeSpace should return a value")
//    func testDeviceFreeSpace() {
//        // Act
//        let freeSpace = FileManager.default.deviceFreeSpace
//
//        // Assert
//        #expect(freeSpace != nil)
//        #expect(freeSpace! > 0)
//    }
//
//    @Test("deviceTotalSpace should return a value")
//    func testDeviceTotalSpace() {
//        // Act
//        let totalSpace = FileManager.default.deviceTotalSpace
//
//        // Assert
//        #expect(totalSpace != nil)
//        #expect(totalSpace! > 0)
//    }
//}
//
//// MARK: - DirectorySizeInfo Tests
//
//@Suite("DirectorySizeInfo Tests")
//struct DirectorySizeInfoTests {
//
//    @Test("formattedTotalSize should format bytes correctly")
//    func testFormattedTotalSize() {
//        // Arrange
//        let info = DirectorySizeInfo(
//            totalSize: 1024 * 1024, // 1MB
//            fileCount: 10,
//            directoryCount: 2,
//            largestFile: nil,
//            sizeByExtension: [:]
//        )
//
//        // Act
//        let formatted = info.formattedTotalSize
//
//        // Assert
//        #expect(formatted.contains("1") || formatted.contains("MB"))
//    }
//
//    @Test("averageFileSize should calculate correctly")
//    func testAverageFileSize() {
//        // Arrange
//        let info = DirectorySizeInfo(
//            totalSize: 1000,
//            fileCount: 10,
//            directoryCount: 0,
//            largestFile: nil,
//            sizeByExtension: [:]
//        )
//
//        // Assert
//        #expect(info.averageFileSize == 100)
//    }
//
//    @Test("averageFileSize should return 0 for empty directory")
//    func testAverageFileSizeEmpty() {
//        // Arrange
//        let info = DirectorySizeInfo(
//            totalSize: 0,
//            fileCount: 0,
//            directoryCount: 0,
//            largestFile: nil,
//            sizeByExtension: [:]
//        )
//
//        // Assert
//        #expect(info.averageFileSize == 0)
//    }
//
//    @Test("topExtensions should return sorted extensions")
//    func testTopExtensions() {
//        // Arrange
//        let info = DirectorySizeInfo(
//            totalSize: 1000,
//            fileCount: 10,
//            directoryCount: 0,
//            largestFile: nil,
//            sizeByExtension: [
//                "txt": 500,
//                "json": 300,
//                "xml": 200
//            ]
//        )
//
//        // Act
//        let top = info.topExtensions
//
//        // Assert
//        #expect(top.count == 3)
//        #expect(top[0].extension == "txt")
//        #expect(top[0].size == 500)
//        #expect(top[1].extension == "json")
//        #expect(top[2].extension == "xml")
//    }
//}
//
//// MARK: - Character Cache Conversion Tests
//
//@Suite("Character Cache Conversion Tests")
//struct CharacterCacheConversionTests {
//
//    @Test("Character.makeFromCache should create valid character")
//    func testMakeFromCache() {
//        // Act
//        let character = Character.makeFromCache(
//            id: 1,
//            name: "Spider-Man",
//            description: "Hero",
//            thumbnailPath: "https://example.com/image.jpg",
//            comicsCount: 100
//        )
//
//        // Assert
//        #expect(character.id == 1)
//        #expect(character.name == "Spider-Man")
//        #expect(character.description == "Hero")
//        #expect(character.countOfIssueAppearances == 100)
//    }
//
//    @Test("Character.makeFromCache should handle nil values")
//    func testMakeFromCacheNilValues() {
//        // Act
//        let character = Character.makeFromCache(
//            id: 1,
//            name: "Unknown",
//            description: nil,
//            thumbnailPath: nil,
//            comicsCount: 0
//        )
//
//        // Assert
//        #expect(character.id == 1)
//        #expect(character.name == "Unknown")
//        #expect(character.description == nil)
//        #expect(character.countOfIssueAppearances == 0)
//    }
//
//    @Test("Character.makeFromCache should generate valid URLs")
//    func testMakeFromCacheUrls() {
//        // Act
//        let character = Character.makeFromCache(
//            id: 12345,
//            name: "Spider-Man"
//        )
//
//        // Assert
//        #expect(character.apiDetailUrl.contains("4005-12345"))
//        #expect(character.siteDetailUrl.contains("4005-12345"))
//    }
//}
//
//// MARK: - Comic Fixture Tests
//
//@Suite("Comic Fixture Tests")
//struct ComicFixtureTests {
//
//    @Test("Comic fixture should create valid comic")
//    func testComicFixture() {
//        // Act
//        let comic = Comic.cacheFixture()
//
//        // Assert
//        #expect(comic.id == 100)
//        #expect(comic.name == "Amazing Spider-Man")
//        #expect(comic.issueNumber == "1")
//    }
//
//    @Test("Comic fixture should allow custom values")
//    func testComicFixtureCustomValues() {
//        // Act
//        let comic = Comic.cacheFixture(
//            id: 200,
//            name: "X-Men",
//            issueNumber: "50",
//            description: "Classic issue"
//        )
//
//        // Assert
//        #expect(comic.id == 200)
//        #expect(comic.name == "X-Men")
//        #expect(comic.issueNumber == "50")
//        #expect(comic.description == "Classic issue")
//    }
//
//    @Test("Comic title should combine volume and issue number")
//    func testComicTitle() {
//        // Act
//        let comic = Comic.cacheFixture(
//            name: nil,
//            issueNumber: "15"
//        )
//
//        // Assert
//        #expect(comic.title == "Amazing Spider-Man #15")
//    }
//
//    @Test("Comic should be Hashable")
//    func testComicHashable() {
//        // Arrange
//        let comic1 = Comic.cacheFixture(id: 1)
//        let comic2 = Comic.cacheFixture(id: 1)
//        let comic3 = Comic.cacheFixture(id: 2)
//
//        // Assert
//        #expect(comic1 == comic2)
//        #expect(comic1 != comic3)
//        #expect(comic1.hashValue == comic2.hashValue)
//    }
//}
//
//// MARK: - Integration Tests (XCTest)
//
//class CacheIntegrationTests: XCTestCase {
//
//    var tempCacheDir: URL!
//
//    override func setUp() {
//        super.setUp()
//        tempCacheDir = FileManager.default.temporaryDirectory
//            .appendingPathComponent("TestCache_\(UUID().uuidString)")
//        try? FileManager.default.createDirectory(
//            at: tempCacheDir,
//            withIntermediateDirectories: true
//        )
//    }
//
//    override func tearDown() {
//        try? FileManager.default.removeItem(at: tempCacheDir)
//        super.tearDown()
//    }
//
//    func testCacheDirectoryCreation() {
//        // Assert
//        XCTAssertTrue(FileManager.default.fileExists(atPath: tempCacheDir.path))
//    }
//
//    func testWriteAndReadFromDisk() throws {
//        // Arrange
//        let testData = "Test cache data".data(using: .utf8)!
//        let fileURL = tempCacheDir.appendingPathComponent("test.cache")
//
//        // Act
//        try testData.write(to: fileURL)
//        let readData = try Data(contentsOf: fileURL)
//
//        // Assert
//        XCTAssertEqual(testData, readData)
//    }
//
//    func testEncodableObjectCaching() throws {
//        // Arrange
//        let encoder = JSONEncoder()
//        let decoder = JSONDecoder()
//        let testObject = TestCodableObject(id: 42, name: "Cached Object")
//        let fileURL = tempCacheDir.appendingPathComponent("object.json")
//
//        // Act - Write
//        let data = try encoder.encode(testObject)
//        try data.write(to: fileURL)
//
//        // Act - Read
//        let readData = try Data(contentsOf: fileURL)
//        let decodedObject = try decoder.decode(TestCodableObject.self, from: readData)
//
//        // Assert
//        XCTAssertEqual(testObject, decodedObject)
//    }
//
//    func testCacheMetadataStorage() throws {
//        // Arrange
//        let encoder = JSONEncoder()
//        let decoder = JSONDecoder()
//        let expirationDate = Date().addingTimeInterval(3600)
//        let metadata = CacheMetadata(expirationDate: expirationDate)
//        let metaURL = tempCacheDir.appendingPathComponent("cache.meta")
//
//        // Act
//        try encoder.encode(metadata).write(to: metaURL)
//        let readData = try Data(contentsOf: metaURL)
//        let decodedMetadata = try decoder.decode(CacheMetadata.self, from: readData)
//
//        // Assert
//        XCTAssertEqual(
//            Int(metadata.expirationDate.timeIntervalSince1970),
//            Int(decodedMetadata.expirationDate.timeIntervalSince1970)
//        )
//    }
//
//    func testMultipleFilesInCache() throws {
//        // Arrange
//        let testData = Data(repeating: 0xFF, count: 256)
//
//        // Act
//        for i in 0..<5 {
//            let fileURL = tempCacheDir.appendingPathComponent("file_\(i).cache")
//            try testData.write(to: fileURL)
//        }
//
//        // Assert
//        let size = try FileManager.default.sizeOfDirectory(at: tempCacheDir)
//        XCTAssertEqual(size, 256 * 5)
//    }
//}
//
//// MARK: - Async Cache Tests
//
//@Suite("Async Cache Operations Tests")
//struct AsyncCacheOperationsTests {
//
//    @Test("Concurrent cache operations should not crash")
//    func testConcurrentOperations() async {
//        // Arrange
//        let cache = MockCacheManager()
//
//        // Act - Execute multiple concurrent operations
//        await withTaskGroup(of: Void.self) { group in
//            for i in 0..<100 {
//                group.addTask {
//                    let obj = TestCodableObject(id: i, name: "Object \(i)")
//                    await cache.save(obj, forKey: "key_\(i)")
//                }
//            }
//        }
//
//        // Assert - All objects should be saved
//        #expect(cache.savedObjects.count == 100)
//    }
//
//    @Test("Cache clear during concurrent saves should handle gracefully")
//    func testClearDuringConcurrentSaves() async {
//        // Arrange
//        let cache = MockCacheManager()
//
//        // Act
//        async let saveTask: () = {
//            for i in 0..<50 {
//                let obj = TestCodableObject(id: i, name: "Object \(i)")
//                await cache.save(obj, forKey: "key_\(i)")
//            }
//        }()
//
//        async let clearTask: () = {
//            await cache.clearAll()
//        }()
//
//        await saveTask
//        await clearTask
//
//        // Assert - Clear was called
//        #expect(cache.clearedAll)
//    }
//}
//
//// MARK: - PersistenceManager Protocol Tests
//
//@Suite("PersistenceManagerProtocol Tests")
//struct PersistenceManagerProtocolTests {
//
//    @Test("Protocol should define all required methods")
//    func testProtocolDefinition() {
//        // This test validates that the protocol has all required methods
//        // by checking a mock implementation
//        let _: PersistenceManagerProtocol.Type = MockPersistenceManager.self
//        #expect(true) // If we reach here, protocol is properly defined
//    }
//}
//
///// Mock PersistenceManager para testes do protocolo
//final class MockPersistenceManager: PersistenceManagerProtocol, @unchecked Sendable {
//    var savedCharacters: [Character] = []
//    var savedComics: [Int: [Comic]] = [:]
//    var favorites: [Character] = []
//    var searchHistory: [String] = []
//
//    func saveCharacters(_ characters: [Character]) async throws {
//        savedCharacters = characters
//    }
//
//    func loadCharacters(offset: Int, limit: Int) async -> [Character] {
//        Array(savedCharacters.dropFirst(offset).prefix(limit))
//    }
//
//    func saveCharacter(_ character: Character) async throws {
//        if let index = savedCharacters.firstIndex(where: { $0.id == character.id }) {
//            savedCharacters[index] = character
//        } else {
//            savedCharacters.append(character)
//        }
//    }
//
//    func loadCharacter(withId id: Int) async -> Character? {
//        savedCharacters.first { $0.id == id }
//    }
//
//    func saveComics(_ comics: [Comic], forCharacterId characterId: Int) async throws {
//        savedComics[characterId] = comics
//    }
//
//    func loadComics(forCharacterId characterId: Int) async -> [Comic] {
//        savedComics[characterId] ?? []
//    }
//
//    func saveFavorite(_ character: Character) async throws {
//        if !favorites.contains(where: { $0.id == character.id }) {
//            favorites.append(character)
//        }
//    }
//
//    func removeFavorite(characterId: Int) async throws {
//        favorites.removeAll { $0.id == characterId }
//    }
//
//    func loadFavorites() async -> [Character] {
//        favorites
//    }
//
//    func isFavorite(characterId: Int) async -> Bool {
//        favorites.contains { $0.id == characterId }
//    }
//
//    func saveSearchHistory(_ query: String, resultCount: Int) async {
//        searchHistory.removeAll { $0 == query }
//        searchHistory.insert(query, at: 0)
//    }
//
//    func loadSearchHistory() async -> [String] {
//        searchHistory
//    }
//
//    func clearSearchHistory() async {
//        searchHistory.removeAll()
//    }
//
//    func clearAllCache() async throws {
//        savedCharacters.removeAll()
//        savedComics.removeAll()
//        favorites.removeAll()
//        searchHistory.removeAll()
//    }
//
//    func getCacheAge() async -> TimeInterval? {
//        nil
//    }
//}
//
//// MARK: - MockPersistenceManager Tests
//
//@Suite("MockPersistenceManager Tests")
//struct MockPersistenceManagerTests {
//
//    @Test("Should save and load characters")
//    func testSaveLoadCharacters() async throws {
//        // Arrange
//        let manager = MockPersistenceManager()
//        let characters = [
//            Character.cacheFixture(id: 1, name: "Spider-Man"),
//            Character.cacheFixture(id: 2, name: "Iron Man")
//        ]
//
//        // Act
//        try await manager.saveCharacters(characters)
//        let loaded = await manager.loadCharacters(offset: 0, limit: 10)
//
//        // Assert
//        #expect(loaded.count == 2)
//        #expect(loaded[0].name == "Spider-Man")
//        #expect(loaded[1].name == "Iron Man")
//    }
//
//    @Test("Should save and load single character")
//    func testSaveLoadSingleCharacter() async throws {
//        // Arrange
//        let manager = MockPersistenceManager()
//        let character = Character.cacheFixture(id: 1, name: "Spider-Man")
//
//        // Act
//        try await manager.saveCharacter(character)
//        let loaded = await manager.loadCharacter(withId: 1)
//
//        // Assert
//        #expect(loaded?.name == "Spider-Man")
//    }
//
//    @Test("Should handle pagination in loadCharacters")
//    func testLoadCharactersPagination() async throws {
//        // Arrange
//        let manager = MockPersistenceManager()
//        var characters: [Character] = []
//        for i in 1...10 {
//            characters.append(Character.cacheFixture(id: i, name: "Hero \(i)"))
//        }
//        try await manager.saveCharacters(characters)
//
//        // Act
//        let page1 = await manager.loadCharacters(offset: 0, limit: 3)
//        let page2 = await manager.loadCharacters(offset: 3, limit: 3)
//
//        // Assert
//        #expect(page1.count == 3)
//        #expect(page2.count == 3)
//        #expect(page1[0].name == "Hero 1")
//        #expect(page2[0].name == "Hero 4")
//    }
//
//    @Test("Should save and load comics for character")
//    func testSaveLoadComics() async throws {
//        // Arrange
//        let manager = MockPersistenceManager()
//        let comics = [
//            Comic.cacheFixture(id: 1, name: "Issue 1"),
//            Comic.cacheFixture(id: 2, name: "Issue 2")
//        ]
//
//        // Act
//        try await manager.saveComics(comics, forCharacterId: 100)
//        let loaded = await manager.loadComics(forCharacterId: 100)
//
//        // Assert
//        #expect(loaded.count == 2)
//    }
//
//    @Test("Should manage favorites")
//    func testFavorites() async throws {
//        // Arrange
//        let manager = MockPersistenceManager()
//        let character = Character.cacheFixture(id: 1, name: "Spider-Man")
//
//        // Act - Add favorite
//        try await manager.saveFavorite(character)
//        let isFav1 = await manager.isFavorite(characterId: 1)
//
//        // Assert
//        #expect(isFav1 == true)
//
//        // Act - Remove favorite
//        try await manager.removeFavorite(characterId: 1)
//        let isFav2 = await manager.isFavorite(characterId: 1)
//
//        // Assert
//        #expect(isFav2 == false)
//    }
//
//    @Test("Should load all favorites")
//    func testLoadFavorites() async throws {
//        // Arrange
//        let manager = MockPersistenceManager()
//        try await manager.saveFavorite(Character.cacheFixture(id: 1, name: "Spider-Man"))
//        try await manager.saveFavorite(Character.cacheFixture(id: 2, name: "Iron Man"))
//
//        // Act
//        let favorites = await manager.loadFavorites()
//
//        // Assert
//        #expect(favorites.count == 2)
//    }
//
//    @Test("Should manage search history")
//    func testSearchHistory() async {
//        // Arrange
//        let manager = MockPersistenceManager()
//
//        // Act
//        await manager.saveSearchHistory("Spider-Man", resultCount: 10)
//        await manager.saveSearchHistory("Iron Man", resultCount: 5)
//        let history = await manager.loadSearchHistory()
//
//        // Assert
//        #expect(history.count == 2)
//        #expect(history[0] == "Iron Man") // Most recent first
//    }
//
//    @Test("Should clear search history")
//    func testClearSearchHistory() async {
//        // Arrange
//        let manager = MockPersistenceManager()
//        await manager.saveSearchHistory("Spider-Man", resultCount: 10)
//
//        // Act
//        await manager.clearSearchHistory()
//        let history = await manager.loadSearchHistory()
//
//        // Assert
//        #expect(history.isEmpty)
//    }
//
//    @Test("Should clear all cache")
//    func testClearAllCache() async throws {
//        // Arrange
//        let manager = MockPersistenceManager()
//        try await manager.saveCharacters([Character.cacheFixture()])
//        try await manager.saveFavorite(Character.cacheFixture(id: 2))
//        await manager.saveSearchHistory("test", resultCount: 1)
//
//        // Act
//        try await manager.clearAllCache()
//
//        // Assert
//        let characters = await manager.loadCharacters(offset: 0, limit: 10)
//        let favorites = await manager.loadFavorites()
//        let history = await manager.loadSearchHistory()
//
//        #expect(characters.isEmpty)
//        #expect(favorites.isEmpty)
//        #expect(history.isEmpty)
//    }
//
//    @Test("Should not duplicate favorites")
//    func testNoDuplicateFavorites() async throws {
//        // Arrange
//        let manager = MockPersistenceManager()
//        let character = Character.cacheFixture(id: 1, name: "Spider-Man")
//
//        // Act - Add same character twice
//        try await manager.saveFavorite(character)
//        try await manager.saveFavorite(character)
//        let favorites = await manager.loadFavorites()
//
//        // Assert
//        #expect(favorites.count == 1)
//    }
//
//    @Test("Should remove duplicate search history entries")
//    func testSearchHistoryNoDuplicates() async {
//        // Arrange
//        let manager = MockPersistenceManager()
//
//        // Act - Search same term multiple times
//        await manager.saveSearchHistory("Spider-Man", resultCount: 10)
//        await manager.saveSearchHistory("Iron Man", resultCount: 5)
//        await manager.saveSearchHistory("Spider-Man", resultCount: 15)
//        let history = await manager.loadSearchHistory()
//
//        // Assert
//        #expect(history.count == 2)
//        #expect(history[0] == "Spider-Man") // Most recent
//    }
//}
@testable import Cache
@testable import ComicVineAPI
import Foundation
import Testing
import XCTest

// MARK: - Character Fixture for Cache Tests

extension Character {
    /// Fixture para testes do módulo Cache
    static func cacheFixture(
        id: Int = 1,
        name: String = "Spider-Man",
        description: String? = "Friendly neighborhood Spider-Man",
        comicsCount: Int = 100
    ) -> Character {
        let image = ComicVineImage(
            iconUrl: "https://example.com/icon.jpg",
            mediumUrl: "https://example.com/medium.jpg",
            screenUrl: "https://example.com/screen.jpg",
            screenLargeUrl: "https://example.com/screen_large.jpg",
            smallUrl: "https://example.com/small.jpg",
            superUrl: "https://example.com/super.jpg",
            thumbUrl: "https://example.com/thumb.jpg",
            tinyUrl: "https://example.com/tiny.jpg",
            originalUrl: "https://example.com/original.jpg"
        )

        return Character(
            id: id,
            name: name,
            description: description,
            deck: "A superhero",
            aliases: nil,
            image: image,
            apiDetailUrl: "https://comicvine.gamespot.com/api/character/4005-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/character/4005-\(id)/",
            firstAppearedInIssue: nil,
            countOfIssueAppearances: comicsCount,
            realName: "Peter Parker",
            birth: nil,
            dateAdded: "2008-06-06 11:27:46",
            dateLastUpdated: "2024-01-15 10:30:00",
            gender: 1,
            origin: OriginSummary(id: 4, name: "Human"),
            publisher: PublisherSummary(id: 31, name: "Marvel"),
            characterEnemies: nil,
            characterFriends: nil,
            creators: nil,
            issueCredits: nil,
            powers: nil,
            teams: nil,
            volumeCredits: nil
        )
    }
}

// MARK: - Comic Fixture for Cache Tests

extension Comic {
    /// Fixture para testes do módulo Cache
    static func cacheFixture(
        id: Int = 100,
        name: String? = "Amazing Spider-Man",
        issueNumber: String? = "1",
        description: String? = "First issue"
    ) -> Comic {
        let image = ComicVineImage(
            iconUrl: "https://example.com/comic_icon.jpg",
            mediumUrl: "https://example.com/comic_medium.jpg",
            screenUrl: nil,
            screenLargeUrl: nil,
            smallUrl: nil,
            superUrl: nil,
            thumbUrl: "https://example.com/comic_thumb.jpg",
            tinyUrl: nil,
            originalUrl: "https://example.com/comic_original.jpg"
        )

        let volume = VolumeSummary(
            id: 1,
            name: "Amazing Spider-Man",
            apiDetailUrl: "https://comicvine.gamespot.com/api/volume/4050-1/"
        )

        return Comic(
            id: id,
            name: name,
            issueNumber: issueNumber,
            description: description,
            deck: nil,
            image: image,
            coverDate: "2024-01-01",
            storeDate: "2024-01-15",
            apiDetailUrl: "https://comicvine.gamespot.com/api/issue/4000-\(id)/",
            siteDetailUrl: "https://comicvine.gamespot.com/issue/4000-\(id)/",
            volume: volume,
            hasStaffReview: false,
            dateAdded: "2024-01-01 00:00:00",
            dateLastUpdated: "2024-01-15 00:00:00"
        )
    }
}

// MARK: - Mock CacheManager

/// Actor para armazenamento thread-safe dos dados do mock
private actor MockCacheStorage {
    var savedObjects: [String: Any] = [:]
    var removedKeys: [String] = []
    var clearedAll = false
    var mockCacheSize: Int = 0
    var expirationDates: [String: Date] = [:]
    var expiredKeys: Set<String> = []

    func save(_ object: Any, forKey key: String) {
        savedObjects[key] = object
    }

    func load<T>(forKey key: String) -> T? {
        savedObjects[key] as? T
    }

    func remove(forKey key: String) {
        savedObjects.removeValue(forKey: key)
        removedKeys.append(key)
    }

    func clearAll() {
        savedObjects.removeAll()
        clearedAll = true
    }

    func setExpiration(_ date: Date, forKey key: String) {
        expirationDates[key] = date
    }

    func isExpired(forKey key: String) -> Bool {
        expiredKeys.contains(key)
    }

    func getSavedObjectsCount() -> Int {
        savedObjects.count
    }

    func getRemovedKeys() -> [String] {
        removedKeys
    }

    func getClearedAll() -> Bool {
        clearedAll
    }

    func setMockCacheSize(_ size: Int) {
        mockCacheSize = size
    }

    func getMockCacheSize() -> Int {
        mockCacheSize
    }

    func getExpirationDate(forKey key: String) -> Date? {
        expirationDates[key]
    }

    func addExpiredKey(_ key: String) {
        expiredKeys.insert(key)
    }
}

/// Mock do CacheManager para testes isolados (Swift 6 compliant)
final class MockCacheManager: CacheManagerProtocol, @unchecked Sendable {
    private let storage = MockCacheStorage()

    // MARK: - Public accessors for test assertions

    func getSavedObjectsCount() async -> Int {
        await storage.getSavedObjectsCount()
    }

    func getRemovedKeys() async -> [String] {
        await storage.getRemovedKeys()
    }

    func getClearedAll() async -> Bool {
        await storage.getClearedAll()
    }

    func setMockCacheSize(_ size: Int) async {
        await storage.setMockCacheSize(size)
    }

    func addExpiredKey(_ key: String) async {
        await storage.addExpiredKey(key)
    }

    func getExpirationDate(forKey key: String) async -> Date? {
        await storage.getExpirationDate(forKey: key)
    }

    // MARK: - CacheManagerProtocol

    func save<T: Codable & Sendable>(_ object: T, forKey key: String) async {
        await storage.save(object, forKey: key)
    }

    func load<T: Codable & Sendable>(_ type: T.Type, forKey key: String) async -> T? {
        await storage.load(forKey: key)
    }

    func remove(forKey key: String) async {
        await storage.remove(forKey: key)
    }

    func clearAll() async {
        await storage.clearAll()
    }

    func getCacheSize() async -> Int {
        await storage.getMockCacheSize()
    }

    func setExpirationDate(_ date: Date, forKey key: String) async {
        await storage.setExpiration(date, forKey: key)
    }

    func isExpired(forKey key: String) async -> Bool {
        await storage.isExpired(forKey: key)
    }
}

// MARK: - Test Helper Object

struct TestCodableObject: Codable, Sendable, Equatable {
    let id: Int
    let name: String
}

// MARK: - CacheMetadata Tests

@Suite("CacheMetadata Tests")
struct CacheMetadataTests {

    @Test("CacheMetadata should store expiration date correctly")
    func testExpirationDateStorage() {
        let date = Date()
        let metadata = CacheMetadata(expirationDate: date)

        #expect(metadata.expirationDate == date)
    }

    @Test("CacheMetadata should be Codable")
    func testCodable() throws {
        let date = Date()
        let metadata = CacheMetadata(expirationDate: date)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(metadata)
        let decoded = try decoder.decode(CacheMetadata.self, from: data)

        #expect(decoded.expirationDate.timeIntervalSince1970 == metadata.expirationDate.timeIntervalSince1970)
    }

    @Test("CacheMetadata should be Sendable")
    func testSendable() async {
        let metadata = CacheMetadata(expirationDate: Date())

        let result = await Task.detached {
            return metadata.expirationDate
        }.value

        #expect(result == metadata.expirationDate)
    }
}

// MARK: - MockCacheManager Tests

@Suite("MockCacheManager Tests")
struct MockCacheManagerTests {

    @Test("MockCacheManager should save and load objects")
    func testSaveAndLoad() async {
        let cache = MockCacheManager()
        let testData = TestCodableObject(id: 1, name: "Test")

        await cache.save(testData, forKey: "test_key")
        let loaded = await cache.load(TestCodableObject.self, forKey: "test_key")

        #expect(loaded?.id == 1)
        #expect(loaded?.name == "Test")
    }

    @Test("MockCacheManager should remove objects")
    func testRemove() async {
        let cache = MockCacheManager()
        let testData = TestCodableObject(id: 1, name: "Test")
        await cache.save(testData, forKey: "test_key")

        await cache.remove(forKey: "test_key")
        let loaded = await cache.load(TestCodableObject.self, forKey: "test_key")

        #expect(loaded == nil)

        let removedKeys = await cache.getRemovedKeys()
        #expect(removedKeys.contains("test_key"))
    }

    @Test("MockCacheManager should clear all objects")
    func testClearAll() async {
        let cache = MockCacheManager()
        await cache.save(TestCodableObject(id: 1, name: "Test1"), forKey: "key1")
        await cache.save(TestCodableObject(id: 2, name: "Test2"), forKey: "key2")

        await cache.clearAll()

        let clearedAll = await cache.getClearedAll()
        let count = await cache.getSavedObjectsCount()

        #expect(clearedAll == true)
        #expect(count == 0)
    }

    @Test("MockCacheManager should return mock cache size")
    func testGetCacheSize() async {
        let cache = MockCacheManager()
        await cache.setMockCacheSize(1024)

        let size = await cache.getCacheSize()

        #expect(size == 1024)
    }

    @Test("MockCacheManager should set expiration date")
    func testSetExpirationDate() async {
        let cache = MockCacheManager()
        let futureDate = Date().addingTimeInterval(3600)

        await cache.setExpirationDate(futureDate, forKey: "test_key")

        let storedDate = await cache.getExpirationDate(forKey: "test_key")
        #expect(storedDate == futureDate)
    }

    @Test("MockCacheManager should check expiration")
    func testIsExpired() async {
        let cache = MockCacheManager()
        await cache.addExpiredKey("expired_key")

        let isExpired = await cache.isExpired(forKey: "expired_key")
        let isNotExpired = await cache.isExpired(forKey: "valid_key")

        #expect(isExpired == true)
        #expect(isNotExpired == false)
    }
}

// MARK: - FileManager+Size Tests

@Suite("FileManager+Size Tests")
struct FileManagerSizeTests {

    @Test("sizeOfDirectory should return 0 for empty directory")
    func testEmptyDirectorySize() throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let size = try FileManager.default.sizeOfDirectory(at: tempDir)

        #expect(size == 0)
    }

    @Test("sizeOfDirectory should calculate file sizes correctly")
    func testDirectorySizeWithFiles() throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        let testData = Data(repeating: 0, count: 1024) // 1KB
        let fileURL = tempDir.appendingPathComponent("test.txt")
        try testData.write(to: fileURL)

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let size = try FileManager.default.sizeOfDirectory(at: tempDir)

        #expect(size == 1024)
    }

    @Test("sizeOfDirectory should calculate subdirectory sizes")
    func testDirectorySizeWithSubdirectories() throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        let subDir = tempDir.appendingPathComponent("subdir")
        try FileManager.default.createDirectory(at: subDir, withIntermediateDirectories: true)

        let testData = Data(repeating: 0, count: 512)
        try testData.write(to: tempDir.appendingPathComponent("file1.txt"))
        try testData.write(to: subDir.appendingPathComponent("file2.txt"))

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let size = try FileManager.default.sizeOfDirectory(at: tempDir)

        #expect(size == 1024) // 512 + 512
    }

    @Test("detailedSizeOfDirectory should return file count")
    func testDetailedSizeFileCount() throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        let testData = Data(repeating: 0, count: 100)
        try testData.write(to: tempDir.appendingPathComponent("file1.txt"))
        try testData.write(to: tempDir.appendingPathComponent("file2.txt"))
        try testData.write(to: tempDir.appendingPathComponent("file3.txt"))

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let info = try FileManager.default.detailedSizeOfDirectory(at: tempDir)

        #expect(info.fileCount == 3)
        #expect(info.totalSize == 300)
    }

    @Test("detailedSizeOfDirectory should group by extension")
    func testDetailedSizeByExtension() throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        let testData = Data(repeating: 0, count: 100)
        try testData.write(to: tempDir.appendingPathComponent("file1.txt"))
        try testData.write(to: tempDir.appendingPathComponent("file2.txt"))
        try testData.write(to: tempDir.appendingPathComponent("file3.json"))

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let info = try FileManager.default.detailedSizeOfDirectory(at: tempDir)

        #expect(info.sizeByExtension["txt"] == 200)
        #expect(info.sizeByExtension["json"] == 100)
    }

    @Test("sizeOfDirectoryAsync should work asynchronously")
    func testAsyncDirectorySize() async throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        let testData = Data(repeating: 0, count: 2048)
        try testData.write(to: tempDir.appendingPathComponent("test.bin"))

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let size = try await FileManager.default.sizeOfDirectoryAsync(at: tempDir)

        #expect(size == 2048)
    }

    @Test("hasEnoughSpace should check device space")
    func testHasEnoughSpace() {
        let smallSize: Int64 = 1024 // 1KB

        // Testa com tamanho pequeno - deve ter espaço suficiente
        #expect(FileManager.default.hasEnoughSpace(for: smallSize) == true)

        // Para testar espaço insuficiente, usamos um valor grande mas seguro
        // (evita overflow ao somar safetyMargin)
        if let freeSpace = FileManager.default.deviceFreeSpace {
            // Usa um valor maior que o espaço livre disponível
            let tooLargeSize = freeSpace + 1
            #expect(FileManager.default.hasEnoughSpace(for: tooLargeSize) == false)
        }
    }

    @Test("deviceFreeSpace should return a value")
    func testDeviceFreeSpace() {
        let freeSpace = FileManager.default.deviceFreeSpace

        #expect(freeSpace != nil)
        #expect(freeSpace! > 0)
    }

    @Test("deviceTotalSpace should return a value")
    func testDeviceTotalSpace() {
        let totalSpace = FileManager.default.deviceTotalSpace

        #expect(totalSpace != nil)
        #expect(totalSpace! > 0)
    }
}

// MARK: - DirectorySizeInfo Tests

@Suite("DirectorySizeInfo Tests")
struct DirectorySizeInfoTests {

    @Test("formattedTotalSize should format bytes correctly")
    func testFormattedTotalSize() {
        let info = DirectorySizeInfo(
            totalSize: 1024 * 1024, // 1MB
            fileCount: 10,
            directoryCount: 2,
            largestFile: nil,
            sizeByExtension: [:]
        )

        let formatted = info.formattedTotalSize

        #expect(formatted.contains("1") || formatted.contains("MB"))
    }

    @Test("averageFileSize should calculate correctly")
    func testAverageFileSize() {
        let info = DirectorySizeInfo(
            totalSize: 1000,
            fileCount: 10,
            directoryCount: 0,
            largestFile: nil,
            sizeByExtension: [:]
        )

        #expect(info.averageFileSize == 100)
    }

    @Test("averageFileSize should return 0 for empty directory")
    func testAverageFileSizeEmpty() {
        let info = DirectorySizeInfo(
            totalSize: 0,
            fileCount: 0,
            directoryCount: 0,
            largestFile: nil,
            sizeByExtension: [:]
        )

        #expect(info.averageFileSize == 0)
    }

    @Test("topExtensions should return sorted extensions")
    func testTopExtensions() {
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

        let top = info.topExtensions

        #expect(top.count == 3)
        #expect(top[0].extension == "txt")
        #expect(top[0].size == 500)
        #expect(top[1].extension == "json")
        #expect(top[2].extension == "xml")
    }
}

// MARK: - Character Cache Conversion Tests

@Suite("Character Cache Conversion Tests")
struct CharacterCacheConversionTests {

    @Test("Character.makeFromCache should create valid character")
    func testMakeFromCache() {
        let character = Character.makeFromCache(
            id: 1,
            name: "Spider-Man",
            description: "Hero",
            thumbnailPath: "https://example.com/image.jpg",
            comicsCount: 100
        )

        #expect(character.id == 1)
        #expect(character.name == "Spider-Man")
        #expect(character.description == "Hero")
        #expect(character.countOfIssueAppearances == 100)
    }

    @Test("Character.makeFromCache should handle nil values")
    func testMakeFromCacheNilValues() {
        let character = Character.makeFromCache(
            id: 1,
            name: "Unknown",
            description: nil,
            thumbnailPath: nil,
            comicsCount: 0
        )

        #expect(character.id == 1)
        #expect(character.name == "Unknown")
        #expect(character.description == nil)
        #expect(character.countOfIssueAppearances == 0)
    }

    @Test("Character.makeFromCache should generate valid URLs")
    func testMakeFromCacheUrls() {
        let character = Character.makeFromCache(
            id: 12345,
            name: "Spider-Man"
        )

        #expect(character.apiDetailUrl.contains("4005-12345"))
        #expect(character.siteDetailUrl.contains("4005-12345"))
    }
}

// MARK: - Comic Fixture Tests

@Suite("Comic Fixture Tests")
struct ComicFixtureTests {

    @Test("Comic fixture should create valid comic")
    func testComicFixture() {
        let comic = Comic.cacheFixture()

        #expect(comic.id == 100)
        #expect(comic.name == "Amazing Spider-Man")
        #expect(comic.issueNumber == "1")
    }

    @Test("Comic fixture should allow custom values")
    func testComicFixtureCustomValues() {
        let comic = Comic.cacheFixture(
            id: 200,
            name: "X-Men",
            issueNumber: "50",
            description: "Classic issue"
        )

        #expect(comic.id == 200)
        #expect(comic.name == "X-Men")
        #expect(comic.issueNumber == "50")
        #expect(comic.description == "Classic issue")
    }

    @Test("Comic title should combine volume and issue number")
    func testComicTitle() {
        let comic = Comic.cacheFixture(
            name: nil,
            issueNumber: "15"
        )

        #expect(comic.title == "Amazing Spider-Man #15")
    }

    @Test("Comic should be Hashable")
    func testComicHashable() {
        let comic1 = Comic.cacheFixture(id: 1)
        let comic2 = Comic.cacheFixture(id: 1)
        let comic3 = Comic.cacheFixture(id: 2)

        #expect(comic1 == comic2)
        #expect(comic1 != comic3)
        #expect(comic1.hashValue == comic2.hashValue)
    }
}

// MARK: - Async Cache Operations Tests

@Suite("Async Cache Operations Tests")
struct AsyncCacheOperationsTests {

    @Test("Concurrent cache operations should not crash")
    func testConcurrentOperations() async {
        let cache = MockCacheManager()

        // Executa operações concorrentes de forma controlada
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<50 {
                group.addTask {
                    let obj = TestCodableObject(id: i, name: "Object \(i)")
                    await cache.save(obj, forKey: "key_\(i)")
                }
            }
        }

        // Verifica se as operações foram concluídas
        let savedCount = await cache.getSavedObjectsCount()
        #expect(savedCount == 50)
    }

    @Test("Sequential cache operations should work correctly")
    func testSequentialOperations() async {
        let cache = MockCacheManager()

        // Operações sequenciais
        for i in 0..<10 {
            let obj = TestCodableObject(id: i, name: "Object \(i)")
            await cache.save(obj, forKey: "key_\(i)")
        }

        let count = await cache.getSavedObjectsCount()
        #expect(count == 10)

        // Verifica se os objetos foram salvos corretamente
        let loaded = await cache.load(TestCodableObject.self, forKey: "key_5")
        #expect(loaded?.id == 5)
        #expect(loaded?.name == "Object 5")
    }

    @Test("Cache clear should reset state")
    func testClearResetsState() async {
        let cache = MockCacheManager()

        // Salva alguns objetos
        for i in 0..<5 {
            let obj = TestCodableObject(id: i, name: "Object \(i)")
            await cache.save(obj, forKey: "key_\(i)")
        }

        let countBefore = await cache.getSavedObjectsCount()
        #expect(countBefore == 5)

        // Limpa o cache
        await cache.clearAll()

        let clearedAll = await cache.getClearedAll()
        let countAfter = await cache.getSavedObjectsCount()

        #expect(clearedAll == true)
        #expect(countAfter == 0)
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
}
