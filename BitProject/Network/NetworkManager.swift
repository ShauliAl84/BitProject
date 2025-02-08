//
//  NetworkManager.swift
//  BitProject
//
//  Created by Shauli Algawi on 04/02/2025.
//

import Foundation
import ComposableArchitecture

enum Endpoints {
    case upcoming
    case topRated
    case nowPlaying
    case movieDetails(Int)
    case favorite(Int)
    case videos(Int)
    case imageFromPath(String)
        
    var path: String {
        switch self {
        case .upcoming:
            return baseURLString + "movie/upcoming"
        case .topRated:
            return baseURLString + "movie/top_rated"
        case .nowPlaying:
            return baseURLString + "movie/now_playing"
        case .movieDetails(let movieId):
            return baseURLString + "movie/\(movieId)"
        case .favorite(_):
            return baseURLString + "account/6339531/favorite"
        case .videos(let movieId):
            return baseURLString + "movie/\(movieId)/videos"
        case .imageFromPath(let moviePosterPath):
            return baseMediaURL + moviePosterPath
        }
    }
}
 let baseURLString: String = "https://api.themoviedb.org/3/"
 let baseMediaURL: String = "https://image.tmdb.org/t/p/w500"
 let bearerToken = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNTUzOGE2NjliYTIwNmRmMTY2ODFiOGJiOTkzN2Y5NyIsIm5iZiI6MTQ1NjgzMzYwMy41MTQsInN1YiI6IjU2ZDU4NDQzOTI1MTQxMzQwMjAxMzMzZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.CEtc9EekYNcuccnboXG4EswSZxCZjx0HVMX28AYTGyg"


struct NetworkManager {
    
    var fetchMovies: @Sendable (URL, Int) async throws -> Data?
    var fetchMovieVideos: @Sendable(URL) async throws -> Data?
    var addRemoveFavorite: @Sendable (URL, [String: Any]) async throws -> Data?
}

extension DependencyValues {
    var apiClient: NetworkManager {
        get { self[NetworkManager.self] }
        set { self[NetworkManager.self] = newValue }
    }
    
    
}


extension NetworkManager: DependencyKey {
    
    static let liveValue = NetworkManager(
        fetchMovies: { url, page in
            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {return nil}
            let queryItems: [URLQueryItem] = [
              URLQueryItem(name: "language", value: "en-US"),
              URLQueryItem(name: "page", value: "\(page)"),
            ]
            components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
            
            var request = URLRequest(url: components.url ?? url)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
              "accept": "application/json",
              "Authorization": bearerToken
            ]
            
            let (data, _) = try await URLSession.shared.data(for: request)
            return data
        }, fetchMovieVideos: { url in
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            let queryItems: [URLQueryItem] = [
              URLQueryItem(name: "language", value: "en-US"),
            ]
            components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
              "accept": "application/json",
              "Authorization": bearerToken
            ]

            let (data, _) = try await URLSession.shared.data(for: request)
            return data
        }, addRemoveFavorite: { url, parameters in
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
              "accept": "application/json",
              "content-type": "application/json",
              "Authorization": bearerToken
            ]
            request.httpBody = postData
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {return data}
            print(String(data: data, encoding: .utf8))
            return data
            
        }
    )
}
