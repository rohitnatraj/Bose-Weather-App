//
//  CityModelTests.swift
//  BoseWeatherApplication
//
//  Created by Rohit Natraj on 8/10/17.
//  Copyright © 2017 RohitNatraj. All rights reserved.
//

import XCTest
@testable import BoseWeatherApplication

let model = CityModel()

class CityModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
        
        func testParseResultFromService() {
                let response = readJson(with: "CityService")
                let cityCoordinatesArray:[CityCoordinates] = model.parse(response)
                XCTAssertTrue(cityCoordinatesArray.first?.cityName == "Denver, US", "CityName was not set correctly")
                XCTAssertTrue(cityCoordinatesArray.first?.lattitude == 39.7392358, "Lattitude was not set correctly")
                XCTAssertTrue(cityCoordinatesArray.first?.longitude == -104.990251, "Longitude was not set correctly")
                
        }
        
        private func readJson(with fileName:String) -> [String:Any] {
                var response = [String:Any]()
                
                do {
                        if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
                                let data = try Data(contentsOf: file)
                                let json = try JSONSerialization.jsonObject(with: data, options: [])
                                if let object = json as? [String:Any] {
                                        response = object
                                }
                        } else {
                                print("no file")
                        }
                } catch {
                        print(error.localizedDescription)
                }
                
                return response
        }
    
}
