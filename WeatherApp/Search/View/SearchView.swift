//
//  SearchView.swift
//  WeatherApp
//
//  Created by Korisnik on 10/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//
import SnapKit
import UIKit

class SearchView: UIView {
    var closeDelegate : CloseActionDelegate?
    //MARK: Views
    let closeButtonContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "clear_icon"), for: UIControlState.normal)
        return button
    }()
    
    let searchBar: UISearch = {
        let search = UISearch()
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //MARK: Private methods
    private func setupView(){
        closeButtonContainer.addSubview(closeButton)
        addSubview(closeButtonContainer)
        addSubview(searchBar)
        addSubview(tableView)
        //Trying out SnapKit.
        //setup constraints.
        //setup close button in leading top corner
        closeButtonContainer.snp.makeConstraints { [unowned self](make) in
            make.top.equalTo(searchBar.snp.top)
            make.bottom.equalTo(searchBar.snp.bottom)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            make.width.equalTo(37)
        }
        //close button
        closeButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(closeButtonContainer.snp.trailing).offset(10)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        //make searchbar on top.
        searchBar.snp.makeConstraints {[unowned self] (make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(closeButtonContainer.snp.trailing).offset(8)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
        }
        //set tableview bellow search bar. Set it to the end of view.
        tableView.snp.makeConstraints {[unowned self] (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
        }
    }
    
    //MARK: deinitialization
    deinit {
        closeDelegate = nil
    }
}
