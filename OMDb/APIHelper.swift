//
//  APIHelper.swift
//  OMDb
//
//  Created by Saurabh Garg on 26/09/2016.
//  Copyright © 2016 Gargs. All rights reserved.
//

import UIKit

func baseURLComponents() -> URLComponents {
    var urlComponents = URLComponents()
    urlComponents.scheme = "http"
    urlComponents.host = "omdbapi.com"
    urlComponents.path = "/"
    
    return urlComponents
}

func searchURL(searchTerm: String, pageNumber: Int = 1) -> URL? {
    var components = baseURLComponents()
    let searchQueryItem = URLQueryItem(name: "s", value: searchTerm)
    let typeQueryItem = URLQueryItem(name: "r", value: "json")
    let apiVersionQueryItem = URLQueryItem(name: "v", value: "1")
    let pageNumberQueryItem = URLQueryItem(name: "page", value: String(pageNumber))
    
    components.queryItems = [searchQueryItem, typeQueryItem, apiVersionQueryItem, pageNumberQueryItem]
    return components.url
}

func detailURL(imdbId: String) -> URL? {
    var components = baseURLComponents()
    let imdbIdQueryItem = URLQueryItem(name: "i", value: imdbId)
    let typeQueryItem = URLQueryItem(name: "r", value: "json")
    let apiVersionQueryItem = URLQueryItem(name: "v", value: "1")
    
    components.queryItems = [imdbIdQueryItem, typeQueryItem, apiVersionQueryItem]
    return components.url
}

func search(for searchTerm: String, pageNumber: Int = 1, completionHandler: ((SearchResult?, Error?) -> Void)?) -> URLSessionDataTask? {
    let session = URLSession.shared
    
    if let searchURL = searchURL(searchTerm: searchTerm, pageNumber: pageNumber) {
        let request = URLRequest(url: searchURL)
        let downloadTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let results = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) {
                    let searchResults = parseSearchResult(results)
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
        return downloadTask
    }
    return nil
}

func fetchDetails(for imdbId: String, completionHandler: ((MovieDetails?, Error?) -> Void)?) -> URLSessionDataTask? {
    let session = URLSession.shared
    
    if let detailURL = detailURL(imdbId: imdbId) {
        let request = URLRequest(url: detailURL)
        let downloadTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let results = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) {
                    let movieDetails = parseMovieDetails(results)
                    DispatchQueue.main.async {
                        completionHandler?(movieDetails, nil)
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
        return downloadTask
    }
    return nil
}

func parseSearchResult(_ resultsDictionary: Any, pageNumber: Int = 1) -> SearchResult? {
    
    var movies: [Movie]?
    if let results = resultsDictionary as? NSDictionary {
        
        let response = results["Response"] as! String
        
        if response == "True" {
            let count = Int(results["totalResults"] as! String)!
            if let movieResults = results["Search"] as? [[String: Any]] {
                for movieResult in movieResults {
                    let title = movieResult["Title"] as! String
                    let year = movieResult["Year"] as! String
                    let imdbID = movieResult["imdbID"] as! String
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

func parseMovieDetails(_ resultsDictionary: Any) -> MovieDetails? {
    
    if let result = resultsDictionary as? NSDictionary {
        let response = result["Response"] as! String
        
        if response == "True" {
            let title = result["Title"] as! String
            let year = result["Year"] as! String
            let imdbID = result["imdbID"] as! String
            let type = Type(rawValue: result["Type"] as! String)
            let posterURL: URL?
            if let posterURLString = result["Poster"] as? String {
                posterURL = URL(string: posterURLString)
            } else {
                posterURL = nil
            }
            let cast = result["Actors"] as? String
            let plot = result["Plot"] as? String
            let rating = result["Rated"] as? String
            return MovieDetails(title: title, year: year, imdbID: imdbID, type: type, posterURL: posterURL, cast: cast, plot: plot, rating: rating)
        } else {
            return nil
        }
    }
    return nil
}

func posterImage(for url: URL, completionHandler: ((UIImage?) -> Void)?) -> URLSessionDataTask? {
    let session = URLSession.shared
    let downloadTask = session.dataTask(with: url) { (data, response, error) in
        if data != nil {
            if let image = UIImage(data: data!) {
                DispatchQueue.main.async {
                    completionHandler?(image)
                }
            }
        }
    }
    downloadTask.resume()
    return downloadTask
}
