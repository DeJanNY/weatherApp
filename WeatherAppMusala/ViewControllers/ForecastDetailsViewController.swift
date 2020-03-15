//
//  ForecastDetailsViewController.swift
//  WeatherAppMusala
//
//  Created by Dejan Krstevski on 3/14/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import SDWebImage

class ForecastDetailsViewController: UIViewController {

    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var currentTemperatureLabel: UILabel!
    @IBOutlet var weatherStateLabel: UILabel!
    @IBOutlet var currentWeatherImageView: UIImageView!
    @IBOutlet var sunriseLabel: UILabel!
    @IBOutlet var sunsetLabel: UILabel!
    @IBOutlet var minTemperatureLabel: UILabel!
    @IBOutlet var maxTemperatureLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    @IBOutlet var visibilityLabel: UILabel!
    @IBOutlet var airPressureLabel: UILabel!
    @IBOutlet var predictibilityLabel: UILabel!
    
    
    var weatherDataList: Array<ForecastModel> = []
    var sunRise: String = ""
    var sunSet: String = ""
    var selectedDayIndex: Int = 0
    var selectedDayName: String = ""
    let milesToKm = Double(1.60934)
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setupUIDetails()
        }
        
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
    }
    
    
    func setupUIDetails() {
        let currentDay = weatherDataList[selectedDayIndex]
        self.title = "\(String(Helper.sharedManager.getDayOfWeek(today: currentDay.applicable_date) ?? ""))"
        dayLabel.text = selectedDayName
        currentTemperatureLabel.text = String("\(Int(currentDay.the_temp))°")
        let URLString = "https://www.metaweather.com/static/img/weather/png/64/\(currentDay.weather_state_abbr).png"
        
        currentWeatherImageView.sd_setImage(with: URL(string: URLString), placeholderImage: UIImage(named: "placeholder"))
        weatherStateLabel.text = currentDay.weather_state_name
                
        if sunRise.count > 0 {
            sunriseLabel.text = Helper.sharedManager.getHourDateTimeFormatter(date: sunRise)
        } else {
          sunriseLabel.text = "OFFLINE"
        }
        
        if sunSet.count > 0 {
            sunsetLabel.text = Helper.sharedManager.getHourDateTimeFormatter(date: sunSet)
        } else {
          sunsetLabel.text = "OFFLINE"
        }
        
        minTemperatureLabel.text  = String("Min \(Int(currentDay.min_temp))°")
        maxTemperatureLabel.text =  String("Max \(Int(currentDay.max_temp))°")
        windLabel.text = String(format: "\(currentDay.wind_direction_compass) %.1f km/hr", currentDay.wind_speed*milesToKm)
        humidityLabel.text = String("\(Int(currentDay.humidity)) %")
        visibilityLabel.text = String(format: "%.1f km", currentDay.visibility)
        airPressureLabel.text = String("\(Int(currentDay.air_pressure)) mbar")
        predictibilityLabel.text = String("\(currentDay.predictability) %")
    }
    
}

