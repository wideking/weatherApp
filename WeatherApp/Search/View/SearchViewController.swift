//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Korisnik on 09/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import UIKit
class SearchViewController : UIViewController {
    //MARK: Properties
    //MARK: Views
    unowned var searchView : SearchView  {
        return self.view as! SearchView
    }
    
    override func loadView() {
        view = SearchView()
    }
    
    override func viewDidLoad() {
        
    }
    
}
