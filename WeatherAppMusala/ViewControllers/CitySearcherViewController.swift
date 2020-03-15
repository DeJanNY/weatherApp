//
//  CitySearcherViewController.swift
//  WeatherAppMusala
//
//  Created by Dejan Krstevski on 3/14/20.
//  Copyright © 2020 developer. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class CitySearcherViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    var citiesList = [citiDetails]()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
           searchBar.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        }
    
}


// MARK: UISearchBarDelegate

extension CitySearcherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        let removeSpaces = text.replacingOccurrences(of: " ", with: "+")
    AF.request("https://www.metaweather.com/api/location/search/?query=\(String(removeSpaces))").responseJSON { response in
            switch response.result {
            case .success(let value):
                    
                let json = JSON(value)
                print(json)
                self.citiesList = []
                for i in 0...(json.array?.count ?? 0)-1 {
                    var city = citiDetails(cityName: json.array?[i]["title"].stringValue ?? "", cityID: json.array?[i]["woeid"].stringValue ?? "")
                self.citiesList.append(city)
                }
                self.tableView.reloadData()
            case .failure(_):
                print("error")
                    }
                }
    }
}


// MARK: UITableViewDelegate

extension CitySearcherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let city = self.citiesList[indexPath.item]
        //if city already do not add it to the list
        if !checkIfItemExist(id:city.cityID, name:city.cityName) {
            saveCity(name: city.cityName, woeid: city.cityID)
        }
        navigationController?.popViewController(animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



// MARK: UITableViewDataSource

extension CitySearcherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.citiesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityListCell", for: indexPath) as! CityListCell
        let cit = self.citiesList[indexPath.item]
        cell.cityListLabel.text = cit.cityName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
