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
    var minimumTemperature:Double?
    var maximumTemperature:Double?
}

class CurrentWeatherModel:NSObject {
    weak var delegate : CurrentWeatherDelegate?
    lazy var weatherService:WeatherService = {
       return WeatherService()
    }()
    
    func getCurrentWeatherFor(_ city:CityCoordinates) {
        let currentWeather = CurrentWeather()
        self.weatherService.fetchCurrentWeatherForLocationWith(latitude: city.lattitude!, longitude: city.longitude!, onSuccess: { (results) in
            
            if let weather = results["weather"] as? [[String:Any]], weather.count > 0 {
                if let weatherDescription = weather[0]["description"] as? String {
                    currentWeather.weatherDescription = weatherDescription
                }
            }
            
            if let main = results["main"] as? [String:Any], main.count > 0 {
                if let currentTemperature = main["temp"] as? Double {
                    currentWeather.currentTemperature = currentTemperature
                }
                
                if let minimumTemperature = main["temp_min"] as? Double {
                    currentWeather.minimumTemperature = minimumTemperature
                }
                
                if let maximumTemperature = main["temp_max"] as? Double {
                    currentWeather.maximumTemperature = maximumTemperature
                }
            }
            
            if let sys = results["sys"] as? [String:Any] {
                if let country = sys["country"] as? String {
                    if let cityName = results["name"] as? String {
                        currentWeather.cityName = cityName + ", \(country)"
                    }
                }
            }
            
            self.delegate?.currentWeatherDataReceived(currentWeather)
        }) { (error) in
            self.delegate?.currentWeatherDataReceivedWithError(error)
        }
    }
}

