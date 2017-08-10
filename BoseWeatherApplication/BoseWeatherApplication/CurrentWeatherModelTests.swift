//
//  CurrentWeatherModelTests.swift
//  BoseWeatherApplication
//
//  Created by Rohit Natraj on 8/9/17.
//  Copyright © 2017 RohitNatraj. All rights reserved.
//

import XCTest
@testable import BoseWeatherApplication

class CurrentWeatherModelTests: XCTestCase {
        
        let weatherModel = CurrentWeatherModel()
        var city = CityCoordinates()
    
    override func setUp() {
        super.setUp()
        self.city.cityName = "Paris"
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        self.city.cityName = nil
    }
        
        func testParseCurrentWeather() {
                
                let response = readJson(with: "WeatherService")
                let currentWeather:CurrentWeather = weatherModel.parseCurrentWeather(response, city: self.city)
                XCTAssertTrue(currentWeather.currentTemperature == 62.6, "Current Temperature was not set correctly")
                XCTAssertTrue(currentWeather.humidity == 72, "Humidity was not set correctly")
                XCTAssertTrue(currentWeather.isDay!, "IsDay was not set correctly")
                XCTAssertTrue(currentWeather.weatherDescription == "Moderate or heavy rain with thunder", "Weather Description was not set correctly")
                XCTAssertTrue(currentWeather.code == 1276, "Code was not set correctly")
        }
        
        func testParseForecast() {
                self.city.cityName = "Paris"
                let response = readJson(with: "WeatherService")
                let forecast:[WeatherForecast] = weatherModel.parseForecast(response, city: self.city)
                XCTAssertTrue(forecast.count == 7, "Count of forecast days was not correct")
                XCTAssertTrue(forecast.first?.cityName == "Paris", "City Name was not set correctly")
                XCTAssertTrue(forecast.first?.date == "2017-08-10", "Date was not set correctly")
                XCTAssertTrue(forecast.first?.maxTemperatureInFarenheit == 73.4, "Max temperature in Farenheit was not set correctly")
                XCTAssertTrue(forecast.first?.minTemperatureInFarenheit == 57.9, "Min temperature in Farenheit was not set correctly")
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
