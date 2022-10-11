//
//  OAuthData.swift
//  Small Git App
//
//  Created by Ольга Шубина on 02.10.2022.
//

import Foundation

struct GithubConstants {
    
    static let loginUrl = "https://github.com/login/oauth/authorize"
    static let profileUrl = "https://api.github.com/user"
    static let reposUrl = "https://api.github.com/user/repos"
    static let commitsURL = "https://api.github.com/repos"
    
    static let clientId = SecretConstants.clientId
    static let clientSecret = SecretConstants.clientSecret
    static let redirectURI = "https://smallgitapp.io/callback"
    static let scope = "read:user,user:email"
    static let token = "https://github.com/login/oauth/access_token"
    
    static func createLoginURLString() -> String {
        let state = UUID().uuidString
        return "\(loginUrl)?client_id=\(clientId)&redirect_uri=\(redirectURI)&scope=\(scope)&state=\(state)"
    }
    
    static func createCommitsURLString(owner: String, repo: String) -> String {
        return "\(commitsURL)/\(owner)/\(repo)/commits"
    }
    
}
