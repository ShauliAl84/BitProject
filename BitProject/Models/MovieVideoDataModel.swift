//
//  MovieVideoDataModel.swift
//  BitProject
//
//  Created by Shauli Algawi on 07/02/2025.
//

import Foundation

struct MovieVideoDataModel: Codable, Equatable, Identifiable {
    let name: String
    let key: String
    let id: String
}

extension MovieVideoDataModel {
    init(model: MovieVideoNetworkModel) {
        self.name = model.name
        self.key = model.videoId
        self.id = model.id
    }
}
