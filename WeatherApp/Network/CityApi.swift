//
//  CityApi.swift
//  WeatherApp
//
//  Created by Korisnik on 05/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class CityApi: CityApiProtocol {
    func getCitiesByNameObservable(name: String) -> Observable<GeoCityResponse> {
        let params : Parameters = [
            "placename":name,
            "username":Configuration.geolocationServer.apiKey
        ]
        return RestManager.requestObservable(url: Configuration.geolocationServer.url, params: params, method: .get, headers: nil)
    }
}

protocol CityApiProtocol{
    func getCitiesByNameObservable(name:String) ->Observable<GeoCityResponse>
}
