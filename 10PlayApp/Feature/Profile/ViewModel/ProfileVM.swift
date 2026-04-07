//
//  ProfileVM.swift
//  10PlayApp
//
//  Created by savan soni on 06/04/26.
//

import Foundation
import Combine

class ProfileVM: ObservableObject {
    
    // MARK: - Published Properties
    @Published var userData: UserData?
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var isLoading: Bool = false
    @Published var updateSuccess: Bool = false
    @Published var isDirectionalEnabled: Bool = true
    @Published var isBiometricEnabled: Bool = false
    
    var apiService: APIServiceProtocol = APIService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadUserData()
    }
    
    func loadUserData() {
        print("loadUserData")
        if let user = UserManager.shared.currentUser {
            self.userData = user
        } else {
            self.errorMessage = "Unable to load profile data."
        }
    }
    
    @MainActor
    func updateProfile(firstName: String, lastName: String, phone: String) async {
        self.isLoading = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        self.isLoading = false
        self.updateSuccess = true
    }
    
    @MainActor
    func updatePassword(current: String, new: String, confirm: String) async -> Bool {
        
        self.errorMessage = nil
        self.successMessage =  nil
        
        // 1. Basic Validation
        if current.isEmpty || new.isEmpty || confirm.isEmpty {
            self.errorMessage = "fields_empty_error".localized
            self.isLoading = false
            return false
        }
        
        // 2. Verify Current Password against Keychain
        let storedPassword = KeychainHelper.shared.read(for: .userPassword)
        if current != storedPassword {
            self.errorMessage = "current_password_incorrect".localized
            self.isLoading = false
            return false
        }
       
        
        if new != confirm {
            self.errorMessage = "passwords_do_not_match".localized
            self.isLoading = false
            return false
        }
        
        // 4. Validate Strength (Optional but recommended)
        if new.count < 6 {
            self.errorMessage = "password_too_short".localized
            self.isLoading = false
            return false
        }
        
        guard let userIdString = KeychainHelper.shared.read(for: .userId),
                  let userId = Int(userIdString) else { return false }

        let body = UpdatePasswordRequest(idUser: userId, oldPassword: current, newPassword: new)

        self.isLoading = true
        let success = await performUpdate(endpoint: APIConfig.Endpoints.updatePassword, body: body)
            
        if success {
                KeychainHelper.shared.save(new, for: .userPassword)
        }
        self.isLoading = false
        return success
    }
    
//    @MainActor
//    func callUpdatePasswordAPI(new: String, old: String) async -> Bool {
//        
//        guard let storedUserString = KeychainHelper.shared.read(for: .userId),
//              let storedUserId = Int(storedUserString) else {
//            self.errorMessage = "Invalid user identification. Please log in again."
//            return false
//        }
//        
//        let body = UpdatePasswordRequest(
//            idUser: storedUserId,
//            oldPassword: old,
//            newPassword: new
//        )
//        
//        self.isLoading = true
//        self.errorMessage = nil
//        self.successMessage = nil
//        
//        do {
//            let response: ProfileSuccessResponse = try await apiService.put(
//                endpoint: APIConfig.Endpoints.updatePassword,
//                body: body
//            )
//            self.isLoading = false
//            
//            if response.result.state {
//                KeychainHelper.shared.save(new, for: .userPassword)
//                successMessage =  response.result.message
//            } else {
//                errorMessage =  response.result.message
//            }
//            
//            return response.result.state
//            
//        } catch {
//            self.handleError(error)
//            self.successMessage = nil
//            self.isLoading = false
//            return false
//        }
//    }
//
    
    @MainActor
    func updateProfile(nom: String, prenom: String, telephone: String, codePostal: String, email: String) async -> Bool {
        // 1. Reset State
        self.errorMessage = nil
        self.successMessage = nil
        
        // 2. Validation
        if nom.isEmpty || prenom.isEmpty || telephone.isEmpty || codePostal.isEmpty || email.isEmpty {
            self.errorMessage = "profile_field_empty_error".localized
            return false
        }
        
        // 3. Get User ID
        guard let userIdString = KeychainHelper.shared.read(for: .userId),
              let userId = Int(userIdString) else {
            self.errorMessage = "session_expired_error".localized
            return false
        }
        
        let body = UpdateProfileRequest(
            idUser: userId,
            nom: nom,
            prenom: prenom,
            telephone: telephone,
            codePostal: codePostal,
            login: email
        )
        
        // 5. Call Generic Helper
        let success = await performUpdate(
            method: "PUT",
            endpoint: APIConfig.Endpoints.updateUser,
            body: body
        )
            
        return success
    }
    
    @MainActor
    private func performUpdate<B: Encodable>(
        method: String = "PUT",
        endpoint: String,
        body: B
    ) async -> Bool {
        
        self.isLoading = true
        self.errorMessage = nil
        self.successMessage = nil
        
        do {
            let response: ProfileSuccessResponse = try await apiService.request(
                method: method,
                endpoint: endpoint,
                body: body
            )
            
            self.isLoading = false
            
            if response.result.state {
                self.successMessage = response.result.message
                return true
            } else {
                self.errorMessage = response.result.message
                return false
            }
            
        } catch {
            self.handleError(error)
            self.isLoading = false
            return false
        }
    }
    
    private func handleError(_ error: Error) {
        if let apiError = error as? APIError {
            self.errorMessage = apiError.errorMessage
        } else {
            self.errorMessage = error.localizedDescription
        }
    }
}
