//
//  MovieDataModel.swift
//  BitProject
//
//  Created by Shauli Algawi on 06/02/2025.
//

struct MoviesResponse: Decodable, Equatable {
    let results: [MovieDataNetworkModel]
}

struct MovieDataNetworkModel: Decodable, Equatable, Identifiable {
    let originalTitle: String
    let originalLanguage: String
    let overview: String
    let posterPath: String
    let voteAverage: Float
    let releaseDate: String
    var id: Int
    
    enum CodingKeys: String, CodingKey {
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case overview = "overview"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case id = "id"
    }
}
