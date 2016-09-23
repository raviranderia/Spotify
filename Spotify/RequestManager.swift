//
//  RequestManager.swift
//  Spotify
//
//  Created by RAVI RANDERIA on 9/22/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation
import UIKit

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
    
    private func convertToArtistModelAndReturnArray(jsonDictionary : [String : AnyObject],completion : ([Artist]?,Error?)->()){
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

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
