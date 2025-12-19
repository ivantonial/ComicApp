//
//  ComicCardModelTests.swift
//  ComicsList
//
//  Created by Ivan Tonial IP.TV on 15/12/25.
//

@testable import ComicsList
@testable import ComicVineAPI
import DesignSystem
import Foundation
import Testing
import XCTest

// MARK: - ComicCardModel Initialization Tests

@Suite("ComicCardModel Initialization Tests")
struct ComicCardModelInitializationTests {

    @Test("Should create model from Comic")
    func testCreateFromComic() {
        // Arrange
        let comic = Comic.comicsListFixture(
            id: 1,
            volumeName: "Spider-Man",
            issueNumber: "100",
            coverDate: "2024-06-15"
        )

        // Act
        let model = ComicCardModel(from: comic)

        // Assert
        #expect(model.id == 1)
        #expect(model.title == "Spider-Man #100")
        #expect(model.issueNumber == "100")
        #expect(model.coverDate == "2024-06-15")
        #expect(model.imageURL != nil)
    }

    @Test("Should handle Comic without issue number")
    func testComicWithoutIssueNumber() {
        // Arrange
        let comic = Comic.comicsListFixture(
            id: 2,
            volumeName: "Batman",
            issueNumber: nil
        )

        // Act
        let model = ComicCardModel(from: comic)

        // Assert
        #expect(model.id == 2)
        #expect(model.title == "Batman")
        #expect(model.issueNumber == nil)
    }

    @Test("Should handle Comic without cover date")
    func testComicWithoutCoverDate() {
        // Arrange
        let comic = Comic.comicWithoutCoverDate(id: 3)

        // Act
        let model = ComicCardModel(from: comic)

        // Assert
        #expect(model.id == 3)
        #expect(model.coverDate == nil)
    }

    @Test("Should handle minimal Comic")
    func testMinimalComic() {
        // Arrange
        let comic = Comic.minimalComicsListFixture(id: 4)

        // Act
        let model = ComicCardModel(from: comic)

        // Assert
        #expect(model.id == 4)
        #expect(model.title == "Unknown Comic")
        #expect(model.issueNumber == nil)
        #expect(model.coverDate == nil)
    }

    @Test("Should use best quality URL for image")
    func testImageURLQuality() {
        // Arrange
        let comic = Comic.comicsListFixture(id: 5, hasImage: true)

        // Act
        let model = ComicCardModel(from: comic)

        // Assert
        #expect(model.imageURL != nil)
    }

    @Test("Should handle Comic without image")
    func testComicWithoutImage() {
        // Arrange
        let comic = Comic.comicsListFixture(id: 6, hasImage: false)

        // Act
        let model = ComicCardModel(from: comic)

        // Assert
        #expect(model.imageURL == nil)
    }
}

// MARK: - ComicCardModel Identifiable Tests

@Suite("ComicCardModel Identifiable Tests")
struct ComicCardModelIdentifiableTests {

    @Test("Should conform to Identifiable")
    func testIdentifiable() {
        // Arrange
        let comic = Comic.comicsListFixture(id: 42)
        let model = ComicCardModel(from: comic)

        // Assert
        #expect(model.id == 42)
    }

    @Test("Should have unique IDs")
    func testUniqueIds() {
        // Arrange
        let comics: [Comic] = .comicsListFixtures(count: 5)
        let models = comics.map { ComicCardModel(from: $0) }

        // Act
        let ids = Set(models.map { $0.id })

        // Assert
        #expect(ids.count == 5)
    }
}

// MARK: - ComicCardModel Sendable Tests

@Suite("ComicCardModel Sendable Tests")
struct ComicCardModelSendableTests {

    @Test("Should be safely passed across concurrency boundaries")
    func testSendable() async {
        // Arrange
        let comic = Comic.comicsListFixture(id: 1, volumeName: "X-Men", issueNumber: "50")
        let model = ComicCardModel(from: comic)

        // Act
        let result = await Task.detached {
            return (model.id, model.title, model.issueNumber)
        }.value

        // Assert
        #expect(result.0 == 1)
        #expect(result.1 == "X-Men #50")
        #expect(result.2 == "50")
    }

