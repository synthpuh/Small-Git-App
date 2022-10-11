//
//  CommitFetcher.swift
//  Small Git App
//
//  Created by Ольга Шубина on 10.10.2022.
//

import Foundation
import PKHUD

protocol CommitFetcherProtocol {
    
    var owner: String { get set }
    var repo: String? { get set }
    
    
    func fetchCommits(completion: @escaping ([CommitResponseProtocol]) -> ())
}

class CommitFetcher: CommitFetcherProtocol {
    
    var owner: String
    var repo: String?
    
    init(owner: String, repo: String) {
        self.owner = owner
    }
    
    func fetchCommits(completion: @escaping ([CommitResponseProtocol]) -> ()) {
        let urlString = GithubConstants.createCommitsURLString(owner: owner, repo: repo ?? "")
        DataFetcher.fetchData(urlString: urlString) { (response: [CommitResponse]?) in
            guard let response = response else {
                completion([])
                return
            }
            completion(response)
        }
    }
}
