//
//  PreferenceManager.swift
//  10PlayApp
//
//  Created by savan soni on 01/04/26.
//

import Foundation
import LocalAuthentication

struct PreferenceManager {
    
    // Keys defined in your logic
    private enum Keys: String {
        case isBiometricEnabled = "kKEY_IS_BIOMETRIC_ENABLED"
        case hasAskedBiometric = "hasAskedBiometric"
    }

    // Did the user accept the FaceID prompt on the Dashboard?
    static var isBiometricEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: Keys.isBiometricEnabled.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.isBiometricEnabled.rawValue) }
    }

    // Has the "Voulez-vous activer..." popup been shown yet?
    static var hasAskedBiometric: Bool {
        get { UserDefaults.standard.bool(forKey: Keys.hasAskedBiometric.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.hasAskedBiometric.rawValue) }
    }

    // Check if the device hardware is actually ready/enrolled
    static var isHardwareReady: Bool {
        let context = LAContext()
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
}
