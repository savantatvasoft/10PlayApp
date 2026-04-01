//
//  AppConstants.swift
//  10PlayApp
//
//  Created by savan soni on 31/03/26.
//

import Foundation


struct APIConfig {
    
    static let baseURL = "http://app.10play.io/api/mobile"
    
    struct Endpoints {
        static let login = "/login"
        static let forgotPassword = "/forgot-password"
        static let userBiometric = "/biometric-login"
    }
}

enum KeychainKeys: String {
    case apiKey = "kKEY_APIKEY_PREFS"
    case userId = "kKEY_USERID"
}

enum UserDefaultKeys: String {
    case isBiometricEnabled = "kKEY_IS_BIOMETRIC_ENABLED"
    case hasAskedBiometric = "hasAskedBiometric"
    case userEmail = "kKEY_SAVED_EMAIL"
}

