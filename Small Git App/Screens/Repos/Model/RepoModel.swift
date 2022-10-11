//
//  RepoModel.swift
//  Small Git App
//
//  Created by Ольга Шубина on 09.10.2022.
//

import Foundation

protocol RepoModelProtocol {
    var repoId: Int { get set }
    var name: String { get set }
}

struct RepoModel: Decodable, RepoModelProtocol {
    
    var repoId: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case repoId = "id"
        case name
    }
}
