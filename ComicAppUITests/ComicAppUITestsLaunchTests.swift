//
//  ComicAppUITestsLaunchTests.swift
//  ComicAppUITests
//
//  Created by Ivan Tonial IP.TV on 07/10/25.
//

import XCTest

final class ComicAppUITestsLaunchTests: XCTestCase {

    // MARK: - Properties

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    // MARK: - Setup & Teardown

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // MARK: - Launch Tests

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Captura screenshot da tela inicial
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testLaunchShowsTabBar() throws {
        let app = XCUIApplication()
        app.launch()

        // Verifica se a tab bar está visível após o launch
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 10), "Tab bar should be visible after launch")

        // Captura screenshot com tab bar visível
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch - Tab Bar Visible"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testLaunchShowsCharactersTab() throws {
        let app = XCUIApplication()
        app.launch()

        // Verifica se a tab Characters está selecionada por padrão
        let tabBar = app.tabBars.firstMatch
        guard tabBar.waitForExistence(timeout: 10) else {
            XCTFail("Tab bar not found")
            return
        }

        let charactersTab = tabBar.buttons["Characters"]
        XCTAssertTrue(charactersTab.exists, "Characters tab should exist")
        XCTAssertTrue(charactersTab.isSelected, "Characters tab should be selected on launch")

        // Captura screenshot da tab Characters
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch - Characters Tab Selected"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testLaunchInDarkMode() throws {
        let app = XCUIApplication()
        app.launch()

        // Aguarda o app carregar completamente
        let tabBar = app.tabBars.firstMatch
        _ = tabBar.waitForExistence(timeout: 10)

        // Captura screenshot em Dark Mode (tema padrão do app)
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch - Dark Mode"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testLaunchAllTabsScreenshots() throws {
        let app = XCUIApplication()
        app.launch()

        let tabBar = app.tabBars.firstMatch
        guard tabBar.waitForExistence(timeout: 10) else {
            XCTFail("Tab bar not found")
            return
        }

        // Captura screenshot de cada tab
        let tabs = ["Characters", "Search", "Favorites", "Settings"]

        for tabName in tabs {
            let tab = tabBar.buttons[tabName]
            if tab.exists {
                tab.tap()

                // Aguarda um momento para a tela carregar
                Thread.sleep(forTimeInterval: 0.5)

                let attachment = XCTAttachment(screenshot: app.screenshot())
                attachment.name = "Launch - \(tabName) Tab"
                attachment.lifetime = .keepAlways
                add(attachment)
            }
        }
    }
}
