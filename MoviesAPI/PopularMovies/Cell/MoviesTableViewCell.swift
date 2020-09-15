//
//  MoviesTableViewCell.swift
//  MoviesAPI
//
//  Created by Kerem on 10.08.2020.
//  Copyright © 2020 Kerem. All rights reserved.
//

import UIKit
import SDWebImage

class MoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var moviesImageView: UIImageView!
    @IBOutlet weak var moviesTitle: UILabel!
    @IBOutlet weak var moviesReleaseDate: UILabel!
    @IBOutlet weak var moviesOverview: UILabel!
    @IBOutlet weak var movieFavButton: UIButton!
    
  
  
 
    
    func configure(data: Movies?){
        moviesTitle.text = data?.title
        moviesReleaseDate.text = data?.releaseDate
        moviesOverview.text = "Rating \(data?.voteAverage ?? 0.0)"
        moviesImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(data?.imageURL ?? "")"))
    }
    
}
