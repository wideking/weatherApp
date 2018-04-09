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
    let homeViewModel :HomeViewModelProtocol = HomeViewModel(selectedCityApi: SelectedCityApi(), weatherApi: WeatherApi(),settingsApi: SettingsApi())
    //Views
    var loader: UILoaderView?
    unowned var homeView : HomeView {
        return self.view as! HomeView
    }
    unowned var cityLabel : UILabel {
        return homeView.cityLabel
    }
    unowned var dailyTemperatureLabel : UILabel {
        return homeView.dailyTemperatureLabel
    }
    unowned var lowTemperatureLabel : UILabel {
        return homeView.lowTemperatureLabel
    }
    
    unowned var highTemperatureLabel : UILabel {
        return homeView.highTemperatureLabel
    }
    
    unowned var summaryLabel : UILabel {
        return homeView.summaryLabel
    }
    unowned var rainLabel : UILabel {
        return homeView.rainSubview.title
    }
    unowned var windLabel : UILabel {
        return homeView.windSubview.title
    }
    unowned var pressureLabel : UILabel {
        return homeView.pressureSubview.title
    }
    unowned var weatherImageView : UIImageView {
        return homeView.weatherImageView
    }
    
   //set view to HomeView
    override func loadView() {
        self.view = HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        //initialize data observers
        initializeLoaderDriver()
        initializeHomeDriver()
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

    
    private func initializeHomeDriver(){
        homeViewModel.homeData
            //as driver automatically handles UI thread change and it handles error events.
            .asDriver { (error) -> SharedSequence<DriverSharingStrategy, Home> in
                return SharedSequence.empty()
            }
            .do(onNext: {[unowned self] (home) in
                let weatherImage = home.weatherImage.values()
                self.homeView.backgroundColor = weatherImage.color
                self.weatherImageView.image = weatherImage.weatherImage
                self.cityLabel.text = home.city
                self.dailyTemperatureLabel.text = home.dailyTemperature
                self.lowTemperatureLabel.text = String(format: NSLocalizedString("low_temperature", comment: .empty),home.lowTemp).uppercased()
                self.highTemperatureLabel.text = String(format: NSLocalizedString("high_temperature", comment: .empty),home.highTemp).uppercased()
                self.summaryLabel.text = home.summary
                self.rainLabel.text = home.rainPercentage
                self.windLabel.text = home.windSpeed
                self.pressureLabel.text = home.pressure
            })
            .drive()
            .disposed(by: disposableBag)
    }
    
    
}

