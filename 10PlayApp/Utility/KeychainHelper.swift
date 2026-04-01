//
//  KeychainHelper.swift
//  10PlayApp
//
//  Created by savan soni on 31/03/26.
//

import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()
    private init() {}
    
    private let service = Bundle.main.bundleIdentifier ?? "com.savansoni.10playapp"

    // Updated to use KeychainKeys enum
    func save(_ value: String, for key: KeychainKeys) {
        guard let data = value.data(using: .utf8) else { return }
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key.rawValue,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query)
        let status = SecItemAdd(query, nil)
        
        if status == errSecSuccess {
            print("✅ Saved to Keychain: \(key.rawValue)")
        }
    }

    func read(for key: KeychainKeys) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key.rawValue,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)

        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func delete(for key: KeychainKeys) {
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key.rawValue
        ] as CFDictionary
        
        SecItemDelete(query)
    }
}
