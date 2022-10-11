//
//  ProfileFetcher.swift
//  Small Git App
//
//  Created by Ольга Шубина on 04.10.2022.
//

import Foundation
import PKHUD

protocol ProfileFetcherProtocol {
    func fetchUser(accessToken: String, completion: @escaping (GithubProfileProtocol?) -> ())
}

class ProfileFetcher: ProfileFetcherProtocol {
    
    func fetchUser(accessToken: String, completion: @escaping (GithubProfileProtocol?) -> ()) {
        
        let urlString = GithubConstants.profileUrl
        DataFetcher.fetchData(urlString: urlString) { (profile: GithubProfile?) in
            completion(profile)
        }
    }
}
