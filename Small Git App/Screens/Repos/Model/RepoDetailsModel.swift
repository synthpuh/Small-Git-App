//
//  RepoModel.swift
//  Small Git App
//
//  Created by Ольга Шубина on 09.10.2022.
//

import Foundation

protocol RepoDetailsProtocol {
    var repoId: Int { get set }
    var name: String { get set }
    var description: String? { get set }
    var owner: Owner { get set }
    var forksCount: Int? { get set }
    var watchersCount: Int? { get set }
}

struct RepoDetailsModel: Decodable, RepoDetailsProtocol {
    
    var repoId: Int
    var name: String
    var description: String?
    var owner: Owner
    var forksCount: Int?
    var watchersCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case repoId = "id"
        case name, description, owner
        case forksCount = "forks_count"
        case watchersCount = "watchers_count"
    }
}

struct Owner: Decodable {
    
    var login: String
    var avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
