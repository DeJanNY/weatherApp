//
//  Helper.swift
//  WeatherAppMusala
//
//  Created by Dejan Krstevski on 3/14/20.
//  Copyright © 2020 developer. All rights reserved.
//

import Foundation


class Helper: NSObject {

    static let sharedManager = Helper()

    func getHourDateTimeFormatter(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        guard let myDate = formatter.date(from: date) else {return "error"}
        formatter.timeStyle = .short
        let myHour = formatter.string(from: myDate)
        return myHour
    }
    
    func getDayOfWeek(today:String) -> String? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let currentDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: currentDate)
        var weekDayName: String = ""
        switch weekDay {
        case 1:
            weekDayName = "Sunday"
        case 2:
            weekDayName = "Monday"
        case 3:
            weekDayName = "Tuesday"
        case 4:
            weekDayName = "Wednesday"
        case 5:
            weekDayName = "Thursday"
        case 6:
            weekDayName = "Friday"
        case 7:
            weekDayName = "Saturday"
        default:
            weekDayName = "No such day"
        }
        return weekDayName
    }

}
