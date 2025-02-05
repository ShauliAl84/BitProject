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
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
