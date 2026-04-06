//
//  UserManager.swift
//  10PlayApp
//
//  Created by savan soni on 06/04/26.
//

import Foundation
import Combine

class UserManager: ObservableObject {
    
    static let shared = UserManager()
    
    @Published var currentUser: UserData?
    @Published var isLoggedIn: Bool = false
    
    private init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "kKEY_LOGIN_PREFS")
    }
    
    func login(user: UserData) {
        self.currentUser = user
        self.isLoggedIn = true
        UserDefaults.standard.set(true, forKey: "kKEY_LOGIN_PREFS")
        KeychainHelper.shared.save(user.token, for: .apiKey)
        
        // MARK: Save UserID for future Biometric logins
        KeychainHelper.shared.save("\(user.idUser)", for: .userId)
    }
    
    func logout() {
        self.currentUser = nil
        self.isLoggedIn = false
        
        UserDefaults.standard.set(false, forKey: "kKEY_LOGIN_PREFS")
        KeychainHelper.shared.delete(for: .apiKey)
        
        // MARK: DO NOT delete .userId here so Biometrics still work next time
        print("User logged out. Session cleared, Identity preserved.")
    }
    
}
