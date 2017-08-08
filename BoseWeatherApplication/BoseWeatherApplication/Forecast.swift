//
//  Forecast.swift
//  BoseWeatherApplication
//
//  Created by Rohit Natraj on 8/6/17.
//  Copyright © 2017 RohitNatraj. All rights reserved.
//

import UIKit

class Forecast: UITableViewController {
    
    //Instance Variables
    var forecast:[WeatherForecast]? = nil
    lazy var dateFormatter:DateFormatter = {
        return DateFormatter()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Operational
    func getDateFor(_ indexPath:IndexPath) -> String {
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: (self.forecast?[indexPath.row].date)!)
        
        self.dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date!)
    }
    
    //MARK - TableView Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell") as? ForecastCell
        let forecast = self.forecast?[indexPath.row]
        cell?.cityName.text = forecast?.cityName
        
        cell?.dayOfWeek.text = self.getDateFor(indexPath)
        
        if let minTemperatureInFarenheit = forecast?.minTemperatureInFarenheit {
            cell?.minimumTemp.text = String(format: "Min: " + "\(minTemperatureInFarenheit)" + "\u{00B0}" + " F")
        }
        if let maxTemperatureInFarenheit = forecast?.maxTemperatureInFarenheit {
                cell?.maximumTemp.text = String(format: "Max: " + "\(maxTemperatureInFarenheit)" + "\u{00B0}" + " F")
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.forecast?.count)!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

class ForecastCell:UITableViewCell {
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var maximumTemp: UILabel!
    @IBOutlet weak var minimumTemp: UILabel!
}
