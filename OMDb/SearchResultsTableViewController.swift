//
//  SearchResultsTableViewController.swift
//  OMDb
//
//  Created by Saurabh Garg on 25/09/2016.
//  Copyright © 2016 Gargs. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var searchTerm: String?
    
    private var searchResult: SearchResult? {
        didSet(newValue) {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var titles: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        guard searchTerm != nil else { return }
        
        navigationItem.title = "'" + searchTerm! + "'"
        
        debugPrint("Search Term: " + searchTerm!)
        
        search(for: searchTerm!) { [unowned self] (searchResult, error) in
            if let searchResult = searchResult {
                self.searchResult = searchResult
            } else {
                let alert = UIAlertView(title: "Search Error", message: error?.localizedDescription ?? "Please Search Again", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ListingTableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                let imdbId = searchResult!.movies![indexPath.row].imdbID
                if let movieDetailViewController = segue.destination as? UIViewController {
                    // Assign the id
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult?.currentResultCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell", for: indexPath) as! ListingTableViewCell
        cell.thumbnailURL = searchResult!.movies![indexPath.row].posterURL
        cell.titleLabel.text = searchResult!.movies![indexPath.row].title
        
        return cell
    }
}
