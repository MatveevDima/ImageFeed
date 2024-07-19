//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 15.07.2024.
//

import UIKit
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
   
    private init() { }
    
    private let keychain = KeychainWrapper.standard
    let bearerTokenKey = "bearerToken"
    
    
    var token: String? {
        get {
            keychain.string(forKey: bearerTokenKey)
        }
        set {
            guard let newValue = newValue else { return }
            let isSuccess = keychain.set(newValue, forKey: bearerTokenKey)
            guard isSuccess else {
                print("Ошибка при попытке записи в keychain")
                return
            }
        }
    }
    
    func deleteTokenFromKeyChain() {
        keychain.removeObject(forKey: bearerTokenKey)
    }
}
