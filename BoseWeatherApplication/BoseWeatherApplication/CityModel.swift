//
//  CityModel.swift
//  BoseWeatherApplication
//
//  Created by Rohit Natraj on 8/5/17.
//  Copyright © 2017 RohitNatraj. All rights reserved.
//

import Foundation

protocol CityDelegate: class {
        func cityDataReceived(_ data:[CityCoordinates])
        func cityDataReceivedWithError(_ error:Error?)
}

class CityCoordinates:NSObject, NSCoding {
        
        var longitude:Double? = nil
        var lattitude:Double? = nil
        var cityName:String? = nil
        
        override init() {}
        
        func isEmpty() -> Bool {
                return (self.longitude == nil && self.lattitude == nil && self.cityName == nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
                
                self.longitude = aDecoder.decodeDouble(forKey:"longitude")
                self.lattitude = aDecoder.decodeDouble(forKey: "lattitude")
                self.cityName = aDecoder.decodeObject(forKey: "cityName") as? String
        }
        
        func encode(with aCoder: NSCoder) {
                if let longitude = self.longitude {
                        aCoder.encode(longitude, forKey: "longitude")
                }
                
                if let lattitude = self.lattitude {
                        aCoder.encode(lattitude, forKey: "lattitude")
                }
                
                if let cityName = self.cityName {
                        aCoder.encode(cityName, forKey: "cityName")
                }
        }
}

class CityModel:NSObject {
        weak var delegate : CityDelegate?
        lazy var cityService: CityService = {
                return CityService()
        }()
        
        func detailsFor(_ cities:String) {
                var cityCoordinatesArray = [CityCoordinates]()
                self.cityService.fetchCities(cities, onSuccess: { (result) in
                        cityCoordinatesArray = self.parse(result)
                        self.delegate?.cityDataReceived(cityCoordinatesArray)
                }, onFailure: {(error) in
                        self.delegate?.cityDataReceivedWithError(error)
                })
        }
        
        func parse(_ result:[String:Any]) -> [CityCoordinates] {
                var cityCoordinatesArray = [CityCoordinates]()
                if let results = result["results"] as? [[String:Any]], results.count > 0 {
                        for result in results {
                                let cityCoordinates = CityCoordinates()
                                
                                if let geometry = result["geometry"] as? [String:Any], geometry.count > 0 {
                                        if let location = geometry["location"] as? [String:Any], location.count > 0 {
                                                if let lattitude = location["lat"] as? Double, let longitude = location["lng"] as? Double {
                                                        cityCoordinates.lattitude = lattitude
                                                        cityCoordinates.longitude = longitude
                                                }
                                        }
                                }
                                
                                if let addressComponents = result["address_components"] as? [[String:Any]], addressComponents.count > 0 {
                                        for addressComponent in addressComponents {
                                                if let types = addressComponent["types"] as? [String] {
                                                        if (types.contains("locality")) {
                                                                if let cityName = addressComponent["long_name"] as? String {
                                                                        cityCoordinates.cityName = cityName
                                                                }
                                                        } else if (types.contains("administrative_area_level_2")) {
                                                                if let cityName = addressComponent["long_name"] as? String {
                                                                        if cityCoordinates.cityName == nil {
                                                                                cityCoordinates.cityName = cityName
                                                                        }
                                                                }
                                                        } else if (types.contains("administrative_area_level_1")) {
                                                                if let cityName = addressComponent["long_name"] as? String {
                                                                        if cityCoordinates.cityName == nil {
                                                                                cityCoordinates.cityName = cityName
                                                                        }
                                                                }
                                                        }
                                                        
                                                        if (types.contains("country")) {
                                                                if let countryName = addressComponent["short_name"] as? String {
                                                                        cityCoordinates.cityName?.append(", \(countryName)")
                                                                }
                                                        }
                                                }
                                        }
                                }
                                cityCoordinatesArray.append(cityCoordinates)
                        }
                        
                }
                return cityCoordinatesArray
        }
}
