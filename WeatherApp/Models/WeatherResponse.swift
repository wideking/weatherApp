//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Korisnik on 04/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
struct WeatherResponse : Codable {
    let latitude : Double
    let longitude: Double
    let dailyWeatherResponse : DailyWeatherResponse
    let currentWeather : CurrentWeather
    
    enum CodingKeys: String, CodingKey {
        case dailyWeatherResponse = "daily"
        case currentWeather = "currently"
        //keys are same as in response
        case latitude
        case longitude
    }
    
    
}
