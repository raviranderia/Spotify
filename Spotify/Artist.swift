//
//  ArtistModel.swift
//  Spotify
//
//  Created by RAVI RANDERIA on 9/22/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation
import UIKit

struct Artist {
    let name : String
    let rating : Int
    var imageURLs : [URL]?
    
    init(artistDictionary : [String : AnyObject]) {
        
        imageURLs = [URL]()        
        let artistName = artistDictionary["name"] as! String
        self.name = artistName
        
        let artistRating = artistDictionary["popularity"] as! Int
        self.rating = artistRating
        
        if let artistImageURLs = artistDictionary["images"] as? [[String:AnyObject]] {
            for imageData in artistImageURLs {
                if let artistImageURL = imageData["url"] as? String {
                    guard let url = URL(string: artistImageURL) else { break }
                    imageURLs?.append(url)
                }
            }
        }
        else{
            imageURLs = nil
        }
        
    }
    
    
}
