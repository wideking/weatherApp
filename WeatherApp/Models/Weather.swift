//
//  Weather.swift
//  Weather App
//
//  Created by Korisnik on 04/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
import RealmSwift

class Weather :Codable {
    @objc dynamic var time : Int64 = 0
    @objc dynamic var summary : String = .empty
    @objc dynamic var icon : String = .empty
    @objc dynamic var precipIntensity : Float = 0
    @objc dynamic var precipProbability : Float = 0
    @objc dynamic var temperature : Float = 0
    @objc dynamic var apparentTemperature : Float = 0
    @objc dynamic var windSpeed : Float = 0
    @objc dynamic var pressure : Float = 0
    @objc dynamic var cloudCover :Float = 0
}
