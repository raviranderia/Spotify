//
//  ArtistTableViewCell.swift
//  Spotify
//
//  Created by RAVI RANDERIA on 9/22/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import UIKit

final class ArtistTableViewCell: UITableViewCell {
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    
    func configure(artistCellViewModel : ArtistCellViewModel) {        
        artistNameLabel.text = artistCellViewModel.name
        popularityLabel.text = artistCellViewModel.rating
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
