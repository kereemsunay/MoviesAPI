//
//  FavoritesTableViewCell.swift
//  MoviesAPI
//
//  Created by Kerem on 19.08.2020.
//  Copyright © 2020 Kerem. All rights reserved.
//

import UIKit
import SDWebImage

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var favimageView: UIImageView!
    
    func configureFavCell(data: Movies?){
        nameLabel.text = data?.title
        releaseLabel.text = data?.releaseDate
        overviewLabel.text = "Rating \(data?.voteAverage ?? 0.0)"
        favimageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(data?.imageURL ?? "")"))
    }
}
