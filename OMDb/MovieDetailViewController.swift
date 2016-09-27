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
        
        DispatchQueue.global(qos: .background).async { [unowned self] in
            if self.movie.posterURL != nil, let imageData = try? Data(contentsOf: self.movie.posterURL!) {
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(data: imageData)
                }
            }
        }
        
        currentDownloadTask = fetchDetails(for: movie.imdbID) { [unowned self] (movieDetails, error) in
            if let details = movieDetails {
                self.castLabel.text = details.cast
                self.plotLabel.text = details.plot
                self.ratingLabel.text = details.rating
            }
        }
    }
}
