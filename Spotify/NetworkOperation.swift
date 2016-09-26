//
//  NetworkOperations.swift
//  PizzaMe
//
//  Created by RAVI RANDERIA on 7/15/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation


enum Result<T> {
    case Success(T)
    case Failure(Error)
}

enum NetworkOperationError : Error {
    case ErrorJSON
    case GetRequestNotSuccessful
    case NotValidHTTPResponse
}

protocol NetworkOperationProtocol {
    func downloadJSONFromURL(completion : @escaping (Result<[String:AnyObject]>) -> Void)
}

class NetworkOperation : NetworkOperationProtocol {
    private let session = URLSession.shared
    let queryURL : URL
    var dataTask : URLSessionDataTask?
    
    required init(url : URL) {
        
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion : @escaping (Result<[String:AnyObject]>) -> Void){
        let request: URLRequest = URLRequest(url: queryURL)
     
        dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                switch(httpResponse.statusCode) {
                case 200:
                    do {
                        let jsonDictionary = try JSONSerialization.jsonObject(with: data! as Data, options: [])
                        completion(Result.Success(jsonDictionary as! [String : AnyObject]))
                    }catch {
                        print("error")
                        completion(.Failure(NetworkOperationError.ErrorJSON))
                    }
                default : print("GET request not successful. HTTP status code : \(httpResponse.statusCode)")
                completion(Result.Failure(NetworkOperationError.GetRequestNotSuccessful))
                }
            }else{
                print("Error : Not a valid HTTP Response")
                completion(Result.Failure(NetworkOperationError.NotValidHTTPResponse))
            }
        }
        dataTask?.resume()
    }
}
