//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 15.07.2024.
//

import UIKit

class OAuth2TokenStorage {
    
    private let userDefaults = UserDefaults.standard
    var token: String? {
        get {
            userDefaults.string(forKey: "bearerToken")
        }
        set {
            userDefaults.setValue(newValue, forKey: "bearerToken")
        }
    }
}
