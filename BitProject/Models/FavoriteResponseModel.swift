//
//  FavoriteResponseModel.swift
//  BitProject
//
//  Created by Shauli Algawi on 05/02/2025.
//

import Foundation

struct FavoriteResponseModel: Decodable {
    let success: Bool
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: CodingKey {
        case success
        case statusCode
        case statusMessage
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.statusCode = try container.decode(Int.self, forKey: .statusCode)
        self.statusMessage = try container.decode(String.self, forKey: .statusMessage)
    }
}
