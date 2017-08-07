//
//  CurrentWeatherModel.swift
//  BoseWeatherApplication
//
//  Created by Rohit Natraj on 8/6/17.
//  Copyright © 2017 RohitNatraj. All rights reserved.
//

import Foundation

protocol CurrentWeatherDelegate: class {
    func currentWeatherDataReceived(_ data:CurrentWeather)
    func currentWeatherDataReceivedWithError(_ error:Error?)
}

class CurrentWeather:NSObject {
    var cityName:String?
    var weatherDescription:String?
    var currentTemperature:Double?
    var humidity:Double?
    var code:Int?
    var isDay:Bool?
}

class CurrentWeatherModel:NSObject {
    weak var delegate : CurrentWeatherDelegate?
    lazy var weatherService:WeatherService = {
       return WeatherService()
    }()
    
    func getCurrentWeatherFor(_ city:CityCoordinates) {
        let currentWeather = CurrentWeather()
        self.weatherService.fetchCurrentWeatherForLocationWith(latitude: city.lattitude!, longitude: city.longitude!, onSuccess: { (results) in
            currentWeather.cityName = city.cityName
            
            if let current = results["current"] as? [String:Any], current.count > 0 {
                if let currentTemperatureInFarenheit = current["temp_f"] as? Double {
                    currentWeather.currentTemperature = currentTemperatureInFarenheit
                }
                
                if let humidity = current["humidity"] as? Double {
                    currentWeather.humidity = humidity
                }
                
                if let isDay = current["is_day"] as? Int {
                    currentWeather.isDay = Bool(isDay as NSNumber)
                    
                }
                
                if let condition = current["condition"] as? [String:Any], condition.count > 0 {
                    if let description = condition["text"] as? String {
                        currentWeather.weatherDescription = description
                    }
                    if let code = condition["code"] as? Int {
                        currentWeather.code = code
                    }
                }
            }
            
            self.delegate?.currentWeatherDataReceived(currentWeather)
        }) { (error) in
            self.delegate?.currentWeatherDataReceivedWithError(error)
        }
    }
}

