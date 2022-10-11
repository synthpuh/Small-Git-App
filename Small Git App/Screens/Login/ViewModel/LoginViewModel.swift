//
//  LoginViewModel.swift
//  Small Git App
//
//  Created by Ольга Шубина on 02.10.2022.
//

import Foundation
import UIKit
import WebKit

protocol LoginViewModelInterface {
    
    var authorisationService: AuthorisationServiceProtocol? { get set }
    var profile: GithubProfileProtocol? { get set }
    
    func startAuthorisation(in webView: WKWebView)
    func requestCallback(navigationAction: WKNavigationAction, completion: @escaping (GithubProfileProtocol?) -> ())
}

class LoginViewModel: LoginViewModelInterface {
    
    var authorisationService: AuthorisationServiceProtocol?
    
    var profile: GithubProfileProtocol? {
        didSet {
            Defaults.addDefaults(profile: profile)
        }
    }
    
    init(authorisationService: AuthorisationServiceProtocol) {
        self.authorisationService = authorisationService
    }
    
    func startAuthorisation(in webView: WKWebView) {
        guard let request = authorisationService?.createRequest() else {
            print("Couldn't create a request")
            return
        }
        webView.load(request)
    }
    
    func requestCallback(navigationAction: WKNavigationAction, completion: @escaping (GithubProfileProtocol?) -> ()) {
        authorisationService?.requestCallback(request: navigationAction.request, completion: { profile in
            completion(profile)
        })
    }
}
