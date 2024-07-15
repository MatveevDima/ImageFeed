//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 15.07.2024.
//

import UIKit

class OAuth2TokenStorage {
    
    private let userDefaults = UserDefaults.standard
    private let bearerTokenKey = "bearerToken"
    
    init() {
       // userDefaults.removeObject(forKey: bearerTokenKey)
    }
    
    var token: String? {
        get {
            userDefaults.string(forKey: bearerTokenKey)
        }
        set {
            userDefaults.setValue(newValue, forKey: bearerTokenKey)
        }
    }
}
