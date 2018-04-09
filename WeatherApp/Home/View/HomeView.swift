//
//  HomeView.swift
//  WeatherApp
//
//  Created by Korisnik on 09/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import UIKit
class HomeView : UIView{
    //Mark: Views
    let cityLabel : UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.getExtraFont()
        label.textColor = R.Colors.transparentWhite
        return label
    }()
    let weatherImageView : UIImageView  = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    let dailyTemperatureLabel :UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.getHugeFont()
        label.textColor = R.Colors.white
        return label
    }()
    let lowTemperatureLabel :UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.getNormalFont()
        label.textColor = R.Colors.transparentWhite
        return label
    }()
    let highTemperatureLabel :UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Theme.getNormalFont()
        label.textColor = R.Colors.transparentWhite
        return label
    }()
    let summaryLabel :UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines=0
        label.font = Theme.getNormalFont()
        label.textColor = R.Colors.transparentWhite
        label.textAlignment = .center
        return label
    }()
    let settingsButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "settings_icon"), for: UIControlState.normal)
        return button
    }()
    let searchBar : UISearchBar = {
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
    
    let rainSubview : BottomWeatherView = {
        let bottomWeatherView = BottomWeatherView()
        bottomWeatherView.translatesAutoresizingMaskIntoConstraints = false
        bottomWeatherView.imageView.image = UIImage(named: "humidity_icon")
        return bottomWeatherView
    }()
    
    let windSubview : BottomWeatherView = {
        let bottomWeatherView = BottomWeatherView()
        bottomWeatherView.translatesAutoresizingMaskIntoConstraints = false
        bottomWeatherView.imageView.image = UIImage(named: "wind_icon")
        return bottomWeatherView
    }()
    
    let pressureSubview : BottomWeatherView = {
        let bottomWeatherView = BottomWeatherView()
        bottomWeatherView.translatesAutoresizingMaskIntoConstraints = false
        bottomWeatherView.imageView.image = UIImage(named: "pressure_icon")
        return bottomWeatherView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setup view
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setup view
        setupView()
    }
    
    private func setupView(){
        let view = self
        // view that containts top views. This is helper view for positioning views.
        let topSubview = UIView()
        topSubview.translatesAutoresizingMaskIntoConstraints = false
        topSubview.addSubview(cityLabel)
        topSubview.addSubview(searchBar)
        topSubview.addSubview(dailyTemperatureLabel)
        topSubview.addSubview(settingsButton)
        let bottomSubview = UIStackView(arrangedSubviews: [rainSubview,windSubview,pressureSubview])
        bottomSubview.translatesAutoresizingMaskIntoConstraints = false
        bottomSubview.distribution = .fillEqually
        
        view.addSubview(bottomSubview)
        view.addSubview(topSubview)
        view.addSubview(weatherImageView)
        view.addSubview(lowTemperatureLabel)
        view.addSubview(highTemperatureLabel)
        view.addSubview(summaryLabel)
        
        //setup constraints
        var constraints = [NSLayoutConstraint]()
        //todo is it always necessery to set height of views when using top & bottom anchor points?
        let searchBarXConstant = CGFloat(40)
        let settingsSize = CGFloat(40)
        let settingsYConstant  = CGFloat(dailyTemperatureLabel.font.xHeight/2)
        let settingsXConstant = abs(searchBarXConstant - settingsSize/2)
        constraints += [
            // position imageview to center of view. set imageview size to 1/4 of the screen
            weatherImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            weatherImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0),
            weatherImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25),
            //top subview setup
            topSubview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topSubview.bottomAnchor.constraint(equalTo: weatherImageView.topAnchor,constant: -10),
            topSubview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topSubview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            //city label constraints -> position top and center.
            cityLabel.topAnchor.constraint(equalTo: topSubview.topAnchor, constant: 0),
            cityLabel.centerXAnchor.constraint(equalTo: topSubview.centerXAnchor, constant: 0),
            //handle rotation dimension
            cityLabel.heightAnchor.constraint(lessThanOrEqualTo: topSubview.heightAnchor, multiplier: 0.3),
            //  cityLabel.heightAnchor.constraint(equalToConstant: Theme.extraFontSize),
            //position search bellow city label and set it's margins on both sides
            searchBar.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: topSubview.leadingAnchor, constant: searchBarXConstant),
            searchBar.trailingAnchor.constraint(equalTo: topSubview.trailingAnchor, constant: -searchBarXConstant),
            //handle rotation dimension
            searchBar.heightAnchor.constraint(lessThanOrEqualTo: topSubview.heightAnchor, multiplier: 0.2),
            //set current temp above image view
            dailyTemperatureLabel.bottomAnchor.constraint(equalTo: topSubview.bottomAnchor, constant: 0),
            dailyTemperatureLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            dailyTemperatureLabel.centerXAnchor.constraint(equalTo: topSubview.centerXAnchor, constant: 0),
            //handle rotation dimension
            dailyTemperatureLabel.heightAnchor.constraint(lessThanOrEqualTo: topSubview.heightAnchor, multiplier: 0.5),
        //settings button
        settingsButton.centerYAnchor.constraint(equalTo: dailyTemperatureLabel.centerYAnchor,constant : settingsYConstant),
        settingsButton.widthAnchor.constraint(equalToConstant: settingsSize),
        settingsButton.heightAnchor.constraint(equalToConstant: settingsSize),
        settingsButton.leadingAnchor.constraint(equalTo: topSubview.leadingAnchor, constant : settingsXConstant),
        //set low temperature
        lowTemperatureLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        lowTemperatureLabel.trailingAnchor.constraint(equalTo: weatherImageView.leadingAnchor, constant: -20),
        lowTemperatureLabel.centerYAnchor.constraint(equalTo: weatherImageView.centerYAnchor),
        //set high temperature
        highTemperatureLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 20),
        highTemperatureLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        highTemperatureLabel.centerYAnchor.constraint(equalTo: weatherImageView.centerYAnchor),
        //set cloud label
        summaryLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor,constant: 20),
        summaryLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 40),
        summaryLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
        summaryLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        //set bottom stackview
        bottomSubview.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 20),
        bottomSubview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        bottomSubview.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
        bottomSubview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
