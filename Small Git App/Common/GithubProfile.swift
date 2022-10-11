//
//  GithubProfile.swift
//  Small Git App
//
//  Created by Ольга Шубина on 04.10.2022.
//

import Foundation

protocol GithubProfileProtocol {
    var userId: Int? { get set }
    var name: String? { get set }
    var avatarUrlString: String? { get set }
}

struct GithubProfile: Decodable, GithubProfileProtocol {
    
    var userId: Int?
    var name: String?
    var avatarUrlString: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case name = "login"
        case avatarUrlString = "avatar_url"
    }
}
