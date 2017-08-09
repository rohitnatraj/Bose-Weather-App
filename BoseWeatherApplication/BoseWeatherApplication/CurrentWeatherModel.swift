//
//  CurrentWeatherModel.swift
//  BoseWeatherApplication
//
//  Created by Rohit Natraj on 8/6/17.
//  Copyright © 2017 RohitNatraj. All rights reserved.
//

import Foundation
import UIKit

protocol CurrentWeatherDelegate: class {
        func currentWeatherDataReceived(_ data:CurrentWeather)
        func currentWeatherDataReceivedWithError(_ error:Error?)
        func forecastReceived(_ data:[WeatherForecast])
}

class CurrentWeather:NSObject {
        var cityName:String?
        var weatherDescription:String?
        var currentTemperature:Double?
        var humidity:Double?
        var code:Int?
        var isDay:Bool?
}

class WeatherForecast:NSObject {
        var cityName:String?
        var date:String?
        var maxTemperatureInFarenheit:Double?
        var minTemperatureInFarenheit:Double?
}

class CurrentWeatherModel:NSObject {
        weak var delegate : CurrentWeatherDelegate?
        lazy var weatherService:WeatherService = {
                return WeatherService()
        }()
        
        func getCurrentWeatherFor(_ city:CityCoordinates) {
                if !city.isEmpty() {
                        let currentWeather = CurrentWeather()
                        var weatherForecast = [WeatherForecast]()
                        self.weatherService.fetchCurrentWeatherForLocationWith(latitude: city.lattitude!, longitude: city.longitude!, onSuccess: { (results) in
                                if let cityName = city.cityName {
                                        currentWeather.cityName = cityName
                                }
                                
                                
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
                                
                                if let forecast = results["forecast"] as? [String:Any], forecast.count > 0 {
                                        if let forecastDay = forecast["forecastday"] as? [[String:Any]], forecastDay.count > 0 {
                                                for each in forecastDay {
                                                        let eachDayWeatherForecast = WeatherForecast()
                                                        eachDayWeatherForecast.cityName = city.cityName
                                                        if let date = each["date"] as? String {
                                                                eachDayWeatherForecast.date = date
                                                        }
                                                        
                                                        if let day = each["day"] as? [String : Any], day.count > 0 {
                                                                if let minimumTempInF = day["mintemp_f"] as? Double {
                                                                        eachDayWeatherForecast.minTemperatureInFarenheit = minimumTempInF
                                                                }
                                                                if let maximumTempInF = day["maxtemp_f"] as? Double {
                                                                        eachDayWeatherForecast.maxTemperatureInFarenheit = maximumTempInF
                                                                }
                                                                
                                                        }
                                                        weatherForecast.append(eachDayWeatherForecast)
                                                }
                                        }
                                }
                                
                                self.delegate?.currentWeatherDataReceived(currentWeather)
                                self.delegate?.forecastReceived(weatherForecast)
                        }) { (error) in
                                self.delegate?.currentWeatherDataReceivedWithError(error)
                        }
                }
                
        }
}

