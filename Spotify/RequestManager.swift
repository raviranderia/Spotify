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
    func getArtists(completion: @escaping (Result<[Artist]>) -> Void)
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
    
    func getArtists(completion: @escaping (Result<[Artist]>) -> Void) {
        
        self.networkOperation.downloadJSONFromURL { (response) in
            switch response {
            case .Success(let dict) :
                self.convertToArtistModelAndReturnArray(jsonDictionary: dict) { result in
                    switch result {
                    case .Failure(let error) :
                        completion(Result.Failure(error))
                    case .Success(let artistArray) :
                        completion(Result.Success(artistArray))
                    }
                }
            case .Failure(let error) :
                print(error)
                completion(Result.Failure(error))
            }
        }
    }
    
    private func convertToArtistModelAndReturnArray(jsonDictionary : [String : AnyObject],completion : (Result<[Artist]>)->()){
        var artistArray = [Artist]()
        if let artists = jsonDictionary["artists"] as? [String:AnyObject] {
            if let items = artists["items"] as? [[String: AnyObject]] {
                for artist in items {
                    artistArray.append(Artist(artistDictionary: artist))
                }
                completion(Result.Success(artistArray))
            }
            else{
                completion(Result.Failure(SpotifyServiceError.CouldNotParseDataProperly))
            }
        }
        else{
            completion(Result.Failure(SpotifyServiceError.CouldNotParseDataProperly))
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
