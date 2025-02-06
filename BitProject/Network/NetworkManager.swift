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
    
    var path: String {
        switch self {
        case .upcoming:
            return NetworkManager.baseURLString + "movie/upcoming"
        case .topRated:
            return NetworkManager.baseURLString + "movie/top_rated"
        case .nowPlaying:
            return NetworkManager.baseURLString + "movie/now_playing"
        case .movieDetails(let movieId):
            return NetworkManager.baseURLString + "movie/\(movieId)"
        case .favorite(_):
            return NetworkManager.baseURLString + "account/6339531/favorite"
        }
    }
}


struct NetworkManager {
    static let baseURLString: String = "https://api.themoviedb.org/3/"
    static let baseMediaURL: String = "https://image.tmdb.org/t/p/w500"
    
    static let bearerToken = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNTUzOGE2NjliYTIwNmRmMTY2ODFiOGJiOTkzN2Y5NyIsIm5iZiI6MTQ1NjgzMzYwMy41MTQsInN1YiI6IjU2ZDU4NDQzOTI1MTQxMzQwMjAxMzMzZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.CEtc9EekYNcuccnboXG4EswSZxCZjx0HVMX28AYTGyg"
    
    var fetchMovies: @Sendable (URL, Int) async throws -> Data?
    var addRemoveFavorite: @Sendable (URL, [String: Any]) async throws -> Data?
}

extension DependencyValues {
    var apiClient: NetworkManager {
        get { self[NetworkManagerKey.self] }
        set { self[NetworkManagerKey.self] = newValue }
    }
    
    private enum NetworkManagerKey: DependencyKey {
        
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
                  "Authorization": NetworkManager.bearerToken
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
                  "Authorization": NetworkManager.bearerToken
                ]
                request.httpBody = postData
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse else {return data}
                print(String(data: data, encoding: .utf8))
                return data
                
            }
        )
    }
}
