//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Mithun on 09/04/20.
//  Copyright © 2020 Mithun. All rights reserved.
//

import UIKit

class WeatherModel: NSObject {
  
    
    var cityName: String?
    var visibility: Int?
    var timeZone: Int?
    var sunrisetime: Int?
    var sunSetTime: Int?
    var windSpeed: Double?
    var temp_max: Double?
    var temp_min: Double?
    var feels_like: Double?
    var pressure: Double?
    var humidity: Double?
    var temp: Double?
    
    
    
    func initWith(dict:[String: Any]?){
        self.cityName        = dict?["name"] as? String
        self.visibility      = dict?["visibility"] as? Int
        self.timeZone        = dict?["timezone"] as? Int
        if let windDict = dict?["wind"] as? [String: Any]{
            self.windSpeed   = windDict["speed"] as? Double
        }
        if let main     = dict?["main"] as? [String: Any]{
            self.feels_like  = main["feels_like"] as? Double
            self.temp_max    = main["temp_max"] as? Double
            self.temp_min    = main["temp_min"] as? Double
            self.humidity    = main["humidity"] as? Double
            self.pressure    = main["pressure"] as? Double
            self.temp        = main["temp"] as? Double
        }
        if let sunTimes = dict?["sys"] as? [String: Any]{
            self.sunSetTime  = sunTimes["sunset"] as? Int
            self.sunrisetime = sunTimes["sunrise"] as? Int
        }
        
    }
    
}
