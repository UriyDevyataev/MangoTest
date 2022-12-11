//
//  MangoModel.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 03.12.2022.
//

import Foundation

// swiftlint: disable identifier_name

struct SendAuthCodeModel: Codable {
    let is_success: Bool
}

struct CheckAuthCodeModel: Codable {
    let refresh_token: String?
    let access_token: String?
    let user_id: Int?
    let is_user_exists: Bool
}

struct RegisterModel: Codable {
    let refresh_token: String?
    let access_token: String?
    let user_id: Int?
}

struct CheckJWTModel: Codable {
    let errors: Bool
    let is_valid: Bool
}

struct AvatarModel: Codable {
    let filename: String?
    let base_64: String?
}

struct PutMeModel: Codable {
    let avatars: AvatarsModel?
}

struct AvatarsModel: Codable {
    let avatar: String?
    let bigAvatar: String?
    let miniAvatar: String?
}

struct GetMeModel: Codable {
    let profile_data: ProfileData
    
    struct ProfileData: Codable {
        let name: String
        let username: String
        let birthday: String?
        let city: String?
        let vk: String?
        let instagram: String?
        let status: String?
        let avatar: String?
        let id: Int
        let last: String?
        let online: Bool
        let created: String
        let phone: String
        let avatars: AvatarsModel?
    }
}

struct ResponseErrorOne: Codable {
    let detail: [Detail]
    
    struct Detail: Codable {
        let loc: [String]
        let msg: String
        let type: String
    }
}

struct ResponseErrorTwo: Codable {
    let detail: Detail
    
    struct Detail: Codable {
        let message: String
    }
}

struct ResponseErrorThree: Codable {
    let detail: String
}
