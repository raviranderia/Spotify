//
//  ArtistCellViewModel.swift
//  Spotify
//
//  Created by RAVI RANDERIA on 9/22/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation

struct ArtistCellViewModel {
    
    let name : String
    let rating : String
    
    init(artist : Artist) {
        self.name = artist.name
        self.rating = String(artist.rating)
    }
    
}
