//
//  ComicAppUITests.swift
//  ComicAppUITests
//
//  Created by Ivan Tonial IP.TV on 07/10/25.
//

import XCTest

final class ComicAppUITests: XCTestCase {

    // MARK: - Properties

    var app: XCUIApplication!

    // MARK: - Setup & Teardown

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it's important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }

    // MARK: - App Launch Tests

    @MainActor
    func testAppLaunchesSuccessfully() throws {
        // Verifica se a tab bar está presente após o launch
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 10), "Tab bar should exist after app launch")
    }

    // MARK: - Tab Bar Tests

    @MainActor
    func testTabBarHasFourTabs() throws {
        // Aguarda a tab bar aparecer
        let tabBar = app.tabBars.firstMatch
        guard tabBar.waitForExistence(timeout: 10) else {
            XCTFail("Tab bar not found")
            return
        }

        // Verifica se há 4 botões na tab bar
        let tabButtons = tabBar.buttons
        XCTAssertEqual(tabButtons.count, 4, "Tab bar should have 4 tabs")
    }

    @MainActor
    func testCharactersTabIsDefault() throws {
        // Verifica se a tab Characters está selecionada por padrão
        let tabBar = app.tabBars.firstMatch
        guard tabBar.waitForExistence(timeout: 10) else {
            XCTFail("Tab bar not found")
            return
        }

        let charactersTab = tabBar.buttons["Characters"]
        XCTAssertTrue(charactersTab.exists, "Characters tab should exist")
        XCTAssertTrue(charactersTab.isSelected, "Characters tab should be selected by default")
    }

    @MainActor
    func testCanSwitchToSearchTab() throws {
        let tabBar = app.tabBars.firstMatch
        guard tabBar.waitForExistence(timeout: 10) else {
            XCTFail("Tab bar not found")
            return
        }

        // Tenta mudar para a tab Search
        let searchTab = tabBar.buttons["Search"]
        XCTAssertTrue(searchTab.exists, "Search tab should exist")
        searchTab.tap()

        XCTAssertTrue(searchTab.isSelected, "Search tab should be selected after tap")
    }

    @MainActor
    func testCanSwitchToFavoritesTab() throws {
        let tabBar = app.tabBars.firstMatch
        guard tabBar.waitForExistence(timeout: 10) else {
            XCTFail("Tab bar not found")
            return
        }

        // Tenta acessar a tab Favorites
        let favoritesTab = tabBar.buttons["Favorites"]
        XCTAssertTrue(favoritesTab.exists, "Favorites tab should exist")
        favoritesTab.tap()

        XCTAssertTrue(favoritesTab.isSelected, "Favorites tab should be selected after tap")
    }

    @MainActor
    func testCanSwitchToSettingsTab() throws {
        let tabBar = app.tabBars.firstMatch
        guard tabBar.waitForExistence(timeout: 10) else {
            XCTFail("Tab bar not found")
            return
        }

        // Tenta acessar a tab Settings
        let settingsTab = tabBar.buttons["Settings"]
        XCTAssertTrue(settingsTab.exists, "Settings tab should exist")
        settingsTab.tap()

        XCTAssertTrue(settingsTab.isSelected, "Settings tab should be selected after tap")
    }

    @MainActor
    func testCanCycleThroughAllTabs() throws {
        let tabBar = app.tabBars.firstMatch
        guard tabBar.waitForExistence(timeout: 10) else {
            XCTFail("Tab bar not found")
            return
        }

        // Cicla por todas as tabs
        let tabs = ["Characters", "Search", "Favorites", "Settings"]

        for tabName in tabs {
            let tab = tabBar.buttons[tabName]
            XCTAssertTrue(tab.exists, "\(tabName) tab should exist")
            tab.tap()
            XCTAssertTrue(tab.isSelected, "\(tabName) tab should be selected after tap")
        }
    }

    // MARK: - Characters Tab Tests

    @MainActor
    func testCharactersTabShowsContent() throws {
        let tabBar = app.tabBars.firstMatch
        guard tabBar.waitForExistence(timeout: 10) else {
            XCTFail("Tab bar not found")
            return
        }

        // Garante que estamos na tab Characters
        let charactersTab = tabBar.buttons["Characters"]
        charactersTab.tap()

        // Aguarda algum conteúdo aparecer (loading ou lista)
        // Pode ser um loading indicator ou os personagens carregados
        let contentExists = app.scrollViews.firstMatch.waitForExistence(timeout: 15) ||
                           app.collectionViews.firstMatch.waitForExistence(timeout: 15) ||
                           app.staticTexts.firstMatch.waitForExistence(timeout: 15)

        XCTAssertTrue(contentExists, "Characters tab should show some content")
    }

    // MARK: - Search Tab Tests

    @MainActor
    func testSearchTabShowsSearchField() throws {
        let tabBar = app.tabBars.firstMatch
        guard tabBar.waitForExistence(timeout: 10) else {
            XCTFail("Tab bar not found")
            return
        }

        // Navega para a tab Search
        let searchTab = tabBar.buttons["Search"]
        searchTab.tap()

        // Verifica se existe um campo de busca ou texto relacionado à busca
        let searchFieldExists = app.searchFields.firstMatch.waitForExistence(timeout: 5) ||
                               app.textFields.firstMatch.waitForExistence(timeout: 5)

        // Search pode ter um campo de busca ou apenas mostrar conteúdo
        XCTAssertTrue(searchFieldExists || app.staticTexts.count > 0, "Search tab should show search interface")
    }

    // MARK: - Favorites Tab Tests

    @MainActor
    func testFavoritesTabShowsContent() throws {
        let tabBar = app.tabBars.firstMatch
        guard tabBar.waitForExistence(timeout: 10) else {
            XCTFail("Tab bar not found")
            return
        }

        // Navega para a tab Favorites
        let favoritesTab = tabBar.buttons["Favorites"]
        favoritesTab.tap()

        // Aguarda conteúdo (pode ser lista vazia ou com favoritos)
        let hasContent = app.staticTexts.firstMatch.waitForExistence(timeout: 5) ||
                        app.scrollViews.firstMatch.waitForExistence(timeout: 5) ||
                        app.collectionViews.firstMatch.waitForExistence(timeout: 5)

        XCTAssertTrue(hasContent, "Favorites tab should show some content or empty state")
    }

    // MARK: - Settings Tab Tests

    @MainActor
    func testSettingsTabShowsContent() throws {
        let tabBar = app.tabBars.firstMatch
        guard tabBar.waitForExistence(timeout: 10) else {
            XCTFail("Tab bar not found")
            return
        }

        // Navega para a tab Settings
        let settingsTab = tabBar.buttons["Settings"]
        settingsTab.tap()

        // Verifica se existe conteúdo de configurações
        let hasContent = app.scrollViews.firstMatch.waitForExistence(timeout: 5) ||
                        app.tables.firstMatch.waitForExistence(timeout: 5) ||
                        app.staticTexts.count > 0

        XCTAssertTrue(hasContent, "Settings tab should show settings content")
    }

    // MARK: - Navigation Tests

    @MainActor
    func testCanNavigateBackFromCharactersTab() throws {
        let tabBar = app.tabBars.firstMatch
        guard tabBar.waitForExistence(timeout: 10) else {
            XCTFail("Tab bar not found")
            return
        }

        // Navega para outra tab e volta
        let searchTab = tabBar.buttons["Search"]
        searchTab.tap()

        let charactersTab = tabBar.buttons["Characters"]
        charactersTab.tap()

        XCTAssertTrue(charactersTab.isSelected, "Should be able to navigate back to Characters tab")
    }
}

// MARK: - Performance Tests

final class ComicAppUIPerformanceTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func testLaunchPerformance() throws {
        // Mede o tempo de inicialização do app
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
        }
    }

    @MainActor
    func testTabSwitchingPerformance() throws {
        app.launch()

        let tabBar = app.tabBars.firstMatch
        guard tabBar.waitForExistence(timeout: 10) else {
            XCTFail("Tab bar not found")
            return
        }

        // Mede performance de troca de tabs
        measure {
            tabBar.buttons["Search"].tap()
            tabBar.buttons["Favorites"].tap()
            tabBar.buttons["Settings"].tap()
            tabBar.buttons["Characters"].tap()
        }
    }
}
