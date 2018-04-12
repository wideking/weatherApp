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
    private let selectedCityApi: SelectedCityApiProtocol
    private let disposeBag = DisposeBag()
    
    //Observable properties
    var searchQueryObservable : PublishSubject<String>
    var tableData : [SearchResult] {
        didSet { //push data set change event when this variable is edited
            dataSetChanged.onNext(true)
        }
    }
    var selectedCity: ReplaySubject<SelectedCity>
    var dataSetChanged : ReplaySubject<Bool>
    var dataLoading: ReplaySubject<LoaderStatus>
    //Initializer
    /**
     - parameter cityApi: City Api manager. Server manager that handles search request on the server.
     */
    init(cityApi: CityApiProtocol,selectedCityApi: SelectedCityApiProtocol) {
        self.cityApi = cityApi
        self.selectedCityApi = selectedCityApi
        self.searchQueryObservable = PublishSubject()
        tableData = []
        dataSetChanged = ReplaySubject.create(bufferSize: 1)
        dataLoading = ReplaySubject.create(bufferSize: 1)
        selectedCity = ReplaySubject.create(bufferSize: 1)
        initializeSearchDisposable()
    }
    /**
     Method for saving selected city.
     - returns: Returns Observable that will parse City object into Selected city and save it to the realm db.
     */
    func saveCity(city:City) {
        Observable.deferred({ [unowned self] () -> Observable<SelectedCity> in
            let selectedCity = SelectedCity()
            selectedCity.lat = city.lat
            selectedCity.lng = city.lng
            selectedCity.state = city.state
            selectedCity.name = city.name
            return Observable.zip(Observable.just(selectedCity), self.selectedCityApi.saveSelectedCityObservable(selectedCity: selectedCity), resultSelector: { (selectedCity, _) -> SelectedCity in
                return selectedCity
            })
        })
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self](selectedCity) in
                self.dataLoading.onNext((loadingStarted: false, loadingFinished: false))
                self.selectedCity.onNext(selectedCity)
                }, onError: { [unowned self](error) in
                    debugPrint("error on saving data. More info \(error)")
                    self.dataLoading.onNext((loadingStarted: false, loadingFinished: false))
                    //todo handle error message.
            })
            .disposed(by: disposeBag)
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
                    let title = city.name + ","+city.state
                    let prefixColor : PrefixColor
                    
                    if let color  = PrefixColor(rawValue: prefix){
                        prefixColor = color
                    }else{
                        prefixColor = PrefixColor(rawValue: "A")!
                    }
                    return SearchResult(prefix: prefix,title: title, prefixColor: prefixColor,city: city)
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
    var selectedCity : ReplaySubject<SelectedCity> {get}
    func saveCity(city:City)
}
