//
//  Configuration.swift
//  WeatherApp
//
//  Created by Korisnik on 04/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
struct Configuration {
    typealias ServerData = (url:String, apiKey:String)
    static let weatherServer : ServerData = {
        let weatherDictionary = Bundle.main.infoDictionary!["Weather endpoint"] as! Dictionary<String,String>
        return ServerData(url:weatherDictionary["url"]!,apiKey:weatherDictionary["api_key"]!)
    }()
}
