//
//  MovieDetailViewController.swift
//  OMDb
//
//  Created by Saurabh Garg on 27/09/2016.
//  Copyright © 2016 Gargs. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var imdbID: String!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
