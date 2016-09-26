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
    
    @IBOutlet weak var tableView: UITableView!
    
    private var titles: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        debugPrint("Search Term: " + searchTerm)
        
        
        
        
        let session = URLSession.shared
        let request = URLRequest(url: URL(string: "http://omdbapi.com/?s=terminator")!)
        let downloadTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let results = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) {
                    let searchResults = parse(results)
                    debugPrint(searchResults)
                }
            }
        }
        downloadTask.resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell", for: indexPath)
        return cell
    }
}
