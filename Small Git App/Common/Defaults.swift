//
//  DefaultsService.swift
//  Small Git App
//
//  Created by Ольга Шубина on 08.10.2022.
//

import Foundation

class Defaults {
    
    static var accessToken: String? {
        get {
            UserDefaults.standard.string(forKey: "accessToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "accessToken")
        }
    }
    
    static var code: String? {
        get {
            UserDefaults.standard.string(forKey: "authorisationCode")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "authorisationCode")
        }
    }
    
    static var isUserLoggedIn: Bool {
        UserDefaults.standard.bool(forKey: "userLoggedIn")
    }
    static var defaultUserId: Int? {
        UserDefaults.standard.integer(forKey: "loginUserId")
    }
    static var defaultName: String? {
        UserDefaults.standard.string(forKey: "loginUsername")
    }
    static var defaultAvatarUrlString: String? {
        UserDefaults.standard.string(forKey: "loginAvatarUrl")
    }
    
    static func addDefaults(profile: GithubProfileProtocol?) {
        if let profile = profile {
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            UserDefaults.standard.set(profile.userId, forKey: "loginUserId")
            UserDefaults.standard.set(profile.name, forKey: "loginUsername")
            UserDefaults.standard.set(profile.avatarUrlString, forKey: "loginAvatarUrl")
        } else {
            UserDefaults.standard.set(false, forKey: "userLoggedIn")
            UserDefaults.standard.set(nil, forKey: "accessToken")
            UserDefaults.standard.set(nil, forKey: "loginUserId")
            UserDefaults.standard.set(nil, forKey: "loginUsername")
            UserDefaults.standard.set(nil, forKey: "loginAvatarUrl")
        }
    }
}
