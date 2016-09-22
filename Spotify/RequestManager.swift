//
//  RequestManager.swift
//  Spotify
//
//  Created by RAVI RANDERIA on 9/22/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation

protocol SpotifyServiceProtocol {
    func getArtists(completion: @escaping ([Artist]?, Error?) -> (Void))
}

enum SpotifyServiceError : Error {
    case CouldNotConstructValidURL
    case CouldNotParseDataProperly
    case YahooServiceCouldNotBeGenerated
}


struct RequestManager : SpotifyServiceProtocol {
    
    private let networkOperation : NetworkOperationProtocol
    
    init (networkHelper : NetworkOperation) {
        self.networkOperation = networkHelper
    }
    
    func getArtists(completion: @escaping ([Artist]?, Error?) -> (Void)) {
        self.networkOperation.downloadJSONFromURL(completion: { (JSONDictionary,error) in
            
            if let jsonDictionary = JSONDictionary {
                self.convertToArtistModelAndReturnArray(jsonDictionary: jsonDictionary, completion: { (artistModelArray, error) in
                    if error == nil {
                        completion(artistModelArray,nil)
                    }
                    else{
                        completion(nil,error)
                    }
                })
            }
            else{
                
                completion(nil,error)
            }
        })
    }
    
    func convertToArtistModelAndReturnArray(jsonDictionary : [String : AnyObject],completion : ([Artist]?,Error?)->()){
        var artistArray = [Artist]()
        if let artists = jsonDictionary["artists"] as? [String:AnyObject] {
            if let items = artists["items"] as? [[String: AnyObject]] {
                for artist in items {
                    artistArray.append(Artist(artistDictionary: artist))
                }
                completion(artistArray,nil)
            }
            else{
                completion(nil,SpotifyServiceError.CouldNotParseDataProperly)
            }
        }
        else{
            completion(nil,SpotifyServiceError.CouldNotParseDataProperly)
        }
    }
}
