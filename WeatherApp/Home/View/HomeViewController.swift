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
    private let cityLabel : UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.getExtraFont()
        label.textColor = R.Colors.transparentWhite
        return label
    }()
    
    private let searchBar : UISearchBar = {
        let searchBar = UISearchBar ()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        //todo set needed style a
        
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
    
    private func setupView(){
        view.backgroundColor = R.Colors.green
        view.addSubview(cityLabel)
        view.addSubview(searchBar)
        //setup constraints
        var constraints = [NSLayoutConstraint]()
        //city label constraints -> position top and center.
        constraints += [cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                        cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                        //position search bellow city label and set it's margins on both sides
            searchBar.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func initializeLocationDriver(){
        homeViewModel.location
            //as driver automatically handles UI thread change and it handles error events.
            .asDriver { (error) -> SharedSequence<DriverSharingStrategy, SelectedCity> in
                return SharedSequence.empty()
            }
            .do(onNext: {[unowned self] (selectedCity) in
                self.cityLabel.text = selectedCity.name
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

