//
//  ViewController.swift
//  WeatherApp
//
//  Created by Korisnik on 04/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//
import RxSwift
import RxCocoa
import UIKit

class ViewController: UIViewController, LoaderProtocol {
    //Mark: Properties
    private var disposableBag = DisposeBag()
    let homeViewModel :HomeViewModelProtocol = HomeViewModel(selectedCityApi: SelectedCityApi(), weatherApi: WeatherApi())
    //Views
    var loader: UILoaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initialize data observers
        initializeLoaderDriver()
        initializeLocationDriver()
        //initialize data retrival
        homeViewModel.getData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private functions
    //MARK: Data drivers
    private func initializeLoaderDriver(){
        homeViewModel.dataLoading
            .asDriver(onErrorJustReturn: (loadingStarted: false, loadingFinished: false))
            .do(onNext: { (loaderStatus) in
                if(loaderStatus.loadingStarted && !loaderStatus.loadingFinished){ //loader is requested.
                    self.showLoaderView()
                }else{
                    self.hideLoaderView()
                }
            })
            .drive()
            .disposed(by: disposableBag)
    }
    
    private func initializeLocationDriver(){
        homeViewModel.location
            //as driver automatically handles UI thread change and it handles error events.
            .asDriver { (error) -> SharedSequence<DriverSharingStrategy, SelectedCity> in
                return SharedSequence.empty()
            }
            .do(onNext: {[unowned self] (selectedCity) in
                
            })
            .drive()
            .disposed(by: disposableBag)
    }
    
    private func initializeWeatherDriver(){
        homeViewModel.weather
            //as driver automatically handles UI thread change and it handles error events.
            .asDriver { (error) -> SharedSequence<DriverSharingStrategy, Weather> in
                return SharedSequence.empty()
            }
            .do(onNext: {[unowned self] (weather) in
                
            })
            .drive()
            .disposed(by: disposableBag)
    }
    
    
}

