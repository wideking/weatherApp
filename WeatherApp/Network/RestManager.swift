//
//  RestManager.swift
//  Weather App
//
//  Created by Korisnik on 04/04/2018.
//  Copyright © 2018 Korisnik. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class RestManager {
    private init(){
    }
    /**
     Wrapper around Alamofire.SessionManager. This field is initialized with default settings.
     */
    private static let manager :Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            Configuration.weatherServer.url: .performDefaultEvaluation(validateHost: true)
        ]
        var configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest=45
        configuration.timeoutIntervalForResource=45
        
        return Alamofire.SessionManager(configuration: .default, serverTrustPolicyManager:ServerTrustPolicyManager(policies: serverTrustPolicies) )
    }()
    
    //MARK: Request methods
    /**
     Method for requesting data from the server
     - parameter url: URL to the server endpoint. Url should include both hostname, path and path queries.
     - parameter params : Request parameters as dictionary
     - parameter method: type of HttpMethod request.
     - parameter headers: specific request headers
     - parameter using completition :Closure that will be used for returning the data.
     - returns: Returns DataRequest object to enable cancelation of requests.
     */
    static func request<T:Codable> (url:String,params: Parameters?,method:HTTPMethod,headers: HTTPHeaders?,using completion: @escaping ((Result<T>) ->Void))->DataRequest?{
        
        let dataRequest : DataRequest = RestManager.manager.request(url, method: method, parameters: params, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseData( completionHandler:{ (response) in
                switch response.result {
                case .success(let value):
                    if let decodedObject :T = RestManager.parseData(jsonData: value){
                        completion(.success(decodedObject))
                    }else{
                        completion(.failure(NetworkError.ParseFailed))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        return dataRequest
    }
    /**
     Method that wraps AlamoFire network request to Observable. This method handles error propagation.
     - parameter url: URL to the server endpoint. Url should include both hostname, path and path queries.
     - parameter params : Request parameters as dictionary
     - parameter method: type of HttpMethod request.
     - parameter headers: specific request headers
     */
    static func requestObservable<T:Codable> (url:String,params: Parameters?,method:HTTPMethod,headers: HTTPHeaders?)->Observable<T>{
        return Observable<T>.create{ (emitter) -> Disposable in
            let request = RestManager.request(url: url,params: params, method: method, headers: headers, using: { (result:Result<T>) in
                do{
                    if(result.isSuccess){
                        if let value = result.value{
                            emitter.onNext(value)
                            emitter.onCompleted()
                        }else{
                            throw NetworkError.Empty
                        }
                    }else{
                        throw result.error!
                    }
                }catch let error {
                    emitter.onError(error)
                }
            })
            return Disposables.create(with: {
                
                request?.cancel()
            })
        }
    }
    
    //MARK: Private method
    /**
     Method for parsing downloaded data to the object. This can be refactored to the extension along with Alamo decodable.
     */
    private static func  parseData<T:Codable>(jsonData:Data)  -> T? {
        let dataObject :T?
        do{
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dataDecodingStrategy = .deferredToData
            dataObject = try jsonDecoder.decode(T.self, from: jsonData)
            debugPrint("Object succesfully parsed : \(dataObject!)")
        }catch let error {
            
            debugPrint("Error while parsing data from server. Received dataClassType: \(T.self). More info: \(error.localizedDescription)")
            dataObject=nil
        }
        return dataObject
    }
}
