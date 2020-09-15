//
//  DataStore.swift
//  MoviesAPI
//
//  Created by Kerem on 20.08.2020.
//  Copyright © 2020 Kerem. All rights reserved.
//

import Foundation

class DataStore {
   
    // MARK: - Properties
    let defaults = UserDefaults.standard
    
    func getFavMovies() -> [Movies]?{
        if let data = defaults.data(forKey: "favList") {
            let array = try? PropertyListDecoder().decode([Movies].self, from: data)
            return array
        }
       return nil
       
    }
    func setFavMovies(_ encodeFavList : [Movies]) {
        if let data = try? PropertyListEncoder().encode(encodeFavList) {
            UserDefaults.standard.set(data, forKey: "favList")
            print("data",data)
        }
    }
    
    
}

