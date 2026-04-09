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
        static let updatePassword = "/update-password"
        static let updateUser = "/update-user"
    }
}

enum KeychainKeys: String {
    case apiKey = "kKEY_APIKEY_PREFS"
    case userId = "kKEY_USERID"
    case userPassword = "kKEY_MDP_PREFS"
}

enum UserDefaultKeys: String {
    case isBiometricEnabled = "kKEY_IS_BIOMETRIC_ENABLED"
    case hasAskedBiometric = "hasAskedBiometric"
    case userEmail = "kKEY_SAVED_EMAIL"
    case currentUserInfo = "kSAVED_USER_DATA"
    case isLoggedIn = "kKEY_LOGIN_PREFS"
}


enum NavigationKeys: String  {
    case filter = "navigateToFilter"
    case signals = "navigateToSignals"
    case filterMap = "FilterMapVC"
}
