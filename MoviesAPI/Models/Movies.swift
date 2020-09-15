//
//  Movies.swift
//  MoviesAPI
//
//  Created by Kerem on 10.08.2020.
//  Copyright © 2020 Kerem. All rights reserved.
//

import Foundation

struct Movies:Codable {
    let title: String?
    let releaseDate: String?
    let overview : String?
    let imageURL : String?
    let id : Int?
    let voteAverage:Double?
    
    enum CodingKeys : String, CodingKey {
        case title,overview,id
        case releaseDate = "release_date"
        case imageURL = "poster_path"
        case voteAverage = "vote_average"
    }
}

extension Movies: Equatable{
    static func == (lhs: Movies, rhs: Movies) -> Bool {
        return lhs.id == rhs.id
    }
}
