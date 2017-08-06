//
//  WeatherService.swift
//  BoseWeatherApplication
//
//  Created by Rohit Natraj on 8/5/17.
//  Copyright © 2017 RohitNatraj. All rights reserved.
//

import Foundation

class WeatherService:NSObject {
    func fetchCurrentWeatherForLocationWith(latitude:Double, longitude:Double, onSuccess success:@escaping([String:Any]) -> Void, onFailure failure:@escaping(Error) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?lat=\(latitude)&lon=\(longitude)")!
        
        let task = session.dataTask(with: weatherRequestURL) { (data, response, error) in
            if error != nil {
                failure(error!)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any] {
                        success(json)
                    }
                }
                catch {
                    
                }
            }
        }
        task.resume()
    }
    
    func fetchCurrentWeatherFor(_ location:String, onSuccess success:@escaping([String:Any]) -> Void, onFailure failure:@escaping(Error) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?q=\(location)")!
        
        let task = session.dataTask(with: weatherRequestURL) { (data, response, error) in
            if error != nil {
                failure(error!)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any] {
                        success(json)
                    }
                }
                catch {
                    
                }
                
            }
        }
        task.resume()
    }
    
}
