//
//  AuthenticationModel.swift
//  10PlayApp
//
//  Created by savan soni on 31/03/26.
//

import Foundation


struct LoginRequest: Encodable {
    let login: String?
    let password: String?
    let UserId: String?
    
    static func manual(user: String, pass: String) -> LoginRequest {
        return LoginRequest(login: user, password: pass, UserId: nil)
    }
    
    static func biometric(id: String) -> LoginRequest {
        return LoginRequest(login: nil, password: nil, UserId: id)
    }
}

struct LoginResponse: Decodable {
    let result: LoginResult
    let user: UserData?
}

struct LoginResult: Decodable {
    let state: Bool
    let message: String
}

struct UserData: Codable {
    let idUser: Int
    let login: String
    let token: String
    let nom: String
    let prenom: String
    let telephone: String
    let rgpd: String
    let rgpdText: String?
    let fournisseur: Fournisseur

    enum CodingKeys: String, CodingKey {
        case idUser, login, nom, prenom, telephone, rgpd, fournisseur
        case token = "api_key"
        case rgpdText = "rgpd_text"
    }
}

struct Fournisseur: Codable {
    let idFournisseur: Int
    let nom: String
    let email: String
    let telephone: String
    let siret: String
}


struct ForgotPasswordRequest: Encodable {
    let login: String
}
