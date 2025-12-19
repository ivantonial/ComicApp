//
//  MockCacheManager+Settings.swift
//  Settings
//
//  Created by Ivan Tonial IP.TV on 17/12/25.
//

@testable import Settings
import Foundation

// MARK: - MockSettingsCacheManager

/// Mock thread-safe do CacheManagerProtocol para testes do módulo Settings.
/// Utiliza actor para garantir isolamento de dados e conformidade com Swift 6 concurrency.
actor MockSettingsCacheManager: CacheManagerProtocol {
    // MARK: - Properties

    private var storage: [String: Data] = [:]
    private var expirationDates: [String: Date] = [:]

    // Controle de comportamento do mock
    var cacheSize: Int = 1024 * 1024 // 1 MB por padrão
    var shouldSimulateSlowOperation: Bool = false
    var simulatedDelay: UInt64 = 100_000_000 // 100ms

    // Rastreamento de chamadas
    private(set) var saveCalled: Bool = false
    private(set) var saveCallCount: Int = 0
    private(set) var loadCalled: Bool = false
    private(set) var loadCallCount: Int = 0
    private(set) var removeCalled: Bool = false
    private(set) var removeCallCount: Int = 0
    private(set) var clearAllCalled: Bool = false
    private(set) var clearAllCallCount: Int = 0
    private(set) var getCacheSizeCalled: Bool = false
    private(set) var getCacheSizeCallCount: Int = 0

    // MARK: - Initialization

    init() {}

    // MARK: - CacheManagerProtocol Implementation

    func save<T: Codable & Sendable>(_ object: T, forKey key: String) async {
        saveCalled = true
        saveCallCount += 1

        if shouldSimulateSlowOperation {
            try? await Task.sleep(nanoseconds: simulatedDelay)
        }

        if let data = try? JSONEncoder().encode(object) {
            storage[key] = data
        }
    }

    func load<T: Codable & Sendable>(_ type: T.Type, forKey key: String) async -> T? {
        loadCalled = true
        loadCallCount += 1

        if shouldSimulateSlowOperation {
            try? await Task.sleep(nanoseconds: simulatedDelay)
        }

        guard let data = storage[key] else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    func remove(forKey key: String) async {
        removeCalled = true
        removeCallCount += 1

        if shouldSimulateSlowOperation {
            try? await Task.sleep(nanoseconds: simulatedDelay)
        }

        storage.removeValue(forKey: key)
        expirationDates.removeValue(forKey: key)
    }

    func clearAll() async {
        clearAllCalled = true
        clearAllCallCount += 1

        if shouldSimulateSlowOperation {
            try? await Task.sleep(nanoseconds: simulatedDelay)
        }

        storage.removeAll()
        expirationDates.removeAll()
    }

    func getCacheSize() async -> Int {
        getCacheSizeCalled = true
        getCacheSizeCallCount += 1

        if shouldSimulateSlowOperation {
            try? await Task.sleep(nanoseconds: simulatedDelay)
        }

        return cacheSize
    }

    func setExpirationDate(_ date: Date, forKey key: String) async {
        expirationDates[key] = date
    }

    func isExpired(forKey key: String) async -> Bool {
        guard let expirationDate = expirationDates[key] else { return false }
        return Date() > expirationDate
    }

    // MARK: - Helper Methods

    /// Reseta o estado do mock
    func reset() {
        storage.removeAll()
        expirationDates.removeAll()
        cacheSize = 1024 * 1024
        shouldSimulateSlowOperation = false

        saveCalled = false
        saveCallCount = 0
        loadCalled = false
        loadCallCount = 0
        removeCalled = false
        removeCallCount = 0
        clearAllCalled = false
        clearAllCallCount = 0
        getCacheSizeCalled = false
        getCacheSizeCallCount = 0
    }

    /// Configura o mock com um tamanho de cache específico
    func setupWithCacheSize(_ size: Int) {
        cacheSize = size
    }

    /// Configura o mock para simular cache vazio
    func setupEmpty() {
        cacheSize = 0
        storage.removeAll()
    }

    /// Configura o mock para simular cache grande
    func setupLargeCache() {
        cacheSize = 100 * 1024 * 1024 // 100 MB
    }

    /// Adiciona dados diretamente ao storage para testes
    func addTestData(key: String, data: Data) {
        storage[key] = data
    }

    /// Retorna o número de itens no storage
    func getStorageCount() -> Int {
        storage.count
    }
}

// MARK: - MockSettingsCacheManager Tests

#if DEBUG
import Testing

@Suite("MockSettingsCacheManager Tests")
struct MockSettingsCacheManagerTests {

    @Test("Mock should initialize with default values")
    func testInitialization() async {
        // Arrange & Act
        let mock = MockSettingsCacheManager()

        // Assert
        let size = await mock.getCacheSize()
        #expect(size == 1024 * 1024)
    }

    @Test("Mock save should track calls")
    func testSaveTracking() async {
        // Arrange
        let mock = MockSettingsCacheManager()

        // Act
        await mock.save("test", forKey: "key1")
        await mock.save(42, forKey: "key2")

        // Assert
        let saveCalled = await mock.saveCalled
        let saveCallCount = await mock.saveCallCount
        #expect(saveCalled)
        #expect(saveCallCount == 2)
    }

    @Test("Mock load should return saved value")
    func testLoadSavedValue() async {
        // Arrange
        let mock = MockSettingsCacheManager()
        let testValue = "Hello, World!"

        // Act
        await mock.save(testValue, forKey: "greeting")
        let loaded: String? = await mock.load(String.self, forKey: "greeting")

        // Assert
        #expect(loaded == testValue)
    }

    @Test("Mock load should return nil for non-existent key")
    func testLoadNonExistent() async {
        // Arrange
        let mock = MockSettingsCacheManager()

        // Act
        let loaded: String? = await mock.load(String.self, forKey: "nonexistent")

        // Assert
        #expect(loaded == nil)
    }

    @Test("Mock remove should delete saved value")
    func testRemove() async {
        // Arrange
        let mock = MockSettingsCacheManager()
        await mock.save("test", forKey: "key")

        // Act
        await mock.remove(forKey: "key")
        let loaded: String? = await mock.load(String.self, forKey: "key")

        // Assert
        #expect(loaded == nil)
        let removeCalled = await mock.removeCalled
        #expect(removeCalled)
    }

    @Test("Mock clearAll should remove all values")
    func testClearAll() async {
        // Arrange
        let mock = MockSettingsCacheManager()
        await mock.save("test1", forKey: "key1")
        await mock.save("test2", forKey: "key2")

        // Act
        await mock.clearAll()

        // Assert
        let loaded1: String? = await mock.load(String.self, forKey: "key1")
        let loaded2: String? = await mock.load(String.self, forKey: "key2")
        #expect(loaded1 == nil)
        #expect(loaded2 == nil)
        let clearAllCalled = await mock.clearAllCalled
        #expect(clearAllCalled)
    }

    @Test("Mock getCacheSize should return configured size")
    func testGetCacheSize() async {
        // Arrange
        let mock = MockSettingsCacheManager()
        await mock.setupWithCacheSize(5 * 1024 * 1024)

        // Act
        let size = await mock.getCacheSize()

        // Assert
        #expect(size == 5 * 1024 * 1024)
        let getCacheSizeCalled = await mock.getCacheSizeCalled
        #expect(getCacheSizeCalled)
    }

    @Test("Mock reset should clear all state")
    func testReset() async {
        // Arrange
        let mock = MockSettingsCacheManager()
        await mock.save("test", forKey: "key")
        _ = await mock.getCacheSize()
        await mock.clearAll()

        // Act
        await mock.reset()

        // Assert
        let saveCalled = await mock.saveCalled
        let clearAllCalled = await mock.clearAllCalled
        let getCacheSizeCalled = await mock.getCacheSizeCalled
        let storageCount = await mock.getStorageCount()

        #expect(!saveCalled)
        #expect(!clearAllCalled)
        #expect(!getCacheSizeCalled)
        #expect(storageCount == 0)
    }

    @Test("Mock setupEmpty should configure zero cache")
    func testSetupEmpty() async {
        // Arrange
        let mock = MockSettingsCacheManager()

        // Act
        await mock.setupEmpty()
        let size = await mock.getCacheSize()

        // Assert
        #expect(size == 0)
    }

    @Test("Mock setupLargeCache should configure large cache")
    func testSetupLargeCache() async {
        // Arrange
        let mock = MockSettingsCacheManager()

        // Act
        await mock.setupLargeCache()
        let size = await mock.getCacheSize()

        // Assert
        #expect(size == 100 * 1024 * 1024)
    }

    @Test("Mock expiration should work correctly")
    func testExpiration() async {
        // Arrange
        let mock = MockSettingsCacheManager()
        let pastDate = Date().addingTimeInterval(-60) // 1 minuto atrás
        let futureDate = Date().addingTimeInterval(60) // 1 minuto no futuro

        // Act
        await mock.setExpirationDate(pastDate, forKey: "expired")
        await mock.setExpirationDate(futureDate, forKey: "valid")

        // Assert
        let isExpired = await mock.isExpired(forKey: "expired")
        let isValid = await mock.isExpired(forKey: "valid")
        #expect(isExpired == true)
        #expect(isValid == false)
    }
}
#endif
