//
//  AuthConfiguration.swift
//  setupProject
//
//  Created by Илья Дышлюк on 20.11.2024.
//

import Foundation

enum Constants {
    static let AccessKey = "J5UYk2t_AZn4Ceh4PKVDrIcMiQeAsh_886mLvYa_NS0"
    static let SecretKey = "SekZF0l0XQWeiU7PxMqReTaN-N4Pbn5ElOIxek0hUvY"
    static let RedirectURL = "urn:ietf:wg:oauth:2.0:oob"
    static let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let AccessScope = "public+read_user+write_likes"
    static let DefaultBaseURL = URL(string: "https://api.unsplash.com/")!
}
struct AuthConfiguration {
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.AccessKey,
                                 secretKey: Constants.SecretKey,
                                 redirectURI: Constants.RedirectURL,
                                 accessScope: Constants.AccessScope,
                                 defaultBaseURL: Constants.DefaultBaseURL,
                                 authURLString: Constants.UnsplashAuthorizeURLString)
    }
    
    let accessKey: String
    let secretKey: String
    let redirectURI : String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
