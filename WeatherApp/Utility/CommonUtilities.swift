//
//  CommonUtilities.swift
//  WeatherApp
//
//  Created by Mithun on 09/04/20.
//  Copyright © 2020 Mithun. All rights reserved.
//

import UIKit

class CommonUtilities: NSObject {

   class func getTimeFromTimeZone(timeZone: Int)-> String?{
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol   = "AM"
        dateFormatter.pmSymbol   = "PM"
        let timeZone             = TimeZone(secondsFromGMT: timeZone)
        dateFormatter.timeZone   = timeZone
        let time                 = dateFormatter.string(from: Date())
        return time
    }
    class func getCelsiusValueFrom(kelvin: Double)-> String{
        let celsius = round(kelvin - 273.15)
        
        return "\(celsius)º"
    }
    class func getSunTimings(time: Int)->String{
        let (h,m)                = (time / 3600, (time % 3600) / 60)
        let timeString           = "\(h):\(m)"
        let dateFormatter        = DateFormatter()
        guard let date           = dateFormatter.date(from: timeString) else { return "0"}
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol   = "AM"
        dateFormatter.pmSymbol   = "PM"
        let sunTime              = dateFormatter.string(from: date)
        return sunTime
    }
}
extension UITextField{
     func getText()->String{
        let str = self.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        return str?.replacingOccurrences(of: " ", with: "%20") ?? ""
    }
    
}
extension String{
    func getText()->String{
        let str = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return str.replacingOccurrences(of: " ", with: "%20") 
    }
}
