//
//  SearchViewController.swift
//  OMDb
//
//  Created by Saurabh Garg on 25/09/2016.
//  Copyright © 2016 Gargs. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var searchTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let searchTerm = searchTextField.text, searchTerm.characters.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchResultsViewController = segue.destination as? SearchResultsViewController {
            searchResultsViewController.searchTerm = searchTextField.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let segueIdentifier = "showSearchResults"
        
        if shouldPerformSegue(withIdentifier: segueIdentifier, sender: nil) {
            performSegue(withIdentifier: segueIdentifier, sender: nil)
        }
        return true
    }
}
