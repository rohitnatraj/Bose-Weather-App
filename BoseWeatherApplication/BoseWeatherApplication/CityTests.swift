//
//  CityTests.swift
//  BoseWeatherApplication
//
//  Created by Rohit Natraj on 8/9/17.
//  Copyright © 2017 RohitNatraj. All rights reserved.
//

import XCTest
@testable import BoseWeatherApplication

class CityTests: XCTestCase {
        
        var city = City()
        let searchBar = UISearchBar()
        let cityModel = CityModel()
    
    override func setUp() {
        super.setUp()
        self.city.searchBar = searchBar
        self.city.searchBar.delegate = self.city
        self.city.model = cityModel
        self.city.model.delegate = self.city
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
        func testNumberOfRowsInSectionReturnsCorrectly() {
                self.city.isSearching = true
                let cityCoordinates1 = CityCoordinates()
                let cityCoordinates2 = CityCoordinates()
                let cityCoordinates3 = CityCoordinates()
                self.city.cityCoordinates = [cityCoordinates1, cityCoordinates2, cityCoordinates3]
                
                let expectedRows = 3
                let actualRows = self.city.tableView.numberOfRows(inSection: 0)
                XCTAssertTrue(expectedRows == actualRows, "Number of rows are not as per expectation")
        }
        
        func testCityTableViewIsConnectedToDelegate() {
                XCTAssertNotNil(self.city.tableView.delegate, "Delegate is not set")
        }
        
        func testCityTableViewIsConnectedToDataSource() {
                XCTAssertNotNil(self.city.tableView.dataSource, "DataSource is not set")
        }
        
        func testCityTableViewConformsToUITableViewDataSource() {
                XCTAssertTrue(self.city.conforms(to: UITableViewDataSource.self), "City TableView does not conform to UITableViews Datasource")
        }
        
        func testCityTableViewConformsToUITableViewDelegate() {
                XCTAssertTrue(self.city.conforms(to: UITableViewDelegate.self), "City TableView does not conform to UITableViews Delegate")
        }
        
        func testSearchBarTextDidChangeWith3CharactersSetsIsSearchingToTrue() {
                self.city.searchBar(self.searchBar, textDidChange: "ABC")
                XCTAssertTrue(self.city.isSearching)
        }
        
        func testSearchBarTextDidChangeWithLessThan3CharactersSetsIsSearchingToFalse() {
                self.city.searchBar(self.searchBar, textDidChange: "AB")
                XCTAssertFalse(self.city.isSearching)
        }
}
