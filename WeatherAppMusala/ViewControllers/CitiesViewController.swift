//
//  CitiesViewController.swift
//  WeatherAppMusala
//
//  Created by Dejan Krstevski on 3/13/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import CoreData

class CitiesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var cities = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cities = readCities() as! [NSManagedObject]
        if cities.count == 0 {
            let cities : [String: String] = [ "839722": "Sofia" , "2459115" :"NY" ,"1118370": "Tokyo" ]
            for (key,value) in cities {
                saveCity(name: value, woeid: key)
            }
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
                
        cities = readCities() as! [NSManagedObject]
        tableView.reloadData()
        
    }
    
    @IBAction func actionPlus(_ sender: Any) {
        if let controller = self.storyboard?.instantiateViewController(identifier: "citySearcherViewController") as? CitySearcherViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: UITableViewDelegate

extension CitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let city = self.cities[indexPath.item]
        if let controller = self.storyboard?.instantiateViewController(identifier: "forecastViewController") as? ForecastViewController {
            controller.cityId = (city.value(forKey: "woeid") as? String)!
            self.navigationController?.pushViewController(controller, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
}



// MARK: UITableViewDataSource

extension CitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityCell
        var cit = City()
        cit = self.cities[indexPath.item] as! City
        cell.cityLabel.text = cit.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
