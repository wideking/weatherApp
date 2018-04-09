//
//  TemperatureHelper.swift
//  WeatherApp
//
//  Created by Korisnik on 07/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
class UnitsHelper {
    /**
     Method that transforms server values in celsius to user unit values. Method will add aproperiate unit extension.
     */
    static func getTemperatureString(temperatureValue:Float, unitSystem:Settings.Units) ->String {
        let transformedTemperature :Float
        let unit : String
        switch unitSystem{
        case .imperial:  // transform temp to fahrenheit
            transformedTemperature = temperatureValue * 1.8 + 32
            unit = UnitExtension.fahrenheit.rawValue
        default:
            transformedTemperature = temperatureValue
            unit = UnitExtension.celsius.rawValue
        }
        return "\(transformedTemperature) \(unit)"
    }
    
    /**
     Method that transforms server values in m/S to user unit values. Method will add aproperiate unit extension.
     */
    static func getWindString(windSpeedValue:Float, unitSystem:Settings.Units) ->String {
        let transformedWindSpeed :Float
        let unit : String
        switch unitSystem{
        case .imperial:  // transform m/s to mph
            transformedWindSpeed = windSpeedValue * 2.23694
            unit = UnitExtension.mph.rawValue
        default:
            transformedWindSpeed = windSpeedValue * 3.6
            unit = UnitExtension.kmh.rawValue
        }
        return "\(transformedWindSpeed) \(unit)"
    }
    
    private  enum UnitExtension : String {
        case celsius = "°C"
        case fahrenheit = "°F"
        case mph = "mph"
        case kmh = "km/h"
    }
}
