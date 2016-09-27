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
    
    private weak var currentSearchTask: URLSessionDataTask?
    
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
        
        currentSearchTask = search(for: searchTerm!) { [weak self] (searchResult, error) in
            if let searchResult = searchResult {
                self?.searchResult = searchResult
            } else {
                let alert = UIAlertView(title: "Search Error", message: error?.localizedDescription ?? "Please Search Again", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                _ = self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ListingTableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                let movie = searchResult!.movies![indexPath.row]
                if let movieDetailViewController = segue.destination as? MovieDetailViewController {
                    movieDetailViewController.movie = movie
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResult != nil {
            // We have a search result with some entries
            if searchResult!.currentResultCount < searchResult!.totalResultCount {
                return searchResult!.currentResultCount + 1
            } else {
                return searchResult!.currentResultCount
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        if searchResult!.currentResultCount < searchResult!.totalResultCount {
            if row == searchResult!.currentResultCount {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
                if let activityIndicatorView = cell.viewWithTag(100) as? UIActivityIndicatorView {
                    activityIndicatorView.startAnimating()
                }
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell", for: indexPath) as! ListingTableViewCell
        cell.thumbnailURL = searchResult!.movies![indexPath.row].posterURL
        cell.titleLabel.text = searchResult!.movies![indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalResultCount = searchResult!.totalResultCount
        let currentResultCount = searchResult!.currentResultCount
        if indexPath.row == (currentResultCount - 1) && indexPath.row < (totalResultCount - 1) {
            // Fetch the next page
            currentSearchTask = search(for: searchTerm!, pageNumber: searchResult!.currentPage + 1, completionHandler: { [weak self] (searchResult, error) in
                if let searchResult = searchResult {
                    self?.searchResult?.append(searchResult)
                }
            })
        }
    }
}
