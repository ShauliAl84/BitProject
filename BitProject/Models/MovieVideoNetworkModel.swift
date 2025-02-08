//
//  MovieVideoNetworkModel.swift
//  BitProject
//
//  Created by Shauli Algawi on 07/02/2025.
//

import Foundation

struct MovieVideosReponseNetworkModel: Decodable, Equatable {
    let id: Int
    let results: [MovieVideoNetworkModel]
}

struct MovieVideoNetworkModel: Decodable, Equatable, Identifiable {
    let name: String
    let key: String
    let id: String
    
//    enum CodingKeys: String, CodingKey {
//        case name = "name"
//        case videoId = "key"
//        case id = "id"
//    }
}
