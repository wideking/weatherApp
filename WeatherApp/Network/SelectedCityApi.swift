//
//  SelectedCityApi.swift
//  WeatherApp
//
//  Created by Korisnik on 05/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
class SelectedCityApi: RealmApi,SelectedCityApiProtocol{
    
    /**
     Method that retrives selected city from Realm DB.
     - returns: Observable that contains Selected city object.
     If object is not is not found it will return empty().
     If there is something wrong with Realm it will return Observable.error()
     */
    func getSelectedCityObservable(observeOnScheduler:SchedulerType) -> Observable<SelectedCity> {
        return  Observable.deferred { [unowned self]() -> Observable<SelectedCity> in
            return self.runRealmOperation(realmOperation: { (realm) -> Observable<ThreadSafeReference<SelectedCity>> in
                if  let selectedCity =  realm.objects(SelectedCity.self).first{
                    return Observable.just(ThreadSafeReference(to: selectedCity))
                }else{
                    return Observable.empty()
                }
            }).flatMap({[unowned self] (threadSafeReference) -> Observable<SelectedCity> in
                return self.mapThreadSafeObservable(threadSafeObservable: Observable.just(threadSafeReference), observeOnScheduler: observeOnScheduler)
            })
        }
    }
    /**
     Method for saving new selected city. This method will clear old selected city object in Realm DB.
     - parameter selectedCity: selectedCity object that will be saved in DB.
     */
    func saveSelectedCityObservable(selectedCity:SelectedCity) ->Observable<Bool> {
        return Observable.deferred({ [unowned self]() -> Observable<Bool> in
            return self.runRealmOperation(realmOperation: { (realm) -> Observable<Bool> in
                    realm.beginWrite()
                if  let selectedCity =  realm.objects(SelectedCity.self).first{
                    realm.delete(selectedCity)
                    return Observable.just(true)
                }
                realm.add(selectedCity)
                try realm.commitWrite()
                return Observable.just(true)
            })
        })
    }
}


protocol SelectedCityApiProtocol {
    func getSelectedCityObservable(observeOnScheduler:SchedulerType) -> Observable<SelectedCity>
    func saveSelectedCityObservable(selectedCity:SelectedCity) ->Observable<Bool>
}
