//
//  AuthenticationVM.swift
//  10PlayApp
//
//  Created by savan soni on 31/03/26.
//

import Foundation
import Combine

class AuthenticationVM {
    
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var errorMessage: String? = nil
    
    let loginTrigger = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupValidation()
    }
    
    private func setupValidation() {
        
        loginTrigger
            .map { [weak self] _ -> String? in
                guard let self = self else { return nil }
                
                if self.emailText.isEmpty && self.passwordText.isEmpty {
                    return "Please enter your email address."
                }
                if !self.isValidEmail(self.emailText) {
                    return "Please enter valid email address."
                }
                if self.passwordText.isEmpty {
                    return "Please enter valid email password."
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
                return self.isValidEmail(email) && !password.isEmpty && password.count >= 6
            }
            .eraseToAnyPublisher()
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
}
