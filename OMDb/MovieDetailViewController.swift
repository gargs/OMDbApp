//
//  MovieDetailViewController.swift
//  OMDb
//
//  Created by Saurabh Garg on 27/09/2016.
//  Copyright © 2016 Gargs. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movie: Movie!
    
    private var currentDownloadTask: URLSessionDataTask?
    private var thumbnailDownloadTask: URLSessionDataTask?
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = movie.title
        navigationItem.backBarButtonItem?.title = "Search"
        
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        typeLabel.text = movie.type?.iconLabel()
        
        if let thumbnailURL = movie.posterURL {
            thumbnailDownloadTask = posterImage(for: thumbnailURL) { [weak self] (image) in
                if image != nil {
                    self?.posterImageView.image = image
                } else {
                    self?.posterImageView.image = UIImage(named: "thumbnail.png")
                }
            }
        }
        
        currentDownloadTask = fetchDetails(for: movie.imdbID) { [weak self] (movieDetails, error) in
            if let details = movieDetails {
                self?.castLabel.text = details.cast
                self?.plotLabel.text = details.plot
                self?.ratingLabel.text = details.rating
            }
        }
    }
}
