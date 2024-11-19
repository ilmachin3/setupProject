//
//  OAuthToken..swift
//  setupProject
//
//  Created by Илья Дышлюк on 02.05.2024.
//

import Foundation

struct OAuthTokenBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String?
    let createdAt: Int?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
    
    let url = URL(string: "https://api.unsplash.com/oauth/token")
}
