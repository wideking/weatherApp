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
   weak var closeDelegate : CloseActionDelegate?
    //MARK: Views
    let topConstainer : UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.semiOpaqueWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let backgroundView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.transparentWhite
        return view
    }()
    let closeButtonContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor.white
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    let closeButton: UICloseButton = {
       let closeButton = UICloseButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.tintColor = R.Colors.green
        return closeButton
    }()
    
    let searchBar: UISearch = {
        let search = UISearch()
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.keyboardDismissMode = .onDrag
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
        //setup actions
        closeButton.addTarget(self, action: #selector(closeClicked(sender:)), for: .touchUpInside)
        
        tableView.backgroundColor = backgroundView.backgroundColor
        closeButtonContainer.addSubview(closeButton)
        topConstainer.addSubview(closeButtonContainer)
        topConstainer.addSubview(searchBar)
        addSubview(backgroundView)
        addSubview(topConstainer)
        addSubview(tableView)
    
        //Trying out SnapKit.
        //setup constraints.
        //setup top constainer
        topConstainer.snp.makeConstraints{[unowned self] (make) in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(self.safeAreaLayoutGuide.snp.height).multipliedBy(0.15)
        }
        //setup close button in leading top corner
        closeButtonContainer.snp.makeConstraints { [unowned self](make) in
            make.top.equalTo(searchBar.snp.top)
            make.bottom.equalTo(searchBar.snp.bottom)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            make.width.equalTo(40)
        }
        //close button
        closeButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(closeButtonContainer.snp.trailing).offset(-8)
            make.centerY.equalTo(closeButtonContainer.snp.centerY)
            let buttonsizeConstraint = closeButtonContainer.snp.height
            let sizeFactor = 0.5
            
            make.width.equalTo(buttonsizeConstraint).multipliedBy(sizeFactor)
            make.height.equalTo(buttonsizeConstraint).multipliedBy(sizeFactor)
            
        }
        //make searchbar on top.
        searchBar.snp.makeConstraints {[unowned self] (make) in
            make.centerY.equalTo(topConstainer.safeAreaLayoutGuide.snp.centerY)
            make.leading.equalTo(closeButtonContainer.snp.trailing).offset(8)
            make.trailing.equalTo(self.topConstainer.snp.trailing).offset(-30)
            make.height.equalTo(topConstainer.snp.height).multipliedBy(0.4)
        }
        //set tableview bellow search bar. Set it to the end of view.
        tableView.snp.makeConstraints {[unowned self] (make) in
            make.top.equalTo(topConstainer.snp.bottom)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
        }
        backgroundView.snp.makeConstraints {[unowned self] (make) in
            make.edges.equalTo(self.snp.edges)
        }
    }
    //MARK: Actions
    @objc func closeClicked(sender: UIButton){
        closeDelegate?.onCloseClicked()
    }
    
    //MARK: deinitialization
    deinit {
        closeDelegate = nil
    }
}
