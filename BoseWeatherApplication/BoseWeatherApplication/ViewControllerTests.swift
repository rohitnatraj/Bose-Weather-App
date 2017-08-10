//
//  ViewControllerTests.swift
//  BoseWeatherApplication
//
//  Created by Rohit Natraj on 8/9/17.
//  Copyright © 2017 RohitNatraj. All rights reserved.
//

import XCTest
@testable import BoseWeatherApplication

class ViewControllerTests: XCTestCase {

        let viewController = ViewController()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
        
        func testUserSelectedCitySetsTheUserDefaults() {
                let city = CityCoordinates()
                city.cityName = "Denver, CO"
                city.lattitude = 65.78
                city.longitude = 55.67
                self.viewController.userSelected(city)
                
                if let city = UserDefaults.standard.value(forKey: "City") as? Data {
                        let unarc = NSKeyedUnarchiver(forReadingWith: city)
                        if let newBlog = unarc.decodeObject(forKey: "root") as? CityCoordinates {
                                XCTAssertEqual("Denver, CO", newBlog.cityName)
                                XCTAssertEqual(65.78, newBlog.lattitude)
                                XCTAssertEqual(55.67, newBlog.longitude)
                        }
                }
        }
        
        
    
}
