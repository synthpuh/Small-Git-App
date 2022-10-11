//
//  AuthorisationService.swift
//  Small Git App
//
//  Created by Ольга Шубина on 03.10.2022.
//

import Foundation
import PKHUD

protocol AuthorisationServiceProtocol {
    
    var profileFetcher: ProfileFetcherProtocol? { get set }
    
    func createRequest() -> URLRequest?
    func requestCallback(request: URLRequest, completion: @escaping (GithubProfileProtocol?) -> ())
}

class AuthorisationService: AuthorisationServiceProtocol {
    
    var profileFetcher: ProfileFetcherProtocol?
    
    init(profileFetcher: ProfileFetcherProtocol) {
        self.profileFetcher = profileFetcher
    }
    
    func createRequest() -> URLRequest? {
         
        let urlString = GithubConstants.createLoginURLString()
        guard let url = URL(string: urlString) else {
            print("Couldn't create url")
            return nil
        }
        return URLRequest(url: url)
    }
    
    func requestCallback(request: URLRequest, completion: @escaping (GithubProfileProtocol?) -> ()) {
        
        guard let urlString = request.url?.absoluteString as? String else {
            print("Couldn't create navigation request")
            return
        }
        print(urlString)
        if urlString.contains(GithubConstants.redirectURI) {
            if urlString.contains("code=") {
                if let range = urlString.range(of: "=") {
                    let code = urlString[range.upperBound...]
                    if let finalRange = code.range(of: "&state=") {
                        let authorizationCode = code[..<finalRange.lowerBound]
                        Defaults.code = String(authorizationCode)
                        requestToken(code: String(authorizationCode)) { profile in
                            completion(profile)
                        }
                    }
                }
            }
        }
    }
    
    func requestToken(code: String, completion: @escaping (GithubProfileProtocol?) -> ()) {
        
        let grantType = "authorisation_code"
        let paramsString = "grant_type=\(grantType)&code=\(code)&client_id=\(GithubConstants.clientId)&client_secret=\(GithubConstants.clientSecret)"
        let paramsData = paramsString.data(using: String.Encoding.utf8)
        guard let url = URL(string: GithubConstants.token) else {
            print("Couldn't get url")
            return
        }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramsData
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request as URLRequest) { [weak self] data, response, error in
            if let error = error {
                print("Error getting response: \(error.localizedDescription)")
            } else {
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    print("Couldn't get a response")
                    return
                }
                if statusCode == 200 {
                    guard let data = data,
                          let result: AccessTokenResponse = try? JSONDecoder().decode(AccessTokenResponse.self, from: data) else {
                        print("Couldn't get data")
                        return
                    }
                    
                    let accessToken = result.accessToken
                    Defaults.accessToken = accessToken
                    self?.profileFetcher?.fetchUser(accessToken: accessToken, completion: { profile in
                        completion(profile)
                    })
                }
            }
        }.resume()
    }
}
