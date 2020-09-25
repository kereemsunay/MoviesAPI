//
//  DetailViewController.swift
//  MoviesAPI
//
//  Created by Kerem on 21.08.2020.
//  Copyright © 2020 Kerem. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
	
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var detailImageView: UIImageView!
	@IBOutlet weak var tagLineLabel: UILabel!
	@IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var voteAvergaLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var movieFavButton: UIButton!
    
	var chosenID: Int = 0
	let network = Network()
	var detailMovieGenres = [String]()
	var detailMovie : [Movies] = []
	var senderTag : Int = 0

	var detail: MovieDetail?{
		didSet{
			nameLabel.text = detail?.title
			tagLineLabel.text = detail?.tagline
			detailImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(detail?.imageURL ?? "")"))
			overviewLabel.text = detail?.overview
			genreLabel.text = detail?.genres?.reduce(into: "", { (result, genre) in
				if result == "" {
					result = genre.name ?? ""
				} else {
					result = (result ?? "") + " - " + (genre.name ?? "")
				}				
			})
			voteAvergaLabel.text = "Vote Average: \(detail?.vote_average ?? 0.0)"
            releaseDateLabel.text = "Release Date: \(detail?.release_date ?? "")"
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print("chosenID",chosenID)
		print("asdasdas",senderTag)
		fetchDetails()
	}
    @IBAction func imdbClicked(_ sender: Any) {
		guard let url = URL(string: "https://www.imdb.com/title/\(detail?.imdb_id ?? "")/") else { return }
		UIApplication.shared.open(url)
    }
    
	func fetchDetails(){
		network.getMovieDetail(id: chosenID) { (result) in
			switch result{
			case .success(let details):
				self.detail = details
			case .failure(let error):
				
				print("error",error)
			}
		}
		
	}
	
	
    @IBAction func favClicked(_ sender: UIButton) {
	
    }
	
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
