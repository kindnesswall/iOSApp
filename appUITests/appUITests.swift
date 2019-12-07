////
////  appUITests.swift
////  appUITests
////
////  Created by Hamed.Gh on 11/28/18.
////  Copyright © 2018 Hamed.Gh. All rights reserved.
////
//
//import XCTest
//
//class appUITests: XCTestCase {
//
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//
//        // In UI tests it is usually best to stop immediately when a failure occurs.
//        continueAfterFailure = false
//
//        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
////        XCUIApplication().launch()
//
//        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
//        
//        let app = XCUIApplication()
//        setupSnapshot(app)
//        app.launch()
//        snapshot("0Launch")
//    }
//
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() {
//        // Use recording to get started writing UI tests.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        
//        let app = XCUIApplication()
//        let tablesQuery = app.tables
//        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["نیازمند گوشی هستم هر کی پول دارم برام بده 09103862948اس بده"]/*[[".cells.staticTexts[\"نیازمند گوشی هستم هر کی پول دارم برام بده 09103862948اس بده\"]",".staticTexts[\"نیازمند گوشی هستم هر کی پول دارم برام بده 09103862948اس بده\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        
//        let homeButton = app.navigationBars["app.GiftDetailView"].buttons["Home"]
//        homeButton.tap()
//        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["ب یک دوربین عکاسی احتیاج دارم هر کی داره لطفا بده خیلی ممنون "]/*[[".cells.staticTexts[\"ب یک دوربین عکاسی احتیاج دارم هر کی داره لطفا بده خیلی ممنون \"]",".staticTexts[\"ب یک دوربین عکاسی احتیاج دارم هر کی داره لطفا بده خیلی ممنون \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        
//        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .scrollView).element.children(matching: .other).element
//        element.children(matching: .other).element(boundBy: 0).children(matching: .scrollView).element.children(matching: .scrollView).element.children(matching: .image).element.swipeUp()
//        app.buttons["ic cross white"].tap()
//        element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 0).swipeUp()
//        homeButton.tap()
//        app.tabBars.buttons["My Wall"].tap()
//        app.buttons["Statistics"].tap()
//        app.navigationBars["Statistic"].buttons["My Wall"].tap()
//                
//        
//    }
//
//}
