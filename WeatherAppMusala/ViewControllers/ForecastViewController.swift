//
//  ForecastViewController.swift
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


class ForecastViewController: UIViewController {
        
    @IBOutlet var tableView: UITableView!
    
    var cityId = String()
    var connectionError: Bool = false
    var fethedData: Bool = false
    
    var forecastList = [ForecastModel]()
    var weather = WeatherMoreData(sun_rise: "", sun_set: "", title: "")
    
        override func viewDidLoad() {
            super.viewDidLoad()
        
            self.tableView.dataSource = self
            self.tableView.delegate = self
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.fetchForecastForCity(cityId)

        }
    
        func fetchForecastForCity(_ woeid: String) {
    AF.request("https://www.metaweather.com/api/location/search/location/\(woeid)").responseJSON { response in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print(json)
                    self.forecastList = []
                    deleteForecast(woeid: self.cityId)
                    for i in 0...(json["consolidated_weather"].array?.count ?? 0)-1 {
                        let forecast = ForecastModel(weather_state_name: json["consolidated_weather"].array?[i]["weather_state_name"].stringValue ?? "", weather_state_abbr: json["consolidated_weather"].array?[i]["weather_state_abbr"].stringValue ?? "", applicable_date: json["consolidated_weather"].array?[i]["applicable_date"].stringValue ?? "", min_temp: json["consolidated_weather"].array?[i]["min_temp"].double ?? 0.00, max_temp: json["consolidated_weather"].array?[i]["max_temp"].double ?? 0.00, the_temp: json["consolidated_weather"].array?[i]["the_temp"].double ?? 0.00, humidity: json["consolidated_weather"].array?[i]["humidity"].int ?? 0, air_pressure: json["consolidated_weather"].array?[i]["air_pressure"].int ?? 0, predictability: json["consolidated_weather"].array?[i]["predictability"].int ?? 0,  visibility: json["consolidated_weather"].array?[i]["visibility"].double ?? 0.00, wind_speed: json["consolidated_weather"].array?[i]["wind_speed"].double ?? 0.00, wind_direction_compass: json["consolidated_weather"].array?[i]["wind_direction_compass"].stringValue ?? "")

                        saveForecastForCity(air_pressure: json["consolidated_weather"].array?[i]["air_pressure"].stringValue ?? "", applicable_date: json["consolidated_weather"].array?[i]["applicable_date"].stringValue ?? "", humidity: json["consolidated_weather"].array?[i]["humidity"].stringValue ?? "", max_temp: json["consolidated_weather"].array?[i]["max_temp"].float ?? 0.00, min_temp: json["consolidated_weather"].array?[i]["min_temp"].float ?? 0.00, predictability: json["consolidated_weather"].array?[i]["predictability"].stringValue ?? "", the_temp: json["consolidated_weather"].array?[i]["the_temp"].float ?? 0.00, visibility: json["consolidated_weather"].array?[i]["visibility"].stringValue ?? "", weather_state_abbr: json["consolidated_weather"].array?[i]["weather_state_abbr"].stringValue ?? "", weather_state_name: json["consolidated_weather"].array?[i]["weather_state_name"].stringValue ?? "", wind_direction: json["consolidated_weather"].array?[i]["wind_direction"].stringValue ?? "", wind_direction_compass: json["consolidated_weather"].array?[i]["wind_direction_compass"].stringValue ?? "", wind_speed: json["consolidated_weather"].array?[i]["wind_speed"].float ?? 0.00, woeid: self.cityId)
                        
                        self.forecastList.append(forecast)
                    }
                    
                    
                    self.weather = WeatherMoreData(sun_rise: String(json["sun_rise"].stringValue), sun_set: String(json["sun_set"].stringValue), title: String(json["title"].stringValue))
                    
                    self.tableView.reloadData()
                case .failure(_):
                    print("error")
                    print("you are in offline mode")
                    self.forecastList = []
                    let forecasta = readForecast(woeid: self.cityId) as! [Forecast]
                    
                    for day in forecasta {
                        let forecast = ForecastModel(weather_state_name: day.weather_state_name ?? "", weather_state_abbr: day.weather_state_abbr ?? "", applicable_date: day.applicable_date ?? "", min_temp: Double(day.min_temp), max_temp: Double(day.max_temp), the_temp: Double(day.the_temp), humidity: Int(day.humidity ?? "0") ?? 0, air_pressure: Int(day.air_pressure ?? "0") ?? 0, predictability: Int(day.predictability ?? "0") ?? 0, visibility: Double(day.visibility ?? "") ?? 0.00, wind_speed: Double(day.wind_speed), wind_direction_compass: day.wind_direction_compass ?? "")
                        
                        self.forecastList.append(forecast)
                    }
                    self.tableView.reloadData()
                }
            }
        }
            
            
        
            
}
    
// MARK: UITableViewDelegate

extension ForecastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let controller = self.storyboard?.instantiateViewController(identifier: "forecastDetailsViewController") as? ForecastDetailsViewController {
//            controller.cityId = (city.value(forKey: "woeid") as? String)!
            controller.selectedDayIndex = indexPath.row
            controller.sunSet = weather.sun_set
            controller.sunRise = weather.sun_rise
            controller.selectedDayName = weather.title
            controller.weatherDataList = forecastList
            self.navigationController?.pushViewController(controller, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: UITableViewDataSource

extension ForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastDayCell", for: indexPath) as! ForecastDayCell
        let foreCast = forecastList[indexPath.item]
        cell.dayForecastLabel.text = Helper.sharedManager.getDayOfWeek(today: foreCast.applicable_date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
