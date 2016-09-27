//
//  ListingTableViewCell.swift
//  OMDb
//
//  Created by Saurabh Garg on 25/09/2016.
//  Copyright © 2016 Gargs. All rights reserved.
//

import UIKit

class ListingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var currentThumbnailDownloadTask: URLSessionDataTask?
    
    var thumbnailURL: URL? {
        willSet(newValue) {
            if let url = newValue {
                
                currentThumbnailDownloadTask = posterImage(for: url, completionHandler: { [weak self] (image) in
                    
                    if image != nil {
                        self?.thumbnailImageView.image = image
                    } else {
                        self?.thumbnailImageView.image = UIImage(named: "thumbnail.png")
                    }
                    self?.currentThumbnailDownloadTask = nil
                })
            } else {
                thumbnailImageView.image = UIImage(named: "thumbnail.png")
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentThumbnailDownloadTask?.cancel()
        thumbnailImageView.image = UIImage(named: "thumbnail.png")
    }
}
