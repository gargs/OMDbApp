//
//  APIHelper.swift
//  OMDb
//
//  Created by Saurabh Garg on 26/09/2016.
//  Copyright © 2016 Gargs. All rights reserved.
//

import Foundation

func baseURL() -> URL {
    var urlComponents = URLComponents()
    urlComponents.scheme = "http"
    urlComponents.host = "omdbapi.com"
    urlComponents.path = "/"
    
    return urlComponents.url!
}

func searchURL(searchTerm: String, pageNumber: Int = 1) -> URL? {
    var components = URLComponents(url: baseURL(), resolvingAgainstBaseURL: true)!
    let searchQueryItem = URLQueryItem(name: "s", value: searchTerm)
    let typeQueryItem = URLQueryItem(name: "r", value: "json")
    let apiVersionQueryItem = URLQueryItem(name: "v", value: "1")
    let pageNumberQueryItem = URLQueryItem(name: "page", value: String(pageNumber))
    
    components.queryItems = [searchQueryItem, typeQueryItem, apiVersionQueryItem, pageNumberQueryItem]
    return components.url
}

func search(for searchTerm: String, completionHandler: ((SearchResult?, Error?) -> Void)?) {
    let session = URLSession.shared
    
    if let searchURL = searchURL(searchTerm: searchTerm) {
        let request = URLRequest(url: searchURL)
        let downloadTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let results = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) {
                    let searchResults = parse(results)
//                    debugPrint(searchResults)
                    DispatchQueue.main.async {
                        completionHandler?(searchResults, nil)
                    }
                } else {
                    let error = NSError(domain: "com.cerebrawl.OMDb.error", code: 301, userInfo: [NSLocalizedDescriptionKey: "JSON Parsing error"])
                    completionHandler?(nil, error)
                }
            } else {
                completionHandler?(nil, error)
            }
        }
        downloadTask.resume()
    }
}

func parse(_ resultsDictionary: Any, pageNumber: Int = 1) -> SearchResult? {
    
    var movies: [Movie]?
    if let results = resultsDictionary as? NSDictionary {
        
        let response = results["Response"] as! String
        
        if response == "True" {
            let count = Int(results["totalResults"] as! String)!
            if let movieResults = results["Search"] as? [[String: Any]] {
                for movieResult in movieResults {
                    let title = movieResult["Title"] as! String
                    let year = Int(movieResult["Year"] as! String)
                    let imdbID = movieResult["imdbID"] as? String
                    let type = Type(rawValue: movieResult["Type"] as! String)
                    let posterURL: URL?
                    if let posterURLString = movieResult["Poster"] as? String {
                        posterURL = URL(string: posterURLString)
                    } else {
                        posterURL = nil
                    }
                    let movie = Movie(title: title, year: year, imdbID: imdbID, type: type, posterURL: posterURL)
                    movies = movies ?? []
                    movies?.append(movie)
                }
            }
            let searchResult = SearchResult(totalResultCount: count, currentPage: pageNumber, movies: movies)
            return searchResult
            
        } else {
            return nil
        }
    }
    
    return nil
}
