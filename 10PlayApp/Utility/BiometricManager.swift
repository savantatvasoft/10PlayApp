//
//  BiometricManager.swift
//  10PlayApp
//
//  Created by savan soni on 01/04/26.
//

import Foundation
import LocalAuthentication

class BiometricManager {
    
    static let shared = BiometricManager()
    private init() {}
    
    // Updated to check for both Biometrics AND Passcode
    var canAuthenticate: Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
    }
    
    var biometryType: LABiometryType {
        let context = LAContext()
        _ = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        return context.biometryType
    }

    func authenticate(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        // Use .deviceOwnerAuthentication to enable the "Enter Passcode" fallback button
        let policy = LAPolicy.deviceOwnerAuthentication
        
        if context.canEvaluatePolicy(policy, error: &error) {
            let reason = "Identify yourself to log in to 10Play.io"
            
            context.evaluatePolicy(policy, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        let message = self.evaluateAuthenticationError(authError as? LAError)
                        completion(false, message)
                    }
                }
            }
        } else {
            let message = self.evaluateAuthenticationError(error as? LAError)
            completion(false, message)
        }
    }
    
    private func evaluateAuthenticationError(_ error: LAError?) -> String {
        guard let error = error else { return "An unknown error occurred." }
        
        switch error.code {
        case .authenticationFailed:
            return "Identity not verified. Please try again."
        case .userCancel:
            return "Authentication cancelled."
        case .userFallback:
            // This triggers if you want to manually show a custom password field
            return "Please use your device passcode."
        case .biometryNotAvailable:
            return "Biometric sensor is not available."
        case .biometryNotEnrolled:
            return "No Face ID or Touch ID is enrolled."
        case .biometryLockout:
            // The system will now automatically prompt for Passcode to unlock Biometrics
            return "Face ID is locked. Please use your device passcode."
        case .passcodeNotSet:
            return "No passcode is set on this device."
        default:
            return "Authentication failed."
        }
    }
}
