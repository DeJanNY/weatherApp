//
//  MemoryManager.swift
//  WeatherAppMusala
//
//  Created by Dejan Krstevski on 3/13/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import CoreData

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    func saveCity(name: String, woeid: String) {
    //        Step 1: Get the general agent and the managed object manager

    let managedObectContext = appDelegate.persistentContainer.viewContext
    //        Step 2: Create one entity
    let entity = NSEntityDescription.entity(forEntityName: "City", in: managedObectContext)
    let city = NSManagedObject(entity: entity!, insertInto: managedObectContext)
    
    //        Step 3: Save the value in the text box to person
    city.setValue(name, forKey: "name")
    city.setValue(woeid, forKey: "woeid")
    
    //        Step 4: Save the entity to the managed object. If the save fails, proceed
    do {
        try managedObectContext.save()
    } catch  {
        fatalError("Can't save")
    }
}

func saveForecastForCity(air_pressure:String, applicable_date: String, humidity: String, max_temp: Float, min_temp: Float, predictability: String, the_temp: Float, visibility: String, weather_state_abbr: String, weather_state_name: String, wind_direction: String, wind_direction_compass: String, wind_speed: Float, woeid: String) {
    //        Step 1: Get the general agent and the managed object manager

    let managedObectContext = appDelegate.persistentContainer.viewContext
    //        Step 2: Create one entity
    let entity = NSEntityDescription.entity(forEntityName: "Forecast", in: managedObectContext)
    let forecast = NSManagedObject(entity: entity!, insertInto: managedObectContext)
    
    //        Step 3: Save the value in the text box to person
//    city.setValue(name, forKey: "name")
//    city.setValue(woeid, forKey: "woeid")
    
    forecast.setValue(air_pressure, forKey: "air_pressure")
    forecast.setValue(applicable_date, forKey: "applicable_date")
    forecast.setValue(humidity, forKey: "humidity")
    forecast.setValue(woeid, forKey: "woeid")
    forecast.setValue(max_temp, forKey: "max_temp")
    forecast.setValue(min_temp, forKey: "min_temp")
    forecast.setValue(predictability, forKey: "predictability")
    forecast.setValue(the_temp, forKey: "the_temp")
    forecast.setValue(visibility, forKey: "visibility")
    forecast.setValue(weather_state_abbr, forKey: "weather_state_abbr")
    forecast.setValue(weather_state_name, forKey: "weather_state_name")
    forecast.setValue(wind_direction, forKey: "wind_direction")
    forecast.setValue(wind_direction_compass, forKey: "wind_direction_compass")
    forecast.setValue(wind_speed, forKey: "wind_speed")
        
    //        Step 4: Save the entity to the managed object. If the save fails, proceed
    do {
        try managedObectContext.save()
    } catch  {
        fatalError("Can't save")
    }
}

func deleteForecast(woeid: String){
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Forecast")
    fetchRequest.predicate = NSPredicate(format: "woeid = %@", woeid)
   
    do
    {
        let toDelete = try managedContext.fetch(fetchRequest)
        
        for forecast in toDelete {
            let objectToDelete = forecast as! NSManagedObject
            managedContext.delete(objectToDelete)
        }
        
//        let objectToDelete = test[0] as! NSManagedObject
//        managedContext.delete(objectToDelete)
        
        do{
            try managedContext.save()
        }
        catch
        {
            print(error)
        }
    }
    catch
    {
        print(error)
    }
}

func readForecast(woeid: String) -> [Any] {
        //      Step 1: Get the general agent and the managed object manager
                 let managedObectContext = appDelegate.persistentContainer.viewContext
                 
         //        Step 2: Establish a Get Request
                 let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Forecast")
                 fetchRequest.predicate = NSPredicate(format: "woeid = %@", woeid)
    
    
         //        Step three: execute the request
                 do {
                     let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [Forecast]
                     if let results = fetchedResults {
                         return results
                     }
                     
                 } catch  {
                     print("can't load")
                 }
         return []
    }


 func readCities() -> [Any]{
    
    //      Step 1: Get the general agent and the managed object manager
            let managedObectContext = appDelegate.persistentContainer.viewContext
            
    //        Step 2: Establish a Get Request
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
            
    //        Step three: execute the request
            do {
                let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
                if let results = fetchedResults {
                    return results
                }
                
            } catch  {
                print("can't load")
            }
    return []
}

func checkIfItemExist(id: String, name: String) -> Bool {

    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "City")
    fetchRequest.fetchLimit =  1
    fetchRequest.predicate = NSPredicate(format: "woeid == %@" ,id)
    fetchRequest.predicate = NSPredicate(format: "name == %@" ,name)

    do {
        let count = try managedContext.count(for: fetchRequest)
        if count > 0 {
            return true
        }else {
            return false
        }
    }catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
        return false
    }
}
