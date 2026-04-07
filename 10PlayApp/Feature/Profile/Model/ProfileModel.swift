//
//  ProfileModel.swift
//  10PlayApp
//
//  Created by savan soni on 06/04/26.
//

import Foundation

struct UpdatePasswordRequest: Encodable {
    let idUser: Int
    let oldPassword: String
    let newPassword: String
}

struct ProfileSuccessResponse: Codable {
    let result: ProfileResult
}

struct ProfileResult: Codable {
    let state: Bool
    let message: String
}

struct UpdateProfileRequest: Codable {
    let idUser: Int
    let nom: String
    let prenom: String
    let telephone: String
    let codePostal: String
    let login: String 
}