    @Test("Should work with async operations")
    func testAsyncOperations() async {
        // Arrange
        let comics: [Comic] = .comicsListFixtures(count: 10)
        let models = comics.map { ComicCardModel(from: $0) }

        // Act
        let titles = await withTaskGroup(of: String.self) { group in
            for model in models {
                group.addTask {
                    return model.title
                }
            }

            var results: [String] = []
            for await title in group {
                results.append(title)
            }
            return results
        }

        // Assert
        #expect(titles.count == 10)
    }
}

// MARK: - ComicCardModel ContentCardConvertible Tests

@Suite("ComicCardModel ContentCardConvertible Tests")
struct ComicCardModelContentCardConvertibleTests {

    @Test("Should convert to ContentCardModel")
    func testToContentCardModel() {
        // Arrange
        let comic = Comic.comicsListFixture(
            id: 1,
            volumeName: "Spider-Man",
            issueNumber: "100"
        )
        let model = ComicCardModel(from: comic)

        // Act
        let contentModel = model.toContentCardModel()

        // Assert
        #expect(contentModel.id == 1)
        #expect(contentModel.title == "Spider-Man #100")
        #expect(contentModel.subtitle == "Issue #100")
    }

    @Test("Should have correct aspect ratio")
    func testAspectRatio() {
        // Arrange
        let comic = Comic.comicsListFixture(id: 1)
        let model = ComicCardModel(from: comic)

        // Act
        let contentModel = model.toContentCardModel()

        // Assert
        #expect(contentModel.aspectRatio == 3.0 / 4.0)
    }

    @Test("Should have badge when cover date exists")
    func testBadgeWithCoverDate() {
        // Arrange
        let comic = Comic.comicsListFixture(id: 1, coverDate: "2024-06-01")
        let model = ComicCardModel(from: comic)

        // Act
        let contentModel = model.toContentCardModel()

        // Assert
        #expect(contentModel.badge != nil)
        #expect(contentModel.badge?.icon == "calendar")
    }

    @Test("Should not have badge when cover date is nil")
    func testNoBadgeWithoutCoverDate() {
        // Arrange
        let comic = Comic.comicWithoutCoverDate(id: 1)
        let model = ComicCardModel(from: comic)

        // Act
        let contentModel = model.toContentCardModel()

        // Assert
        #expect(contentModel.badge == nil)
    }

    @Test("Should have nil subtitle when issue number is nil")
    func testSubtitleWithoutIssueNumber() {
        // Arrange
        let comic = Comic.comicsListFixture(id: 1, issueNumber: nil)
        let model = ComicCardModel(from: comic)

        // Act
        let contentModel = model.toContentCardModel()

        // Assert
        #expect(contentModel.subtitle == nil)
    }
}

// MARK: - ComicCardModel Date Formatting Tests

@Suite("ComicCardModel Date Formatting Tests")
struct ComicCardModelDateFormattingTests {

    @Test("Should format date correctly for January")
    func testFormatDateJanuary() {
        // Arrange
        let comic = Comic.comicsListFixture(id: 1, coverDate: "2024-01-15")
        let model = ComicCardModel(from: comic)

        // Act
        let contentModel = model.toContentCardModel()

        // Assert
        #expect(contentModel.badge?.text == "Jan 2024")
    }

    @Test("Should format date correctly for June")
    func testFormatDateJune() {
        // Arrange
        let comic = Comic.comicsListFixture(id: 1, coverDate: "2024-06-01")
        let model = ComicCardModel(from: comic)

        // Act
        let contentModel = model.toContentCardModel()

        // Assert
        #expect(contentModel.badge?.text == "Jun 2024")
    }

    @Test("Should format date correctly for December")
    func testFormatDateDecember() {
        // Arrange
        let comic = Comic.comicsListFixture(id: 1, coverDate: "2024-12-25")
        let model = ComicCardModel(from: comic)

        // Act
        let contentModel = model.toContentCardModel()

        // Assert
        #expect(contentModel.badge?.text == "Dec 2024")
    }

