//
//  OAuth2TokenStorage.swift
//  setupProject
//
//  Created by Илья Дышлюк on 02.05.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "OAuth2AccessToken"

    var token: String? {
        get {
            // Извлечение токена из Keychain
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            // Сохранение токена в Keychain
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: tokenKey)
            } else {
                // Если токен равен nil, удаляем его из Keychain
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            }
        }
    }
}
