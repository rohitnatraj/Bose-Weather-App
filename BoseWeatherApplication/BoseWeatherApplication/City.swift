//
//  City.swift
//  BoseWeatherApplication
//
//  Created by Rohit Natraj on 8/5/17.
//  Copyright © 2017 RohitNatraj. All rights reserved.
//

import UIKit

protocol CitySelectionDelegate: class {
    func userSelected(_ city:CityCoordinates)
}

class City: UITableViewController, UISearchBarDelegate, CityDelegate {
    
    //Instance Variables
    weak var citySelectionDelegate : CitySelectionDelegate?
    var isSearching:Bool = false
    let model = CityModel()
    var cityCoordinates = [CityCoordinates]()
    var cityCoordinate = CityCoordinates()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    //Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.model.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.citySelectionDelegate?.userSelected(self.cityCoordinate)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell")
        if (isSearching) {
            if let cityName = self.cityCoordinates[indexPath.row].cityName {
                cell?.textLabel?.text = cityName
            }
        }
        return cell!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSearching) {
            return self.cityCoordinates.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        self.cityCoordinate = self.cityCoordinates[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    //MARK: - Search Methods
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.cleanUpResults()
        if searchText.characters.count >= 3 {
            isSearching = true
        } else if searchText == "" || searchText.characters.count < 3 {
            isSearching = false
        }
        
        if (isSearching) {
            self.manageActivityIndicator(true)
            self.model.detailsFor(searchText)
        } else {
            self.manageActivityIndicator(false)
        }
    }
    
    func cleanUpResults() {
        self.cityCoordinates.removeAll()
        self.tableView.reloadData()
    }
    
    //MARK: - Manage Activity Indicator
    func manageActivityIndicator(_ start:Bool) {
        if (self.activityIndicator.isAnimating && !start) {
            self.activityIndicator.stopAnimating()
        } else if (!self.activityIndicator.isAnimating && start) {
            self.activityIndicator.center = CGPoint(x: tableView.frame.size.width / 2, y: tableView.frame.size.height / 2)
            self.tableView.backgroundView = activityIndicator
            self.activityIndicator.startAnimating()
        }
    }
    
    //MARK: - CityModel Methods
    
    func cityDataReceived(_ data: [CityCoordinates]) {
        self.manageActivityIndicator(false)
        self.cityCoordinates = data
        self.tableView.reloadData()
    }
    
    func cityDataReceivedWithError(_ error: Error?) {
        self.manageActivityIndicator(false)
        let alert = UIAlertController()
        alert.title = "Error"
        alert.message = error?.localizedDescription
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}