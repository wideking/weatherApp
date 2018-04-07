//
//  Home.swift
//  WeatherApp
//
//  Created by Korisnik on 07/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
/**
 Data model for @HomeViewController screen. Data in this model is converted to user's selected units.
 */
public struct Home {
    let dailyTemperature : String 
    let lowTemp : String
    let highTemp : String
    let cloudStatus : String
    let rainPercentage : String
    let windSpeed : String
    let pressure : String
    let city : String
    let weatherImage : String
}
