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
    let posterPath: String?
    let voteAverage: Float
    let releaseDate: String
    let backdropPath: String?
    let id: Int
    
    enum CodingKeys: CodingKey {
        case originalTitle
        case originalLanguage
        case overview
        case posterPath
        case voteAverage
        case releaseDate
        case backdropPath
        case id
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.originalTitle = try container.decode(String.self, forKey: .originalTitle)
        self.originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.voteAverage = try container.decode(Float.self, forKey: .voteAverage)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.id = try container.decode(Int.self, forKey: .id)
    }
    
//    enum CodingKeys: String, CodingKey {
//        case originalTitle = "original_title"
//        case originalLanguage = "original_language"
//        case overview = "overview"
//        case posterPath = "poster_path"
//        case voteAverage = "vote_average"
//        case releaseDate = "release_date"
//        case backdropPath = "backdrop_path"
//        case id = "id"
//    }
}
