//
//  RealmApi.swift
//  WeatherApp
//
//  Created by Korisnik on 05/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
class RealmApi {
    /**
     Method that handles openingof Realm default instance.
     - parameter realmOperation : Closure that specifies what realm should do. Inside this closure you should set your realm operations.
     - parameter realm: Realm DB reference.
 */
    func runRealmOperation<T>( realmOperation : (_ realm:Realm)->Observable<T>) ->Observable<T> {
        do{
            let realm = try Realm() //open default realm
            return realmOperation(realm)
            
        }catch let exception{
            debugPrint(exception)
            return Observable.error(exception)
        }
    }
}