    @Test("Should handle invalid date format")
    func testInvalidDateFormat() {
        // Arrange - criando comic com data em formato inválido
        let image = ComicVineImage.comicsListFixture()
        let comic = Comic(
            id: 1,
            name: nil,
            issueNumber: "1",
            description: nil,
            deck: nil,
            image: image,
            coverDate: "invalid-date",
            storeDate: nil,
            apiDetailUrl: "https://example.com",
            siteDetailUrl: "https://example.com",
            volume: VolumeSummary.comicsListFixture(),
            hasStaffReview: nil,
            dateAdded: "2024-01-01",
            dateLastUpdated: "2024-01-01"
        )
        let model = ComicCardModel(from: comic)

        // Act
        let contentModel = model.toContentCardModel()

        // Assert - deve retornar a data original quando não conseguir formatar
        #expect(contentModel.badge?.text == "invalid-date")
    }

    @Test("Should handle date with only year")
    func testDateOnlyYear() {
        // Arrange - criando comic com apenas ano
        let image = ComicVineImage.comicsListFixture()
        let comic = Comic(
            id: 1,
            name: nil,
            issueNumber: "1",
            description: nil,
            deck: nil,
            image: image,
            coverDate: "2024",
            storeDate: nil,
            apiDetailUrl: "https://example.com",
            siteDetailUrl: "https://example.com",
            volume: VolumeSummary.comicsListFixture(),
            hasStaffReview: nil,
            dateAdded: "2024-01-01",
            dateLastUpdated: "2024-01-01"
        )
        let model = ComicCardModel(from: comic)

        // Act
        let contentModel = model.toContentCardModel()

        // Assert - deve retornar a data original quando formato incompleto
        #expect(contentModel.badge?.text == "2024")
    }

    @Test("Should handle all months correctly")
    func testAllMonths() {
        // Arrange
        let expectedMonths = [
            ("01", "Jan"),
            ("02", "Feb"),
            ("03", "Mar"),
            ("04", "Apr"),
            ("05", "May"),
            ("06", "Jun"),
            ("07", "Jul"),
            ("08", "Aug"),
            ("09", "Sep"),
            ("10", "Oct"),
            ("11", "Nov"),
            ("12", "Dec")
        ]

        for (monthNumber, monthName) in expectedMonths {
            // Act
            let comic = Comic.comicsListFixture(id: 1, coverDate: "2024-\(monthNumber)-01")
            let model = ComicCardModel(from: comic)
            let contentModel = model.toContentCardModel()

            // Assert
            #expect(contentModel.badge?.text == "\(monthName) 2024")
        }
    }
}

// MARK: - XCTest Integration Tests

class ComicCardModelXCTests: XCTestCase {

    func testBasicCreation() {
        // Arrange
        let comic = Comic.comicsListFixture()

        // Act
        let model = ComicCardModel(from: comic)

        // Assert
        XCTAssertEqual(model.id, comic.id)
        XCTAssertEqual(model.title, comic.title)
    }

    func testContentCardConversion() {
        // Arrange
        let comic = Comic.comicsListFixture(
            id: 42,
            volumeName: "Batman",
            issueNumber: "50",
            coverDate: "2024-03-15"
        )
        let model = ComicCardModel(from: comic)

        // Act
        let contentModel = model.toContentCardModel()

        // Assert
        XCTAssertEqual(contentModel.id, 42)
        XCTAssertEqual(contentModel.title, "Batman #50")
        XCTAssertEqual(contentModel.subtitle, "Issue #50")
        XCTAssertNotNil(contentModel.badge)
        XCTAssertEqual(contentModel.badge?.text, "Mar 2024")
        XCTAssertEqual(contentModel.aspectRatio, 3.0 / 4.0, accuracy: 0.001)
    }

    func testMultipleModels() {
        // Arrange
        let comics: [Comic] = .comicsListFixtures(count: 10)

        // Act
        let models = comics.map { ComicCardModel(from: $0) }

        // Assert
        XCTAssertEqual(models.count, 10)
        for (index, model) in models.enumerated() {
            XCTAssertEqual(model.id, 101 + index)
        }
    }

    func testImageURLExtraction() {
        // Arrange
        let comicWithImage = Comic.comicsListFixture(hasImage: true)
        let comicWithoutImage = Comic.comicsListFixture(hasImage: false)

        // Act
        let modelWithImage = ComicCardModel(from: comicWithImage)
        let modelWithoutImage = ComicCardModel(from: comicWithoutImage)

        // Assert
        XCTAssertNotNil(modelWithImage.imageURL)
        XCTAssertNil(modelWithoutImage.imageURL)
    }
}
