//
//  ToDoAppUITests.swift
//  ToDoAppUITests
//
//  Created by IOS DEV on 25/09/2019.
//  Copyright © 2019 IOS DEV. All rights reserved.
//

import XCTest

class ToDoAppUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
    }
    
    func test_AddEdit() {
        test_SkipLogin()
        test_AddTask()
        test_EditTask()
    }
    
    func test_SkipLogin() {
        let skipButton = XCUIApplication().buttons["Skip Sign in"]
        skipButton.tap()
    }
    

    func test_AddTask() {
        let rightNavBarButton = XCUIApplication().navigationBars.children(matching: .button).firstMatch
        rightNavBarButton.tap()
        enterTestData()
    }
    
    func test_EditTask() {
        let cellQuery = XCUIApplication().tables.cells.element(boundBy: 0)
        cellQuery.tap()
        enterTestData()
    }
    
    func enterTestData() {
        let textfield = XCUIApplication().textFields.children(matching: .textField).firstMatch
        textfield.tap()
        textfield.typeText("test")
        textfield.typeText("\n")
        let addButton = XCUIApplication().buttons["ADD"]
        addButton.tap()
    }
    
    

}
