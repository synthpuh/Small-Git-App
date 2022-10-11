//
//  CommitResponse.swift
//  Small Git App
//
//  Created by Ольга Шубина on 10.10.2022.
//

import Foundation

protocol CommitResponseProtocol {
    
    var hash: String { get set }
    var commit: Commit? { get set }
}

struct CommitResponse: Decodable, CommitResponseProtocol {
    
    var hash: String
    
    var commit: Commit?
    
    enum CodingKeys: String, CodingKey {
        case hash = "sha"
        case commit
    }
}

struct Commit: Decodable {
    var committer: Committer?
    var message: String?
}

struct Committer: Decodable {
    var name: String?
    var date: String?
}
