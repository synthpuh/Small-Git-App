//
//  AccessToken.swift
//  Small Git App
//
//  Created by Ольга Шубина on 04.10.2022.
//

import Foundation

struct AccessTokenResponse: Decodable {
    
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
