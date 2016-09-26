//
//  SearchResultsTableViewController.swift
//  OMDb
//
//  Created by Saurabh Garg on 25/09/2016.
//  Copyright © 2016 Gargs. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var searchTerm: String!
    var searchResult: SearchResult?
    
    @IBOutlet weak var tableView: UITableView!
    
    private var titles: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        navigationItem.title = searchTerm
        
        debugPrint("Search Term: " + searchTerm)
        
        let session = URLSession.shared
        let request = URLRequest(url: searchURL(searchTerm: searchTerm))
        let downloadTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let results = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) {
                    let searchResults = parse(results)
                    debugPrint(searchResults)
                    DispatchQueue.main.async {
                        self.searchResult = searchResults
                        self.tableView.reloadData()
                    }
                }
            }
        }
        downloadTask.resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult?.movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell", for: indexPath) as! ListingTableViewCell
        cell.thumbnailURL = searchResult?.movies?[indexPath.row].posterURL
        cell.titleLabel.text = searchResult?.movies?[indexPath.row].title
        
        return cell
    }
}
