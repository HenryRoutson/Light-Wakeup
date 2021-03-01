//
//  Light_WakeupUITests.swift
//  Light WakeupUITests
//
//  Created by Henry on 1/3/21.
//

import XCTest

class Light_WakeupUITests: XCTestCase {

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let NotificationToggle = app.switches["NotificationToggle"]
        NotificationToggle.tap()
        NotificationToggle.tap()

        //let WakeupTimePicker = app.picker["WakeupTimePicker"]
        
        let ViewSelections = app.collectionViews["ViewSelections"]
        ViewSelections.swipeRight()
        ViewSelections.swipeLeft()
        ViewSelections.swipeRight()

    }
}
