//
//  DailyWeather.swift
//  WeatherApp
//
//  Created by Korisnik on 07/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
struct DailyWeatherResponse : Codable {
    let weatherList : [DailyWeather]
    
    enum CodingKeys: String, CodingKey {
        case weatherList = "data"
    }
    
}
