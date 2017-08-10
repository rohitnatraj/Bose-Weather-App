//
//  ForecastTests.swift
//  BoseWeatherApplication
//
//  Created by Rohit Natraj on 8/9/17.
//  Copyright © 2017 RohitNatraj. All rights reserved.
//

import XCTest
@testable import BoseWeatherApplication

class ForecastTests: XCTestCase {

let foreCastTable = Forecast()
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
        func testNumberOfRowsInSectionReturnsCorrectly() {
                let weatherForecast1 = WeatherForecast()
                let weatherForecast2 = WeatherForecast()
                let weatherForecast3 = WeatherForecast()
                self.foreCastTable.forecast = [weatherForecast1, weatherForecast2, weatherForecast3]
                
                let expectedRows = 3
                let actualRows = self.foreCastTable.tableView.numberOfRows(inSection: 0)
                XCTAssertTrue(expectedRows == actualRows, "Number of rows are not as per expectation")
        }
        
        func testForecastTableViewIsConnectedToDelegate() {
                XCTAssertNotNil(self.foreCastTable.tableView.delegate, "Delegate is not set")
        }
        
        func testForecastTableViewIsConnectedToDataSource() {
                XCTAssertNotNil(self.foreCastTable.tableView.dataSource, "DataSource is not set")
        }
        
        func testForecastTableViewConformsToUITableViewDataSource() {
                XCTAssertTrue(self.foreCastTable.conforms(to: UITableViewDataSource.self), "Forecast TableView does not conform to UITableViews Datasource")
        }
        
        func testForecastTableViewConformsToUITableViewDelegate() {
                XCTAssertTrue(self.foreCastTable.conforms(to: UITableViewDelegate.self), "Forecast TableView does not conform to UITableViews Delegate")
        }
        
        func testGetDateForMethodReturnsTheDataCorrectly() {
                let weatherForecast1 = WeatherForecast()
                weatherForecast1.date = "2017-08-09"
                self.foreCastTable.forecast = [weatherForecast1]
                let indexpath = IndexPath(row: 0, section: 0)
                let result = self.foreCastTable.getDateFor(indexpath)
                XCTAssertTrue(result == "Wednesday", "Date was converted correctly")
                
        }
    
}
