//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Korisnik on 09/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class SearchViewController : UIViewController, CloseActionDelegate,UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    let disposeBag = DisposeBag()
    let searchViewModel: SearchViewModelProtocol = SearchViewModel(cityApi: CityApi())
    //MARK: Views
    unowned var searchView: SearchView  {
        return self.view as! SearchView
    }
    unowned var searchBar: UISearch {
        return searchView.searchBar
    }
    unowned var tableView: UITableView{
        return searchView.tableView
    }
    
    override func loadView() {
        view = SearchView()
    }
    
    override func viewDidLoad() {
        //setup delegates
        searchView.closeDelegate = self
        searchBar.delegate = self
        searchBar.becomeFirstResponder() //set view to selected state
        tableView.delegate = self
        tableView.dataSource = self
        let nib =  UINib.init(nibName: "SearchResultViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SearchResultViewCell.identifier)
        tableView.estimatedRowHeight = 47
        //setup drivers
        setupLoaderDriver()
        setupDataSetDriver()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        submitSearchQuery(query: searchBar.text)
    }
    
    
    func onCloseClicked(){
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        //find reusable cell
        guard let cell = (tableView.dequeueReusableCell(withIdentifier: SearchResultViewCell.identifier, for: indexPath) as? SearchResultViewCell) else {
            return UITableViewCell()
        }
        
        let searchResult = searchViewModel.tableData[indexPath.row]
        cell.titleLabel.text = searchResult.title
        cell.firstCharacterLabel.text = searchResult.prefix
        cell.firstCharacterLabel.backgroundColor = searchResult.prefixColor.value()
        
        return cell
    }
    
    //MARK: Private methods
    /**
     Method for submiting user input to the view model.
     */
    private func submitSearchQuery(query: String?){
        if let query = query {
            searchViewModel.searchQueryObservable.onNext(query)
        }
    }
    
    private func setupLoaderDriver(){
        searchViewModel.dataLoading
            .asDriver { (error) -> SharedSequence<DriverSharingStrategy, (loadingStarted: Bool, loadingFinished: Bool)> in
                return SharedSequence.just( (loadingStarted: false, loadingFinished: false))
            }.do(onNext: { [unowned self] (loaderStatus) in
                if(loaderStatus.loadingStarted && !loaderStatus.loadingFinished){
                    //loader is requested.
                    //todo show loader
                }else{
                    //todo hide loader
                }
            }).drive()
            .disposed(by: disposeBag)
    }
    
    private func setupDataSetDriver(){
        searchViewModel.dataSetChanged.asDriver { (error) -> SharedSequence<DriverSharingStrategy, Bool> in
            return SharedSequence.empty()
            }.do(onNext: { [unowned self](_) in
                self.tableView.reloadData()
            }).drive()
            .disposed(by: disposeBag)
    }
}
