//
//  City.swift
//  WeatherApp
//
//  Created by Korisnik on 05/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//
import RealmSwift
import Foundation

class City :Object,Codable {

    @objc dynamic var lat:Double = 0
    @objc dynamic var lng:Double = 0
    @objc dynamic var name:String = .empty
    @objc dynamic var state:String = .empty

    override static func primaryKey() -> String {
        return "name"
    }
    
    enum CodingKeys: String, CodingKey {
        case state = "adminName1"
        case lat
        case lng
        case name = "placeName"
    }
    
}
