//
//  Models.swift
//  WeatherAppMusala
//
//  Created by Dejan Krstevski on 3/14/20.
//  Copyright © 2020 developer. All rights reserved.
//

import Foundation


struct citiDetails {
    let cityName: String
    let cityID: String
}

struct WeatherMoreData {
    var sun_rise: String
    var sun_set: String
    var title: String
}

struct ForecastModel: Codable, Equatable {
    static func == (lhs: ForecastModel, rhs: ForecastModel) -> Bool {
        if( (lhs.weather_state_name == rhs.weather_state_name) &&
            (lhs.weather_state_abbr == rhs.weather_state_abbr) &&
            (lhs.applicable_date == rhs.applicable_date) &&
            (lhs.min_temp == rhs.min_temp) &&
            (lhs.max_temp == rhs.max_temp) &&
            (lhs.the_temp == rhs.the_temp) &&
            (lhs.air_pressure == rhs.air_pressure) &&
            (lhs.humidity == rhs.humidity) &&
            (lhs.predictability == rhs.predictability) &&
            (lhs.visibility == rhs.visibility) &&
            (lhs.wind_speed == rhs.wind_speed) &&
            (lhs.wind_direction_compass == rhs.wind_direction_compass)
        ) {
            return true
        }
        return false
    }
    
    let weather_state_name: String
    let weather_state_abbr: String
    let applicable_date: String
    let min_temp: Double
    let max_temp: Double
    let the_temp: Double
    let humidity: Int
    let air_pressure: Int
    let predictability: Int
    let visibility: Double
    let wind_speed: Double
    let wind_direction_compass: String
}
