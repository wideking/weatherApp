//
//  AppConstants.swift
//  WeatherApp
//
//  Created by Korisnik on 05/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
let FIRST_LAUNCH = "first_launch"
extension String{
    static let empty : String = ""
    static func percentage<T>(data :T) -> String{
        return "\(data)\u{25}"
    }
}

