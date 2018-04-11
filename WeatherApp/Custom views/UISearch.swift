//
//  SearchView.swift
//  WeatherApp
//
//  Created by Korisnik on 10/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import UIKit

class UISearch: UISearchBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView(){
        translatesAutoresizingMaskIntoConstraints = false
        //solution for setting font in search bar.  -> solution from stack: https://stackoverflow.com/questions/26441958/changing-search-bar-placeholder-text-font-in-swift/43185700
        setImage(UIImage(named: "search_icon"), for: .search, state: .normal)
        placeholder = NSLocalizedString("type_something", comment: .empty)
        UISearch.clearBackgroundColor(searchBar: self as UISearchBar)
        
        clipsToBounds = true
        layer.cornerRadius = 25
        backgroundColor = UIColor.white
        layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        if  let textFieldInsideUISearchBar = value(forKey: "searchField") as? UITextField {
            let placeholderLabel = textFieldInsideUISearchBar.value(forKey: "placeholderLabel") as? UILabel
            placeholderLabel?.font  = Theme.getNormalFont()
            textFieldInsideUISearchBar.font = Theme.getNormalFont()
        }
    }
    
    private static func clearBackgroundColor(searchBar: UISearchBar) {
        guard let UISearchBarBackground: AnyClass = NSClassFromString("UISearchBarBackground") else { return }
        
        for view in searchBar.subviews {
            for subview in view.subviews {
                if subview.isKind(of: UISearchBarBackground) {
                    subview.alpha = 0
                }
            }
        }
    }
}
