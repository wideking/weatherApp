//
//  GeoCityResponse.swift
//  WeatherApp
//
//  Created by Korisnik on 10/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
struct GeoCityResponse: Codable {
    let cities : [City]
    
    enum CodingKeys : String,CodingKey {
        case cities = "postalCodes"
    }
}

