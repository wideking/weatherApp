//
//  Home.swift
//  WeatherApp
//
//  Created by Korisnik on 07/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import UIKit
/**
 Data model for @HomeViewController screen. Data in this model is converted to user's selected units.
 */
public struct Home {
    let dailyTemperature : String 
    let lowTemp : String
    let highTemp : String
    let summary : String
    let rainPercentage : String
    let windSpeed : String
    let pressure : String
    let city : String
    let weatherImage : WeatherImage
}
enum  WeatherImage:String{
    case clearDay = "clear-day"
    case clearNight = "clear-ight"
    case cloudy = "cloudy"
    case fog = "fog"
    case hail = "hail"
    case partiallyCloudyDay = "partly-cloudy-day"
    case partiallyCloudyNight  = "partly-cloudy-night"
    case rain = "rain"
    case sleet = "sleet"
    case snow = "snow"
    case thunderstorm = "thunderstorm"
    case wind = "wind"
    
    func values () -> (weatherImage:UIImage, color: UIColor){
        switch self {
        case .clearDay:
            return (weatherImage: #imageLiteral(resourceName: "clear_day") ,color: UIColor.blue)
        case .clearNight :
            return (weatherImage: #imageLiteral(resourceName: "clear_night"), color: UIColor.lightGray)
        case .cloudy :
            return (weatherImage: #imageLiteral(resourceName: "cloudy"),color: UIColor.gray)
        case .fog :
            return (weatherImage: #imageLiteral(resourceName: "fog"),color :UIColor.darkGray)
        case .hail :
            return (weatherImage: #imageLiteral(resourceName: "hail"), color : UIColor.red)
        case .partiallyCloudyDay:
            return (weatherImage: #imageLiteral(resourceName: "partially_cloudy_day"),color:UIColor.lightGray)
        case .partiallyCloudyNight:
            return (weatherImage: #imageLiteral(resourceName: "partially_cloudy_night"),color:UIColor.darkGray)
        case .rain:
            return (weatherImage: #imageLiteral(resourceName: "rain"),color:R.Colors.oceanBlue)
        case .sleet:
            return (weatherImage: #imageLiteral(resourceName: "sleet"),color:UIColor.orange)
        case .snow:
            return (weatherImage: #imageLiteral(resourceName: "snow"),color:UIColor.brown)
        case .thunderstorm:
            return (weatherImage: #imageLiteral(resourceName: "thunderstorm"),color:UIColor.red)
        default: //wind
            return (weatherImage: #imageLiteral(resourceName: "wind"),color:R.Colors.periwinkle)
        }
    }
}
