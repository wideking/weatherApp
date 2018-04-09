//
//  WeatherApi.swift
//  Weather App
//
//  Created by Korisnik on 04/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
final class WeatherApi:WeatherApiProtocol{
    /**
     Method for making API call to weather server.
     - parameter latitude lat: Locations latitude
     - parameter longitute lng: Locations longitude
     - returns: Observable Weather response
     */
    func getWeatherObservable(latitude lat:Double, longitute lng:Double) -> Observable<WeatherResponse> {
        let params : Parameters=[
            "units":"si"
        ]
        return  RestManager.requestObservable(url: Configuration.weatherServer.url+String(lat)+","+String(lng), params: params, method: .get, headers: nil)
    }
}

protocol WeatherApiProtocol {
    func getWeatherObservable(latitude lat:Double, longitute lng:Double) -> Observable<WeatherResponse>
}

