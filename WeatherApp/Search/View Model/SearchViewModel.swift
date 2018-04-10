//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Korisnik on 09/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
import RxSwift
typealias Search = (query:String, results :[City])
class SearchViewModel: SearchViewModelProtocol {
    
    //MARK: Properties
    private let cityApi: CityApiProtocol
    private let disposeBag = DisposeBag()
    //Observable properties
    var searchData: ReplaySubject<Search>
    var dataLoading: ReplaySubject<LoaderStatus>
    //Initializer
    /**
     - parameter cityApi: City Api manager. Server manager that handles search request on the server.
     */
    init(cityApi: CityApiProtocol) {
        self.cityApi = cityApi
        searchData = ReplaySubject.create(bufferSize: 1)
        dataLoading = ReplaySubject.create(bufferSize: 1)
    }
    
    /**
     Method that returns cities based on @query param. Method is requesting server api and it delivers results in @searchData subject.
     - parameter query: String parameter that is passed down to server for the search.
     */
    func search(query: String) {
        let disposable = cityApi.getCitiesByNameObservable(name: query)
            .subscribe(onNext: { [unowned self](citiesResult) in
                self.searchData.onNext((query: query, results: citiesResult))
                }, onError: { [unowned self](error) in
                    self.dataLoading.onNext((loadingStarted: false, loadingFinished: true))
                    //todo handle error notification.
            })
        disposeBag.insert(disposable)
    }
}

protocol SearchViewModelProtocol {
    var searchData : ReplaySubject<Search>{get}
    var dataLoading : ReplaySubject<LoaderStatus>{get}
    func search(query:String)
}
