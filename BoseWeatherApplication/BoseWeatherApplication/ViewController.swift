//
//  ViewController.swift
//  BoseWeatherApplication
//
//  Created by Rohit Natraj on 8/5/17.
//  Copyright © 2017 RohitNatraj. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CitySelectionDelegate, CurrentWeatherDelegate, CLLocationManagerDelegate {

    //Outlets
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var forecastButton: UIButton!
    //Instance Variable
    let currentWeatherModel = CurrentWeatherModel()
    let city = City()
    var forecastData : [WeatherForecast]?
    let locationManager = CLLocationManager()
    
    lazy var activityIndicator : UIActivityIndicatorView = {
        return UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    }()
    
    lazy var alertController : UIAlertController = {
        return UIAlertController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.city.citySelectionDelegate = self
        self.currentWeatherModel.delegate = self
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userSelected(_ city: CityCoordinates) {
        self.manageActivityIndicator(true)
        self.currentWeatherModel.getCurrentWeatherFor(city)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "citySegue" {
            let destination = segue.destination as? City
            destination?.citySelectionDelegate = self
        }
        
        if segue.identifier == "forecastSegue" {
            let destination = segue.destination as? Forecast
            destination?.forecast = self.forecastData
        }
    }
    
    func forecastReceived(_ data: [WeatherForecast]) {
        self.forecastData = data
    }
    
    func currentWeatherDataReceived(_ data: CurrentWeather) {
        self.locationManager.stopUpdatingLocation()
        self.manageActivityIndicator(false)
        self.cityName.text = data.cityName
        self.weatherDescription.text = data.weatherDescription
        
        let currentTemperatureString = String(describing:data.currentTemperature!)
        self.currentTemperature.text = String(format: currentTemperatureString + "\u{00B0}" + " F")
        
        let humidtyString = String(describing:data.humidity!)
        self.humidity.text = String(format: humidtyString + " \u{FF05}")
        
        if (data.isDay)! {
            self.weatherImage.image = UIImage(named: "day/\(String(describing:data.code!))")
        } else {
            self.weatherImage.image = UIImage(named: "night/\(String(describing:data.code!))")
        }
        
        self.forecastButton.isEnabled = true
    }
    
    func currentWeatherDataReceivedWithError(_ error: Error?) {
        self.alertController.title = "Error"
        self.alertController.message = error?.localizedDescription
        self.alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(self.alertController, animated: true, completion: nil)
    }
    
    //MARK: - Manage Activity Indicator
    func manageActivityIndicator(_ start:Bool) {
        if (self.activityIndicator.isAnimating && !start) {
            self.activityIndicator.stopAnimating()
        } else if (!self.activityIndicator.isAnimating && start) {
            self.activityIndicator.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
            self.view.addSubview(activityIndicator)
            self.activityIndicator.startAnimating()
        }
    }
    
    //MARK: - Core Location Delegates
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.alertController.title = "Error"
        self.alertController.message = error.localizedDescription
        self.alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(self.alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.manageActivityIndicator(true)
        if let locale:CLLocationCoordinate2D = manager.location?.coordinate {
            let cityCoordinates = CityCoordinates()
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(locations.first!, completionHandler: { (placemarksArray, error) in
                if let placemarks = placemarksArray, placemarks.count > 0 {
                    if let first = placemarks.first {
                        if let addressDictionary = first.addressDictionary {
                            if let city = addressDictionary["City"] {
                                if let country = addressDictionary["Country"] {
                                    cityCoordinates.cityName = "\(city), \(country)"
                                }
                            }
                        }
                    }
                }
            })
            
            cityCoordinates.longitude = locale.longitude
            cityCoordinates.lattitude = locale.latitude
            
            self.currentWeatherModel.getCurrentWeatherFor(cityCoordinates)
            
        }
    }
    
}

