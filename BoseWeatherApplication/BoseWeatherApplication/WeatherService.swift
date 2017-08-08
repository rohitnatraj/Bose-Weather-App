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
        let openWeatherMapBaseURL = "https://api.apixu.com/v1/forecast.json?key=a7c8ab17bdfc49a5955232316170608&q="
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)\(latitude),\(longitude)&days=7")
        let queue = DispatchQueue(label: "Background")
        queue.async {
            if let weatherURL = weatherRequestURL {
                let task = session.dataTask(with: weatherURL) { (data, response, error) in
                    if error != nil {
                        DispatchQueue.main.async {
                            failure(error!)
                        }
                        
                    } else {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any] {
                                DispatchQueue.main.async {
                                    success(json)
                                }
                                
                            }
                        }
                        catch {
                            
                        }
                    }
                }
                task.resume()
            }
        }
        
    }
}
