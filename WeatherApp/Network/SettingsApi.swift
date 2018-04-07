//
//  SettingsApi.swift
//  WeatherApp
//
//  Created by Korisnik on 07/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//
import RealmSwift
import RxSwift
import Foundation
class SettingsApi: RealmApi,SettingsApiProtocol{
    
    /**
     Method that returns @Settings from DB.
     - returns: Returns settings observable or empty if there is no settings.
     */
    func getSettingsObservable(observeOnScheduler:SchedulerType) -> Observable<Settings> {
        return  Observable.deferred { [unowned self]() -> Observable<Settings> in
            return self.runRealmOperation(realmOperation: { (realm) -> Observable<ThreadSafeReference<Settings>> in
                if  let settings =  realm.objects(Settings.self).first{
                    return Observable.just(ThreadSafeReference(to: settings))
                }else{
                    return Observable.empty()
                }
            }).flatMap({[unowned self] (threadSafeReference) -> Observable<Settings> in
                return self.mapThreadSafeObservable(threadSafeObservable: Observable.just(threadSafeReference), observeOnScheduler: observeOnScheduler)
            })
        }
    }
    /**
     Method for saving Settings on sync.
     */
    func saveSettings(settings: Settings) -> Bool {
        do{
            let realm = try Realm ()
            if let foundSettingsObject = realm.objects(Settings.self).first {
                realm.delete(foundSettingsObject)
            }
            realm.beginWrite()
            realm.add(settings)
            try realm.commitWrite()
            return true
            
        }catch let error {
            debugPrint(error)
            return false
        }
    }
    
    /**
     Method for saving new settings. This method will clear old selected city object in Realm DB.
     - parameter settings: settings object that will be saved in DB.
     */
    func saveSettingsObservable(settings: Settings) -> Observable<Bool> {
        return Observable.deferred({ [unowned self]() -> Observable<Bool> in
                return self.runRealmOperation(realmOperation: { (realm) -> Observable<Bool> in
                     realm.beginWrite()
                    if  let storedSettings =  realm.objects(Settings.self).first{
                        realm.delete(storedSettings)
                    }
                    realm.add(settings)
                    try realm.commitWrite()
                    return Observable.just(true)
                })
            })
    }
}

protocol SettingsApiProtocol {
    func getSettingsObservable(observeOnScheduler:SchedulerType) -> Observable<Settings>
    func saveSettingsObservable(settings:Settings) -> Observable<Bool>
    func saveSettings(settings:Settings) -> Bool
    
}
