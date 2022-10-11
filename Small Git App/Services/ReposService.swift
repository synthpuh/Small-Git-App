//
//  ReposService.swift
//  Small Git App
//
//  Created by Ольга Шубина on 09.10.2022.
//

import Foundation

protocol ReposServiceProtocol {
    func fetchRepos(completion: @escaping ([RepoDetailsProtocol]) -> ())
}

class ReposService: ReposServiceProtocol {
    
    func fetchRepos(completion: @escaping ([RepoDetailsProtocol]) -> ()) {
        let urlString = GithubConstants.reposUrl
        DataFetcher.fetchData(urlString: urlString) { (response: [RepoDetailsModel]?) in
            guard let response = response else {
                completion([])
                return
            }
            completion(response)
        }
    }
}
