//
//  CityService.swift
//  BoseWeatherApplication
//
//  Created by Rohit Natraj on 8/5/17.
//  Copyright © 2017 RohitNatraj. All rights reserved.
//

import Foundation

class CityService:NSObject {
    
    func fetchCities(_ cities:String, onSuccess success:@escaping([String:Any]) -> Void, onFailure failure:@escaping(Error) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let openWeatherMapBaseURL = "http://maps.googleapis.com/maps/api/geocode/json"
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?address=\(cities)")!
        
        let task = session.dataTask(with: weatherRequestURL) { (data, response, error) in
            if let error = error {
                failure(error)
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
