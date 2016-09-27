//
//  SearchResult.swift
//  OMDb
//
//  Created by Saurabh Garg on 26/09/2016.
//  Copyright © 2016 Gargs. All rights reserved.
//

import Foundation

enum Type: String {
    case movie
    case series
    case short
    case game
}

struct SearchResult {
    var totalResultCount: Int
    var currentResultCount: Int {
        get {
            return movies?.count ?? 0
        }
    }
    var currentPage: Int
    var movies: [Movie]?
    
    mutating func append(_ searchResults: SearchResult) {
        if let newMovies = searchResults.movies, newMovies.count > 0 {
            movies = movies ?? []
            movies!.append(contentsOf: newMovies)
        }
    }
}

struct Movie {
    var title: String
    var year: String
    var imdbID: String
    var type: Type?
    var posterURL: URL?
}

struct MovieDetails {
    var title: String
    var year: String
    var imdbID: String
    var type: Type?
    var posterURL: URL?
    var cast: String?
    var plot: String?
    var rating: String?
}
