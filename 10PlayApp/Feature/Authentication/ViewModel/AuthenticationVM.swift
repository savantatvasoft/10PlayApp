//
//  AuthenticationVM.swift
//  10PlayApp
//
//  Created by savan soni on 31/03/26.
//

import Foundation
import Combine

class AuthenticationVM {
    
    // MARK: - Published Properties
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var success: String? = nil
    
    
    // MARK: - Dependency Injection
    var apiService: APIServiceProtocol = APIService.shared
    let loginTrigger = PassthroughSubject<Void, Never>()
    let biometricLoginResult = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupValidation()
    }
    
    // MARK: - Logic Setup
    private func setupValidation() {
        loginTrigger
            .map { [weak self] _ -> String? in
                guard let self = self else { return nil }
                
                if self.emailText.isEmpty && self.passwordText.isEmpty {
                    return "Please enter your email and password."
                }
                if !self.isValidEmail(self.emailText) {
                    return "Please enter a valid email address."
                }
                if self.passwordText.count < 6 {
                    return "Password must be at least 6 characters."
                }
                return nil
            }
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
        
        Publishers.Merge($emailText, $passwordText)
            .map { _ in nil }
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
    }
    
    var isLoginEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($emailText, $passwordText)
            .map { email, password in
                return self.isValidEmail(email) && password.count >= 6
            }
            .eraseToAnyPublisher()
    }
    
    @MainActor
    func performLogin(isBiometric: Bool = false) async -> Bool {
        let credentials: LoginRequest
        let endPoint = isBiometric ? APIConfig.Endpoints.userBiometric : APIConfig.Endpoints.login
        
        if isBiometric {
            guard let storedUserId = KeychainHelper.shared.read(for: .userId) else {
                self.errorMessage = "No user linked to biometrics."
                return false
            }
            credentials = .biometric(id: storedUserId)
        } else {
            credentials = .manual(user: emailText, pass: passwordText)
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            let response: LoginResponse = try await apiService.post(endpoint: endPoint, body: credentials)
            
            if response.result.state, let user = response.user {
                UserManager.shared.login(user: user)
                
                if isBiometric { self.biometricLoginResult.send(true) }
                self.isLoading = false
                return true
            } else {
                self.errorMessage = "Please enter valid email and password."
                self.isLoading = false
                return false
            }
        } catch {
            handleError(error)
            self.isLoading = false
            return false
        }
    }
    
    @MainActor
    func performForgotPassword(validEmail: String) async -> Bool {
        
        if !self.isValidEmail(validEmail) {
            self.errorMessage = "Please enter a valid email address."
            self.success = nil
            return false
        }
        let body = ForgotPasswordRequest(login: validEmail)
        self.isLoading = true
        self.errorMessage = nil
        self.success = nil
        
        do {
            let response: LoginResponse = try await apiService.post(
                endpoint: APIConfig.Endpoints.forgotPassword,
                body: body
            )
            
            if response.result.state {
                self.success = "A password reset link has been sent to \(validEmail)"
                self.errorMessage = nil
            } else {
                self.success = nil
                self.errorMessage = "The login does not exist"
            }
            
            self.isLoading = false
            return response.result.state
            
        } catch {
            handleError(error)
            self.success = nil
            self.isLoading = false
            return false
        }
    }
    
    func handleBiometricLogin() async {
        guard PreferenceManager.isHardwareReady else {
            self.errorMessage = "Biometrics not available or configured."
            return
        }
        
        BiometricManager.shared.authenticate { [weak self] success, error in
            guard let self = self else { return }
            if success {
                Task { await self.performLogin(isBiometric: true) }
            } else {
                self.errorMessage = error
            }
        }
    }
    
    private func handleError(_ error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .invalidURL:
                self.errorMessage = "There is an issue with the connection path."
                
            case .noData:
                self.errorMessage = "The server returned no information."
                
            case .decodingError:
                self.errorMessage = "We had trouble reading the data from the server."
                
            case .serverError(let code):
                self.errorMessage = "The server is having trouble (Error \(code))."
            }
        } else {
            self.errorMessage = "An unexpected error occurred. Please try again."
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
}
