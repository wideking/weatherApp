//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Korisnik on 04/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
enum NetworkError:Error{
    case urlError(URLError)
    case unknownError(Error)
    case empty
}
