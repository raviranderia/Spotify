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

final class SASearchViewModel {
    
    private var requestManager : RequestManager!
    private var artistsFound : [Artist]?
    var selectedArtist : Artist?
    var searchResults : [Artist] {
        if let artistsFound = artistsFound {
            return artistsFound
        }
        return []
    }
    
    weak var delegate : SASearchViewModelDelegate?
    
    //Where should this be? - I put it here because I need a URL for Network Operation..dependency injection for testing
    private func generateURL(name : String,completion : (NSURL?,Error?) -> ()) {
        let urlString = AppConfig().startURL + name + AppConfig().endURL
        if let returnString = NSURL(string: urlString){
            completion(returnString,nil)
        }
        else{
            completion(nil,SpotifyServiceError.CouldNotConstructValidURL)
        }
    }
    
    
    //MARK: SearchHandling
    func startSearch(name : String,completion : @escaping (Bool) -> ()) {
        artistsFound = []
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
                let networkOperation  = NetworkOperation(url: urlRequest as URL)
                requestManager = RequestManager(networkHelper: networkOperation)
                requestManager.getArtists() { (artistArray, error) in
                    if error != nil {
                        completion(nil,error)
                    }
                    else{
                        completion(artistArray,nil)
                    }
                }
            }
         }
    }
    
    //MARK: TableViewHandling
    func numberOfRowsInSection(_ section : Int) -> Int{
        return searchResults.count
    }
    
    func cellForRowAtIndexPath(_ cell : ArtistTableViewCell,indexPath : IndexPath) -> UITableViewCell {
        
        let artistCellViewModel = ArtistCellViewModel(artist: searchResults[indexPath.row])
        
        cell.artistNameLabel.text = artistCellViewModel.name
        cell.popularityLabel.text = artistCellViewModel.rating
        
        return cell
    }
    
    func didSelectRowAtIndexPath(_ indexPath : IndexPath) {
        selectedArtist = searchResults[indexPath.row]
    }
}
