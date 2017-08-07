//
//  ViewController.swift
//  BoseWeatherApplication
//
//  Created by Rohit Natraj on 8/5/17.
//  Copyright © 2017 RohitNatraj. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CitySelectionDelegate, CurrentWeatherDelegate {

    //Outlets
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    //Instance Variable
    let currentWeatherModel = CurrentWeatherModel()
    let city = City()
    
    lazy var activityIndicator : UIActivityIndicatorView = {
        return UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.city.citySelectionDelegate = self
        self.currentWeatherModel.delegate = self
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
    }
    
    func currentWeatherDataReceived(_ data: CurrentWeather) {
        self.manageActivityIndicator(false)
        
        self.cityName.text = data.cityName!
        self.weatherDescription.text = data.weatherDescription
        
        let currentTemperatureString = String(describing:data.currentTemperature!)
        self.currentTemperature.text = String(format: currentTemperatureString + "\u{00B0}" + " F")
        
        let humidtyString = String(describing:data.humidity!)
        self.humidity.text = String(format: humidtyString + " \u{FF05}")
        
        if (data.isDay)! {
            self.weatherImage.image = UIImage(imageLiteralResourceName: String(describing:data.code!))
        } else {
            self.weatherImage.image = UIImage(imageLiteralResourceName: String(describing:data.code!))
        }
    }
    
    func currentWeatherDataReceivedWithError(_ error: Error?) {
        let alert = UIAlertController()
        alert.title = "Error"
        alert.message = error?.localizedDescription
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    
}

