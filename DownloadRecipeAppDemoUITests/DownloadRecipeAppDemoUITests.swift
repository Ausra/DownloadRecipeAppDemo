import SwiftUI
import SwiftData
import XCTest
@testable import DownloadRecipeAppDemo

final class DownloadRecipeAppDemoUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    @MainActor
    func testExample() throws {
        XCTAssertEqual(app.cells.count, 0, "There should be 0 recipes when the app is first launched.")
    }

    @MainActor func testDownloadRecipeSheetAppears() {
        let addButton = app.buttons["Add Recipe"]
        XCTAssertTrue(addButton.exists, "The 'Add Recipe' button should exist.")
        addButton.tap()

        XCTAssertTrue(app.navigationBars.buttons["Download"].exists, "The download sheet with Download button should be presented when 'Add Recipe' is tapped.")
    }

    @MainActor func testEditButtonExists() {
        let editButton = app.buttons["Edit"]
        XCTAssertTrue(editButton.exists, "The 'Edit' button should exist.")

    }

    @MainActor func testAccessibility() throws {
        // Verify the navigation title
        XCTAssertTrue(app.navigationBars["Recipes"].exists)

        // Verify the Add Recipe button
        let addRecipeButton = app.buttons["Add Recipe"]
        XCTAssertTrue(addRecipeButton.exists)
        XCTAssertEqual(addRecipeButton.label, "Add Recipe")

        // Verify the Edit button
        let editButton = app.buttons["Edit"]
        XCTAssertTrue(editButton.exists)
        XCTAssertEqual(editButton.label, "Edit")

        addRecipeButton.tap()

        //Verify download button in download sheet
        let downloadButton = app.navigationBars.buttons["Download"]

        XCTAssertTrue(downloadButton.exists)
        XCTAssertEqual(downloadButton.label, "Download")

        //Verify cancel button in download sheet
        let cancelButton = app.navigationBars.buttons["Cancel"]

        XCTAssertTrue(cancelButton.exists)
        XCTAssertEqual(cancelButton.label, "Cancel")

        let urlField = app.textFields["Recipe URL"]
        XCTAssertTrue(urlField.exists)
        XCTAssertEqual(urlField.label, "Recipe URL")
    }
}

