//
//  ViewController.swift
//  Spotify
//
//  Created by RAVI RANDERIA on 9/22/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import UIKit

final class SASearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SASearchViewModelDelegate {
    
    @IBOutlet weak var artistResultTableView: UITableView!
    
    var saSearchViewModel : SASearchViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        saSearchViewModel = SASearchViewModel()
        saSearchViewModel.delegate = self
    }
    
    @IBAction func dummySearchAction(_ sender: UIBarButtonItem) {
        
        DispatchQueue.global().async {
            self.saSearchViewModel.startSearch(name: "Muse") { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.artistResultTableView.reloadData()
                    }
                }
                else{
                    print("could not search")
                }
            }
        }
    }
    
    func didUpdateSearchResults(controller: SASearchViewModel, searchResults: [Artist]) {
        print(searchResults)
        artistResultTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saSearchViewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ArtistTableViewCell
        return saSearchViewModel.cellForRowAtIndexPath(cell, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saSearchViewModel.didSelectRowAtIndexPath(indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? SAArtistViewController {
            destinationVC.selectedArtist = saSearchViewModel.selectedArtist
        }
    }

}

