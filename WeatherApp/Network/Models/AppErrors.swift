//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Korisnik on 04/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
public enum AppErrors : Error{
    case CityNotSelected
}

enum NetworkError:Error{
    case UrlError(URLError)
    case UnknownError(Error)
    case SerializationFailed
    case DatabaseReadFailed
    case ParseFailed
    case Empty
}
