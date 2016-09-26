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
    
    var thumbnailURL: URL? {
        willSet(newValue) {
            if let url = newValue {
                if let data = try? Data(contentsOf: url) {
                    let image = UIImage(data: data)
                    thumbnailImageView.image = image
                } else {
                    thumbnailImageView.image = UIImage(named: "thumbnail.png")
                }
            } else {
                thumbnailImageView.image = UIImage(named: "thumbnail.png")
            }
        }
    }
}
