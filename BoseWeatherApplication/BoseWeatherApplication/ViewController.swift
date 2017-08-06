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
    @IBOutlet weak var minimumTemperature: UILabel!
    @IBOutlet weak var maximumTemperature: UILabel!
    
    
    //Instance Variable
    let currentWeatherModel = CurrentWeatherModel()
    let city = City()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.city.citySelectionDelegate = self
        self.currentWeatherModel.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userSelected(_ city: CityCoordinates) {
        self.currentWeatherModel.getCurrentWeatherFor(city)
    }
    
    func currentWeatherDataReceived(_ data: CurrentWeather) {
        self.cityName.text = data.cityName
        self.weatherDescription.text = data.weatherDescription
        self.currentTemperature.text = String(describing:data.currentTemperature)
        self.minimumTemperature.text = String(describing:data.minimumTemperature)
        self.maximumTemperature.text = String(describing:data.maximumTemperature)
    }
    
    func currentWeatherDataReceivedWithError(_ error: Error?) {
        //
    }
    
}

