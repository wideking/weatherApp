//
//  UserSettings.swift
//  WeatherApp
//
//  Created by Korisnik on 07/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//
import RealmSwift
import Foundation
class Settings : Object,Codable {
    @objc dynamic var unit:Units = Units.metric
    
    enum CodingKeys: String, CodingKey {
        case unit
    }
    
    @objc enum Units :Int,Codable {
        case metric
        case imperial
    }
    
    
}
extension Settings {
    static let defaultSettings : Settings = Settings()
}
