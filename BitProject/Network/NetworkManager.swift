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
    
    var fetchMovies: @Sendable (URL) async throws -> Data
}

extension DependencyValues {
    var apiClient: NetworkManager {
        get { self[NetworkManagerKey.self] }
        set { self[NetworkManagerKey.self] = newValue }
    }
    
    private enum NetworkManagerKey: DependencyKey {
        
        static let liveValue = NetworkManager(
            fetchMovies: { url in
                var request = URLRequest(url: url)
                request.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNTUzOGE2NjliYTIwNmRmMTY2ODFiOGJiOTkzN2Y5NyIsIm5iZiI6MTQ1NjgzMzYwMy41MTQsInN1YiI6IjU2ZDU4NDQzOTI1MTQxMzQwMjAxMzMzZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.CEtc9EekYNcuccnboXG4EswSZxCZjx0HVMX28AYTGyg", forHTTPHeaderField: "Authorization")
                let (data, _) = try await URLSession.shared.data(for: request)
                return data
            }
        )
    }
}
