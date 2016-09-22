//
//  NetworkOperations.swift
//  PizzaMe
//
//  Created by RAVI RANDERIA on 7/15/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation

enum NetworkOperationError : Error {
    case ErrorJSON
    case GetRequestNotSuccessful
    case NotValidHTTPResponse
}

protocol NetworkOperationProtocol {
      func downloadJSONFromURL(completion : @escaping ([String: AnyObject]?,Error?) -> Void)
}

class NetworkOperation : NetworkOperationProtocol {
    private let session: URLSessionProtocol
    let queryURL : NSURL
    
    required init(url : NSURL,session: URLSessionProtocol = URLSession.shared) {
        self.session = session
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion : @escaping ([String: AnyObject]?,Error?) -> Void){
        let request: NSURLRequest = NSURLRequest(url: queryURL as URL)
        let dataTask = session.dataTaskWithRequest(url: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                switch(httpResponse.statusCode) {
                case 200:
                    do {
                        let jsonDictionary = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments)
                        completion(jsonDictionary as? [String : AnyObject],nil)
                    }catch {
                        print("error")
                        completion(nil,NetworkOperationError.ErrorJSON)
                    }
                default : print("GET request not successful. HTTP status code : \(httpResponse.statusCode)")
                completion(nil,NetworkOperationError.GetRequestNotSuccessful)
                }
            }else{
                print("Error : Not a valid HTTP Response")
                completion(nil,NetworkOperationError.NotValidHTTPResponse)
            }
        }
        dataTask.resume()
    }
    
}
