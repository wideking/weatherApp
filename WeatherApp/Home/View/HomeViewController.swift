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
    private let cityLabel : UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.getExtraFont()
        label.textColor = R.Colors.transparentWhite
        return label
    }()
    private let weatherImageView : UIImageView  = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    private let dailyTemperatureLabel :UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.getHugeFont()
        label.textColor = R.Colors.white
        return label
    }()
    private let lowTemperatureLabel :UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.getNormalFont()
        label.textColor = R.Colors.transparentWhite
        return label
    }()
    private let highTemperatureLabel :UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.getNormalFont()
        label.textColor = R.Colors.transparentWhite
        return label
    }()
    private let cloudsLabel :UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.getNormalFont()
        label.textColor = R.Colors.transparentWhite
        return label
    }()
    
    private let searchBar : UISearchBar = {
        let searchBar = UISearchBar ()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        //todo set needed style
        
        //solution for setting font in search bar.  -> solution from stack: https://stackoverflow.com/questions/26441958/changing-search-bar-placeholder-text-font-in-swift/43185700
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        let placeholderLabel       = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
        placeholderLabel?.font     = Theme.getNormalFont()
        textFieldInsideUISearchBar?.font = Theme.getNormalFont()
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup view
        setupView()
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
    
    private func setupView(){
        view.backgroundColor = R.Colors.green
        view.addSubview(cityLabel)
        view.addSubview(searchBar)
        view.addSubview(weatherImageView)
        view.addSubview(dailyTemperatureLabel)
        view.addSubview(lowTemperatureLabel)
        view.addSubview(highTemperatureLabel)
        view.addSubview(cloudsLabel)
        
        //setup constraints
        var constraints = [NSLayoutConstraint]()
        //city label constraints -> position top and center.
        constraints += [cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                        cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                        //position search bellow city label and set it's margins on both sides
            searchBar.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60),
            // position imageview to center of view. set imageview size to 1/4 of the screen
            weatherImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            weatherImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            weatherImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            //set current temp above image view
            dailyTemperatureLabel.bottomAnchor.constraint(equalTo: weatherImageView.topAnchor, constant: 40),
            dailyTemperatureLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 80),
            dailyTemperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            //set low temperature
            lowTemperatureLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            lowTemperatureLabel.trailingAnchor.constraint(equalTo: weatherImageView.leadingAnchor),
            lowTemperatureLabel.centerYAnchor.constraint(equalTo: weatherImageView.centerYAnchor),
            //see if we need to center low temp between constraints.
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func initializeHomeDriver(){
        homeViewModel.homeData
            //as driver automatically handles UI thread change and it handles error events.
            .asDriver { (error) -> SharedSequence<DriverSharingStrategy, Home> in
                return SharedSequence.empty()
            }
            .do(onNext: {[unowned self] (home) in
                self.cityLabel.text = home.city
                self.dailyTemperatureLabel.text = home.dailyTemperature
                self.lowTemperatureLabel.text = home.lowTemp
                self.highTemperatureLabel.text = home.highTemp
                self.cloudsLabel.text = home.cloudStatus
            })
            .drive()
            .disposed(by: disposableBag)
    }
    
    
}

