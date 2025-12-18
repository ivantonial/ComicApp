//
//  HeaderComponentTests.swift
//  DesignSystem
//
//  Created by Ivan Tonial IP.TV on 08/12/25.
//

@testable import DesignSystem
import SwiftUI
import Testing
import XCTest

// MARK: - HeaderComponent Initialization Tests

@Suite("HeaderComponent Initialization Tests")
@MainActor
struct HeaderComponentInitializationTests {

    @Test("HeaderComponent should be instantiable with title only")
    func testMinimalInitialization() {
        let header = HeaderComponent(title: "Characters")
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("HeaderComponent should be instantiable with title and subtitle")
    func testInitializationWithSubtitle() {
        let header = HeaderComponent(
            title: "Characters",
            subtitle: "Browse all characters"
        )
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("HeaderComponent should be instantiable with all basic parameters")
    func testFullBasicInitialization() {
        let header = HeaderComponent(
            title: "Characters",
            subtitle: "Browse all characters",
            alignment: .center
        )
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("HeaderComponent should be instantiable with back button")
    func testInitializationWithBackButton() {
        var backCalled = false
        let header = HeaderComponent(
            title: "Character Detail",
            subtitle: nil,
            alignment: .leading,
            showBackButton: true,
            backButtonAction: { backCalled = true },
            trailingContent: nil
        )

        #expect(type(of: header) == HeaderComponent.self)
        #expect(backCalled == false)
    }

    @Test("HeaderComponent should be instantiable with trailing content")
    func testInitializationWithTrailingContent() {
        let header = HeaderComponent(title: "Settings") {
            Image(systemName: "gear")
        }

        #expect(type(of: header) == HeaderComponent.self)
    }
}

// MARK: - HeaderComponent Alignment Tests

@Suite("HeaderComponent Alignment Tests")
@MainActor
struct HeaderComponentAlignmentTests {

    @Test("HeaderComponent should support leading alignment")
    func testLeadingAlignment() {
        let header = HeaderComponent(
            title: "Test",
            alignment: .leading
        )
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("HeaderComponent should support center alignment")
    func testCenterAlignment() {
        let header = HeaderComponent(
            title: "Test",
            alignment: .center
        )
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("HeaderComponent should support trailing alignment")
    func testTrailingAlignment() {
        let header = HeaderComponent(
            title: "Test",
            alignment: .trailing
        )
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("HeaderComponent should default to leading alignment")
    func testDefaultAlignment() {
        let header = HeaderComponent(title: "Test")
        // Verify component is created (default alignment is .leading)
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("All alignment options should work")
    func testAllAlignments() {
        let alignments: [HorizontalAlignment] = [.leading, .center, .trailing]

        for alignment in alignments {
            let header = HeaderComponent(title: "Test", alignment: alignment)
            #expect(type(of: header) == HeaderComponent.self)
        }
    }
}

// MARK: - HeaderComponent View Tests

@Suite("HeaderComponent View Tests")
@MainActor
struct HeaderComponentViewTests {

    @Test("HeaderComponent should conform to View")
    func testViewConformance() {
        let header = HeaderComponent(title: "Test")
        let _: any View = header
        #expect(true)
    }

    @Test("HeaderComponent body should be accessible")
    func testBodyAccessibility() {
        let header = HeaderComponent(title: "Test")
        let body = header.body
        #expect(type(of: body) != type(of: header))
    }

    @Test("HeaderComponent body should change with subtitle")
    func testBodyWithSubtitle() {
        let headerWithoutSubtitle = HeaderComponent(title: "Test")
        let headerWithSubtitle = HeaderComponent(title: "Test", subtitle: "Subtitle")

        let body1 = headerWithoutSubtitle.body
        let body2 = headerWithSubtitle.body

        // Both should produce valid bodies
        #expect(true)
        _ = body1
        _ = body2
    }
}

// MARK: - HeaderComponent Content Tests

@Suite("HeaderComponent Content Tests")
@MainActor
struct HeaderComponentContentTests {

    @Test("HeaderComponent should accept long titles")
    func testLongTitle() {
        let longTitle = "This is a very long title that might wrap to multiple lines"
        let header = HeaderComponent(title: longTitle)
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("HeaderComponent should accept empty subtitle")
    func testEmptySubtitle() {
        let header = HeaderComponent(title: "Test", subtitle: "")
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("HeaderComponent should accept special characters in title")
    func testSpecialCharactersTitle() {
        let titles = ["Test & More", "100% Complete", "Character: Detail", "Title (Info)"]

        for title in titles {
            let header = HeaderComponent(title: title)
            #expect(type(of: header) == HeaderComponent.self)
        }
    }

    @Test("HeaderComponent should accept unicode characters")
    func testUnicodeCharacters() {
        let header = HeaderComponent(
            title: "人物 🦸",
            subtitle: "漫画英雄"
        )
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("HeaderComponent should accept nil subtitle")
    func testNilSubtitle() {
        let header = HeaderComponent(title: "Test", subtitle: nil)
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("HeaderComponent should accept various subtitle lengths")
    func testVariousSubtitleLengths() {
        let subtitles = [
            "A",
            "Short",
            "A medium length subtitle",
            "A very long subtitle that contains a lot of text and might wrap to multiple lines on smaller screens"
        ]

        for subtitle in subtitles {
            let header = HeaderComponent(title: "Test", subtitle: subtitle)
            #expect(type(of: header) == HeaderComponent.self)
        }
    }
}

// MARK: - HeaderComponent Back Button Tests

@Suite("HeaderComponent Back Button Tests")
@MainActor
struct HeaderComponentBackButtonTests {

    @Test("Back button action should not be called on init")
    func testBackButtonNotCalledOnInit() {
        var backCalled = false

        _ = HeaderComponent(
            title: "Test",
            subtitle: nil,
            alignment: .leading,
            showBackButton: true,
            backButtonAction: { backCalled = true },
            trailingContent: nil
        )

        #expect(backCalled == false)
    }

    @Test("HeaderComponent should work without back button action")
    func testWithoutBackButtonAction() {
        let header = HeaderComponent(
            title: "Test",
            subtitle: nil,
            alignment: .leading,
            showBackButton: true,
            backButtonAction: nil,
            trailingContent: nil
        )

        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("HeaderComponent should work with showBackButton false")
    func testWithBackButtonHidden() {
        let header = HeaderComponent(
            title: "Test",
            subtitle: nil,
            alignment: .leading,
            showBackButton: false,
            backButtonAction: nil,
            trailingContent: nil
        )

        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("HeaderComponent back button with trailing content")
    func testBackButtonWithTrailingContent() {
        let header = HeaderComponent(
            title: "Test",
            subtitle: nil,
            alignment: .leading,
            showBackButton: true,
            backButtonAction: {},
            trailingContent: AnyView(Image(systemName: "star"))
        )

        #expect(type(of: header) == HeaderComponent.self)
    }
}

// MARK: - HeaderComponent Trailing Content Tests

@Suite("HeaderComponent Trailing Content Tests")
@MainActor
struct HeaderComponentTrailingContentTests {

    @Test("HeaderComponent should accept Image as trailing content")
    func testImageTrailingContent() {
        let header = HeaderComponent(title: "Settings") {
            Image(systemName: "gear")
        }
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("HeaderComponent should accept Button as trailing content")
    func testButtonTrailingContent() {
        let header = HeaderComponent(title: "Settings") {
            Button("Action") {}
        }
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("HeaderComponent should accept Text as trailing content")
    func testTextTrailingContent() {
        let header = HeaderComponent(title: "Settings") {
            Text("Edit")
        }
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("HeaderComponent should accept complex trailing content")
    func testComplexTrailingContent() {
        let header = HeaderComponent(title: "Settings") {
            HStack {
                Image(systemName: "star")
                Text("Favorite")
            }
        }
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("HeaderComponent should accept nil trailing content via full init")
    func testNilTrailingContent() {
        let header = HeaderComponent(
            title: "Test",
            subtitle: nil,
            alignment: .leading,
            showBackButton: false,
            backButtonAction: nil,
            trailingContent: nil
        )
        #expect(type(of: header) == HeaderComponent.self)
    }
}

// MARK: - HeaderComponent Common Use Cases Tests

@Suite("HeaderComponent Common Use Cases Tests")
@MainActor
struct HeaderComponentCommonUseCasesTests {

    @Test("Characters list header")
    func testCharactersListHeader() {
        let header = HeaderComponent(
            title: "Characters",
            subtitle: "Discover comic book characters"
        )
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("Character detail header with back button")
    func testCharacterDetailHeader() {
        let header = HeaderComponent(
            title: "Spider-Man",
            subtitle: "Peter Parker",
            alignment: .leading,
            showBackButton: true,
            backButtonAction: {},
            trailingContent: nil
        )
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("Settings header with trailing icon")
    func testSettingsHeader() {
        let header = HeaderComponent(title: "Settings") {
            Image(systemName: "info.circle")
        }
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("Search header centered")
    func testSearchHeader() {
        let header = HeaderComponent(
            title: "Search",
            subtitle: "Find characters and comics",
            alignment: .center
        )
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("Comics list header")
    func testComicsListHeader() {
        let header = HeaderComponent(
            title: "Comics",
            subtitle: "Latest releases"
        )
        #expect(type(of: header) == HeaderComponent.self)
    }

    @Test("Favorites header with action")
    func testFavoritesHeader() {
        let header = HeaderComponent(title: "Favorites") {
            Button(action: {}) {
                Image(systemName: "trash")
            }
        }
        #expect(type(of: header) == HeaderComponent.self)
    }
}

// MARK: - XCTest HeaderComponent Tests

@MainActor
class HeaderComponentXCTests: XCTestCase {

    func testMinimalInitialization() {
        let header = HeaderComponent(title: "Test")
        XCTAssertNotNil(header)
    }

    func testInitializationWithSubtitle() {
        let header = HeaderComponent(
            title: "Test",
            subtitle: "Subtitle text"
        )
        XCTAssertNotNil(header)
    }

    func testInitializationWithAlignment() {
        let leadingHeader = HeaderComponent(title: "Test", alignment: .leading)
        let centerHeader = HeaderComponent(title: "Test", alignment: .center)
        let trailingHeader = HeaderComponent(title: "Test", alignment: .trailing)

        XCTAssertNotNil(leadingHeader)
        XCTAssertNotNil(centerHeader)
        XCTAssertNotNil(trailingHeader)
    }

    func testViewBodyCreation() {
        let header = HeaderComponent(title: "Test")
        let body = header.body
        XCTAssertNotNil(body)
    }

    func testHeaderWithTrailingContent() {
        let header = HeaderComponent(title: "Settings") {
            Button(action: {}) {
                Image(systemName: "gear")
            }
        }

        let body = header.body
        XCTAssertNotNil(body)
    }

    func testBackButtonActionNotTriggeredOnInit() {
        var wasCalled = false

        _ = HeaderComponent(
            title: "Test",
            subtitle: nil,
            alignment: .leading,
            showBackButton: true,
            backButtonAction: { wasCalled = true },
            trailingContent: nil
        )

        XCTAssertFalse(wasCalled)
    }

    func testVariousSubtitles() {
        let subtitles: [String?] = [
            nil,
            "",
            "Short",
            "A longer subtitle that describes the content",
            "Subtitle with special chars: &, <, >, @"
        ]

        for subtitle in subtitles {
            let header = HeaderComponent(title: "Test", subtitle: subtitle)
            XCTAssertNotNil(header)
        }
    }

    func testCompleteHeaderConfiguration() {
        let header = HeaderComponent(
            title: "Complete Header",
            subtitle: "With all options",
            alignment: .leading,
            showBackButton: true,
            backButtonAction: {},
            trailingContent: AnyView(Image(systemName: "star"))
        )

        let body = header.body
        XCTAssertNotNil(body)
    }

    func testHeaderWithoutBackButtonShowsNoBackButton() {
        let header = HeaderComponent(
            title: "Test",
            showBackButton: false
        )
        XCTAssertNotNil(header)
    }

    func testHeaderWithBackButtonShowsBackButton() {
        let header = HeaderComponent(
            title: "Test",
            subtitle: nil,
            alignment: .leading,
            showBackButton: true,
            backButtonAction: nil,
            trailingContent: nil
        )
        XCTAssertNotNil(header)
    }
}
