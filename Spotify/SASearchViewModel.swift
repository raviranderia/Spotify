//
//  SASearchViewModel.swift
//  Spotify
//
//  Created by RAVI RANDERIA on 9/22/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation
import UIKit


final class SASearchViewModel {
    
    private var requestManager : RequestManager!
    private var artistsFound : [Artist]?
    var selectedArtist : Artist?
    var searchResults : [Artist] {
        return artistsFound ?? []
    }
        
    //Where should this be? - I put it here because I need a URL for Network Operation..dependency injection for testing
    private func generateURL(name : String,completion : (NSURL?,Error?) -> ()) {
        if let urlString = (AppConfig().startURL + name + AppConfig().endURL).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            if let returnString = NSURL(string: urlString){
                completion(returnString,nil)
            }
            else{
                completion(nil,SpotifyServiceError.CouldNotConstructValidURL)
            }
        }
    }
    
    
    //MARK: SearchHandling
    func startSearch(name : String,completion : @escaping (Bool) -> ()) {
        artistsFound = []
        
        searchArtists(withName: name) { (result) in
            switch result {
            case .Failure(_) :
                completion(false)
            case .Success(let artistArray) :
                self.artistsFound = artistArray
                completion(true)
            }
        }
    }
    
    private func searchArtists(withName : String,completion : @escaping (Result<[Artist]>) -> Void){
        generateURL(name: withName) { (url, error) in
            if let errorFound = error {
                completion(Result.Failure(errorFound))
            }
            if let urlRequest = url {
                let networkOperation  = NetworkOperation(url: urlRequest as URL)
                requestManager = RequestManager(networkHelper: networkOperation)
                
                requestManager.getArtists() { (result) in
                    switch result {
                    case .Failure(let error) :
                        completion(Result.Failure(error))
                    case .Success(let artistArray) :
                        completion(Result.Success(artistArray))
                    }
                }
            }
         }
    }
    
    //MARK: TableViewHandling
    func numberOfRowsInSection(_ section : Int) -> Int{
        return searchResults.count
    }
    
    func viewModel(for indexPath: IndexPath) -> ArtistCellViewModel {
        return ArtistCellViewModel(artist: searchResults[indexPath.row])
    }
    func didSelectRowAtIndexPath(_ indexPath : IndexPath) {
        selectedArtist = searchResults[indexPath.row]
    }
}
