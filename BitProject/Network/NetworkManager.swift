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
            
        }
    }
}


struct NetworkManager {
    static let baseURLString: String = "https://api.themoviedb.org/3/"
    static let baseMediaURL: String = "https://image.tmdb.org/t/p/w500"
    
    var fetchMovies: @Sendable (URL, Int) async throws -> Data?
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
                  "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNTUzOGE2NjliYTIwNmRmMTY2ODFiOGJiOTkzN2Y5NyIsIm5iZiI6MTQ1NjgzMzYwMy41MTQsInN1YiI6IjU2ZDU4NDQzOTI1MTQxMzQwMjAxMzMzZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.CEtc9EekYNcuccnboXG4EswSZxCZjx0HVMX28AYTGyg"
                ]
                
                let (data, _) = try await URLSession.shared.data(for: request)
                return data
            }
        )
    }
}
