//
//  File.swift
//  WeatherApp
//
//  Created by Korisnik on 07/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import UIKit

protocol LoaderProtocol {
    //Loader protocol view
    var loader : UILoaderView? { get set}
}

extension LoaderProtocol where Self : HomeViewController {
    //Mark Loader methods
     func showLoaderView(){
        if(loader == nil){
            //todo is this a proper way of positioning? (full screen and center content? Should I make changes to the custom view?
            let loader = UILoaderView()
            loader.label.text = NSLocalizedString("loading_weather", comment: .empty)
            self.view.addSubview(loader)
            loader.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([loader.topAnchor.constraint(equalTo: self.view.topAnchor),
                                         loader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                         loader.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                         loader.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])
            self.loader = loader
        }
    }
    
     func hideLoaderView(){
        if let loader = loader {
            loader.removeFromSuperview()
            self.loader = nil
        }
    }
}

