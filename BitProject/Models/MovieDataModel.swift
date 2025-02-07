//
//  MovieDataModel.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import Foundation
import SwiftData



struct MovieDataModel: Codable, Equatable, Identifiable {
    var originalTitle: String
    var originalLanguage: String
    var overview: String
    var posterPath: String
    let backdropPath: String
    var voteAverage: Float
    var releaseDate: String
    var category: String
    var id: Int
    
    var isFavorite: Bool
    
    mutating func toggleFavorite() {
        self.isFavorite.toggle()
    }
}

extension MovieDataModel {
    init(isFavorite: Bool = false, category: MovieCategory, model: MovieDataNetworkModel) {
        self.originalTitle = model.originalTitle
        self.originalLanguage = model.originalLanguage
        self.overview = model.overview
        self.posterPath = model.posterPath
        self.backdropPath = model.backdropPath
        self.voteAverage = model.voteAverage
        self.releaseDate = model.releaseDate
        self.isFavorite = isFavorite
        self.category = category.rawValue
        self.id = model.id
    }
}




