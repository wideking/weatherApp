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
class SearchViewController : UIViewController, CloseActionDelegate,UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate {
    
    //MARK: Properties
    weak var resultDelegate : SearchResultDelegate? = nil
    let disposeBag = DisposeBag()
    var searchViewModel: SearchViewModelProtocol = SearchViewModel(cityApi: CityApi(), selectedCityApi: SelectedCityApi())
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
        tableView.estimatedRowHeight = 50
        //setup drivers
        setupLoaderDriver()
        setupDataSetDriver()
        setupSearchSaveDriver()
        //setup dismiss action
        let gestureRecognizer  = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        submitSearchQuery(query: searchBar.text)
        searchBar.resignFirstResponder()
    }
    
    
    func onCloseClicked(){
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.tableData.count
    }
    //setup table view content
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        //find reusable cell
        guard let cell = (tableView.dequeueReusableCell(withIdentifier: SearchResultViewCell.identifier, for: indexPath) as? SearchResultViewCell) else {
            return UITableViewCell()
        }
        
        let searchResult = searchViewModel.tableData[indexPath.row]
        let color = searchResult.prefixColor.value()
        cell.titleLabel.text = searchResult.title
        cell.firstCharacterLabel.text = searchResult.prefix
        cell.firstCharacterLabel.backgroundColor = color
        cell.separator.backgroundColor = color
        return cell
    }
    //Handle table view selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult = searchViewModel.tableData[indexPath.row]
        searchViewModel.saveCity(city: searchResult.city)
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
    private func setupSearchSaveDriver(){
        searchViewModel.selectedCity.asDriver { (error) -> SharedSequence<DriverSharingStrategy, SelectedCity> in
            return SharedSequence.empty()
            }.do(onNext: {[unowned self](selectedCity) in
                self.resultDelegate?.searchCompleted()
            }).drive()
        .disposed(by: disposeBag)
    }
    @objc private func dismissKeyboard(){
        if(searchBar.isFirstResponder){
            debugPrint("Dismissing keyboard")
            searchBar.endEditing(true)
        }
    }
}
