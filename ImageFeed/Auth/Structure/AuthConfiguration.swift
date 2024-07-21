//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 21.07.2024.
//

import UIKit

struct AuthConfiguration {
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.authorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
    }
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: String
    let authURLString: String
    
    init(accessKey: String, 
         secretKey: String,
         redirectURI: String,
         accessScope: String,
         authURLString: String,
         defaultBaseURL: String) {
        
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
