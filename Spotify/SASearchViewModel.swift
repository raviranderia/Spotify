//
//  SASearchViewModel.swift
//  Spotify
//
//  Created by RAVI RANDERIA on 9/22/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation
import UIKit

protocol SASearchViewModelDelegate : class {
    func didUpdateSearchResults(controller : SASearchViewModel,searchResults : [Artist])
}

class SASearchViewModel {
    
    var requestManager : RequestManager!
    var selectedArtist : Artist?
    var artistsFound : [Artist]?
    var searchResults : [Artist] {
        if let artistsFound = artistsFound {
            return artistsFound
        }
        return []
    }
    
    weak var delegate : SASearchViewModelDelegate?
    
    func generateURL(name : String,completion : (NSURL?,Error?) -> ()) {
        let urlString = AppConfig().startURL + name + AppConfig().endURL
        if let returnString = NSURL(string: urlString){
            completion(returnString,nil)
        }
        else{
            completion(nil,SpotifyServiceError.CouldNotConstructValidURL)
        }
    }
    
    func startSearch(name : String,completion : @escaping (Bool) -> ()) {
        searchArtists(withName: name) { (artistArray, error) in
            if error != nil {
                completion(false)
            }else {
                self.artistsFound = artistArray
                completion(true)
            }
            
        }
    }
    
    private func searchArtists(withName : String,completion : @escaping ([Artist]?,Error?) -> ()) {
        generateURL(name: withName) { (url, error) in
            if error != nil {
                completion(nil,error)
            }
            if let urlRequest = url {
                let networkOperation  = NetworkOperation(url: urlRequest)
                requestManager = RequestManager(networkHelper: networkOperation)
                requestManager.getArtists() { (artistArray, error) in
                    if error != nil {
                        completion(nil,error)
                    }
                    else{
                        completion(artistArray,nil)
                        print("could not load artists for some reason")
                    }
                }
            }
         }
    }
    
    func numberOfRowsInSection(_ section : Int) -> Int{
        return searchResults.count
    }
    
    func cellForRowAtIndexPath(_ cell : ArtistTableViewCell,indexPath : IndexPath) -> UITableViewCell {
        
        cell.artistNameLabel.text = searchResults[indexPath.row].name
        cell.popularityLabel.text = searchResults[indexPath.row].rating
        
        return UITableViewCell()
    }
    
    func didSelectRowAtIndexPath(_ indexPath : IndexPath) {
        selectedArtist = searchResults[indexPath.row]
    }
}
