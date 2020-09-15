//
//  DataReponseError.swift
//  MoviesAPI
//
//  Created by Kerem on 10.08.2020.
//  Copyright © 2020 Kerem. All rights reserved.
//

import Foundation

enum DataResponseError: Error {
  case network
  case decoding
  case customError
  
  var reason: String {
    switch self {
    case .network:
      return "An error occurred while fetching data ".localizedString
    case .decoding:
      return "An error occurred while decoding data".localizedString
    case .customError:
        return "Custom error".localizedString
    }
  }
}
