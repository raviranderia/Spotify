//
//  ViewController.swift
//  Spotify
//
//  Created by RAVI RANDERIA on 9/22/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import UIKit

final class SASearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var artistResultTableView: UITableView!
    
    private var saSearchViewModel : SASearchViewModel!
    private var resultSearchController : UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        saSearchViewModel = SASearchViewModel()
        setupSearchController()
    }
    
    //MARK: UISearchController
    private func setupSearchController() {
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.delegate = self
            artistResultTableView.tableHeaderView = controller.searchBar
            return controller
        })()
        resultSearchController.delegate = self
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = (resultSearchController.searchBar.text),text != "" else {return}
        self.saSearchViewModel.startSearch(name: text) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.artistResultTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.fade)
                }
            }
            else{
                print("could not search")
            }
        }
        }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = (resultSearchController.searchBar.text),text != "" else {return}
        self.saSearchViewModel.startSearch(name: text) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.artistResultTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.fade)
                }
            }
            else{
                print("could not search")
            }
        }
        }
    
    func didUpdateSearchResults(controller: SASearchViewModel, searchResults: [Artist]) {
        print(searchResults)
        artistResultTableView.reloadData()
    }
    
    //MARK: UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saSearchViewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ArtistTableViewCell
        let viewModel = saSearchViewModel.viewModel(for: indexPath)
        cell.configure(artistCellViewModel: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saSearchViewModel.didSelectRowAtIndexPath(indexPath)
        if resultSearchController.isActive {
            resultSearchController.dismiss(animated: true) {
                self.performSegue(withIdentifier: "showArtistDetail", sender: nil)
            }
        }
        else{
            self.performSegue(withIdentifier: "showArtistDetail", sender: nil)
        }
        
    }

    //MARK: Segue 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? SAArtistViewController {
            destinationVC.selectedArtist = saSearchViewModel.selectedArtist
        }
    }

}

