//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Korisnik on 09/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
typealias Search = (query:String, results :[City])
class SearchViewModel: SearchViewModelProtocol {
    //MARK: Properties
    private let cityApi: CityApiProtocol
    private let disposeBag = DisposeBag()
    
    //Observable properties
    var searchQueryObservable : PublishSubject<String>
    var tableData : [SearchResult] {
        didSet { //push data set change event when this variable is edited
            dataSetChanged.onNext(true)
        }
    }
    var dataSetChanged : ReplaySubject<Bool>
    var dataLoading: ReplaySubject<LoaderStatus>
    //Initializer
    /**
     - parameter cityApi: City Api manager. Server manager that handles search request on the server.
     */
    init(cityApi: CityApiProtocol) {
        self.cityApi = cityApi
        self.searchQueryObservable = PublishSubject()
        tableData = []
        dataSetChanged = ReplaySubject.create(bufferSize: 1)
        dataLoading = ReplaySubject.create(bufferSize: 1)
        initializeSearchDisposable()
    }
    
    /**
     Method for getting search results from the web. Method observers changes in the @searchQueryObservable and if result is something new it will make request for new data.
     */
    func initializeSearchDisposable() {
        searchQueryObservable.distinctUntilChanged().flatMap { [unowned self](query) -> Observable<GeoCityResponse> in
            self.dataLoading.onNext((loadingStarted: true, loadingFinished: false))
            return  self.cityApi.getCitiesByNameObservable(name: query)
            }.asDriver(onErrorRecover: { (error) -> SharedSequence<DriverSharingStrategy, GeoCityResponse> in
                debugPrint("Search screen: error occured while loading data. More info : \(error)")
                return SharedSequence.empty()
            })
            .map({ (cityResponse) -> [SearchResult] in
                return cityResponse.cities.map({ (city) -> SearchResult in
                    let prefix = String(city.name.prefix(1)).uppercased()
                    var prefixColor = PrefixColor(rawValue: prefix)
                    if(prefixColor == nil ){
                        prefixColor = PrefixColor(rawValue: "A")!
                    }
                    return SearchResult(prefix: prefix,title: city.name + ","+city.state, prefixColor:prefixColor!)
                })
            })
            .do(onNext: { [unowned self](seachResults) in
                self.dataLoading.onNext((loadingStarted: false, loadingFinished: true))
                self.tableData = seachResults
            }).drive()
            .disposed(by: disposeBag)
    }
}

protocol SearchViewModelProtocol {
    /**
     Property that observers search queries. Use onNext method to set new data as new search param. This will trigger network call for searching cities.
     */
    var searchQueryObservable : PublishSubject<String> {get}
    var tableData : [SearchResult] {get}
    var dataSetChanged : ReplaySubject<Bool>{get}
    var dataLoading : ReplaySubject<LoaderStatus>{get}
}
