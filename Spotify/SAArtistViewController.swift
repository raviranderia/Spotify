//
//  SAArtistViewController.swift
//  Spotify
//
//  Created by RAVI RANDERIA on 9/22/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import UIKit

final class SAArtistViewController: UIViewController {
    
    var selectedArtist : Artist?

    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let artist = selectedArtist {
            artistName.text = artist.name
            if let imageURL = artist.imageURLs {
                if imageURL.count != 0{
                    artistImage.downloadedFrom(url: imageURL.first!, contentMode: .scaleAspectFit)
                    
                    for url in imageURL {
                        scrollView.auk.show(url: url.absoluteString)
                    }
                }
            }
        }
    }
}
