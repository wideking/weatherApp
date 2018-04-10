//
//  HomeViewModel.swift
//  Weather App
//
//  Created by Korisnik on 04/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//
import Foundation
import RxSwift

typealias LoaderStatus = (loadingStarted:Bool,loadingFinished:Bool)
class HomeViewModel : HomeViewModelProtocol {
    private var disposeBag:DisposeBag = DisposeBag()
    //MARK: Properties
    private let weatherApi : WeatherApiProtocol
    private let selectedCityApi : SelectedCityApiProtocol
    private let settingsApi : SettingsApiProtocol
    //Observable properties
    var homeData: ReplaySubject<Home>
    var dataLoading: ReplaySubject<LoaderStatus>
    
    //MARK: Initializers
    init(selectedCityApi:SelectedCityApiProtocol,weatherApi:WeatherApiProtocol,settingsApi:SettingsApi) {
        self.settingsApi = settingsApi
        self.selectedCityApi = selectedCityApi
        self.weatherApi = weatherApi
        self.homeData = ReplaySubject.create(bufferSize: 1)
        self.dataLoading = ReplaySubject.create(bufferSize: 1)
    }
    
    //Mark: Data methods
    /**
     Method that gets data for screen.
     Method controls data loading param, it changes it values when request is made and when request is received.
     Method first reads location from the DB.
     If it's found request for the Weather data will be made. On success method will set location and weather param to the received values.
     If SelectedCity does not exist it will throw error event. On error method will set location and weather param to the nil.
     */
    func getData() {
        dataLoading.onNext((loadingStarted: true, loadingFinished: false))
        //hardcoded city
        let hardcodedCity = SelectedCity()
        hardcodedCity.name = "Osijek"
        hardcodedCity.lat = 45.5511111
        hardcodedCity.lng = 18.6938889
        let observeOnScheduler = MainScheduler.instance
        
        selectedCityApi.getSelectedCityObservable(observeOnScheduler: observeOnScheduler)
            //.ifEmpty(switchTo: Observable.error(AppErrors.CityNotSelected))
            .ifEmpty(default: hardcodedCity)
            .flatMap {
                [unowned self] (selectedCity) -> Observable<(Home)> in
                return Observable<Home>.zip(Observable.just(selectedCity),self.weatherApi.getWeatherObservable(latitude: selectedCity.lat, longitute: selectedCity.lng), self.settingsApi.getSettingsObservable(observeOnScheduler: observeOnScheduler), resultSelector: { (city:SelectedCity, weather:WeatherResponse,settings:Settings) -> Home in
                    let dailyWeather = weather.dailyWeatherResponse.weatherList[0]
                    return Home(dailyTemperature: UnitsHelper.getTemperatureString(temperatureValue: weather.currentWeather.apparentTemperature, unitSystem: settings.unit),
                                lowTemp: UnitsHelper.getTemperatureString(temperatureValue: dailyWeather.temperatureLow, unitSystem: settings.unit),
                                highTemp: UnitsHelper.getTemperatureString(temperatureValue: dailyWeather.temperatureHigh, unitSystem: settings.unit),
                                summary:  dailyWeather.summary,
                                rainPercentage: .percentage(data: dailyWeather.precipProbability),
                                windSpeed: UnitsHelper.getWindString(windSpeedValue: dailyWeather.windSpeed, unitSystem: settings.unit) ,
                                pressure: "\(dailyWeather.pressure) hPa",
                                city: selectedCity.name,
                                weatherImage: WeatherImage(rawValue: weather.currentWeather.icon)!)
    
                })
 
                   /* return Home(dailyTemperature: .empty,
                                lowTemp: .empty,
                                highTemp: .empty,
                                cloudStatus: .empty,
                                rainPercentage: .empty,
                                windSpeed: .empty,
                                pressure: .empty,
                        city: selectedCity.name,
                        weatherImage: .empty)

                     })
  */
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(observeOnScheduler)
            .subscribe(onNext: {[unowned self] (home) in
                self.dataLoading.onNext((loadingStarted: false, loadingFinished: true))
                self.homeData.onNext(home)
                },onError: {[unowned self] (error) in
                    //todo pogledati postoji li bolji način za ovo.
                     self.dataLoading.onNext((loadingStarted: false, loadingFinished: true))
                    if(error.localizedDescription == AppErrors.CityNotSelected.localizedDescription){
                        debugPrint("error: "+error.localizedDescription+" Location is not selected, setting it to nil!")
                    }else{
                        //later add error handling.
                        debugPrint(error)
                    }
                    
            }).disposed(by: disposeBag)
    }
}

protocol HomeViewModelProtocol {
    var homeData : ReplaySubject<Home>{get}
    var dataLoading : ReplaySubject<LoaderStatus>{get}
    func getData()
}
