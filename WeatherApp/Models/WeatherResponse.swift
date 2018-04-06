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
    let weather : Weather
    
    enum CodingKeys: String, CodingKey {
        case weather = "currently"
        //keys are same as in response
        case latitude
        case longitude
    }
}
