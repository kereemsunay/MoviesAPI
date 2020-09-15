//
//  PopularMovies.swift
//  MoviesAPI
//
//  Created by Kerem on 10.08.2020.
//  Copyright © 2020 Kerem. All rights reserved.
//

import Foundation

struct PopularMovies: Codable {
    var results : [Movies]?
    var page: Int?
}
