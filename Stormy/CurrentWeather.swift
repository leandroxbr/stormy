//
//  CurrentWeather.swift
//  Stormy
//
//  Created by Leandro Alves De Souza on 09/11/14.
//  Copyright (c) 2014 Leandro Alves De Souza. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather {

    var currentTime: String?
    var temperature: Int?
    var humidity: Double
    var precipProbability: Double
    var summary: String
    var icon: UIImage?
    
    init(weatherDictionary:NSDictionary){
        let currentWeather = weatherDictionary["currently"] as NSDictionary

        humidity = currentWeather["humidity"] as Double
        precipProbability = currentWeather["precipProbability"] as Double
        summary = currentWeather["summary"] as String
        let temperatureFahrenheight = currentWeather["temperature"] as Double
        temperature = getCelciusDegrees(fahrenheight:temperatureFahrenheight)

        let iconString = currentWeather["icon"] as String
        icon = weatherIconFromString(stringIcon:iconString)

        let currentTimeIntValue = currentWeather["time"] as Int
        currentTime = dateStringFromUnixTime(unixTime:currentTimeIntValue)
    }
    
    func dateStringFromUnixTime(#unixTime: Int) -> String {
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970:timeInSeconds)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(weatherDate)
    }
    
    func getCelciusDegrees(#fahrenheight:Double) -> Int {
        let celciusInDouble = ((fahrenheight - 32) / (18/10))
        return Int(ceil(celciusInDouble))
    }
    
    func weatherIconFromString(#stringIcon:String) -> UIImage {
        var imageName: String

        switch stringIcon {
        case "clear-day":
            imageName = "clear-day"
        case "clear-night":
            imageName = "clear-night"
        case "rain":
            imageName = "rain"
        case "snow":
            imageName = "snow"
        case "sleet":
            imageName = "sleed"
        case "wind":
            imageName = "wind"
        case "fog":
            imageName = "fog"
        case "cloudy":
            imageName = "cloudy"
        case "partly-cloudy-day":
            imageName = "partly-cloudy"
        case "partly-cloudy-night":
            imageName = "cloudy-night"
        default:
            imageName = "default"
        }
        
        var iconImage = UIImage(named: imageName)
        return iconImage!
    }
}