//
//  User.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 04.12.2022.
//

import Foundation
import KeychainAccess

struct Token: Codable {
    let refreshToken: String?
    let accessToken: String?
}

struct Profile: Codable {
    let name: String?
    let username: String?
    let birthday: String?
    let city: String?
    let vk: String?
    let instagram: String?
    let status: String?
    let avatar: String?
    let created: String?
    let phone: String?
    let id: Int?
    
    let zodiac: String?
    let about: String?
    
    let bigAvatar: String?
    let miniAvatar: String?
}

final class User {
    
    static let shared = User()
    
    private let networkService = NetworkServiceImp.shared
    
    let key = "profile_info"
    let keyProtected = "profile_protected"
    
    var refreshToken: String? {
        didSet {
            if refreshToken == nil {
                print()
            }
        }
    }
    var accessToken: String?
    
    var name: String?
    var username: String?
    var birthday: String?
    var city: String?
    var vk: String?
    var instagram: String?
    var status: String?
    var avatar: String?
    var created: String?
    var phone: String?
    var id: Int?
    
    var zodiac: String?
    var about: String?
    
    var bigAvatar: String?
    var miniAvatar: String?
    
    init() {
        if let profile = load() {
            self.name = profile.name
            self.username = profile.username
            self.birthday = profile.birthday
            self.city = profile.city
            self.vk = profile.vk
            self.instagram = profile.instagram
            self.status = profile.status
            self.avatar = profile.avatar
            self.created = profile.created
            self.phone = profile.phone
            self.id = profile.id
            
            self.zodiac = profile.zodiac
            self.about = profile.about
        }
        
        if let token = loadProtectedData() {
            print(token)
            self.accessToken = token.accessToken
            self.refreshToken = token.refreshToken
        }
    }
    
    private func load() -> Profile? {
        let decoder = JSONDecoder()
        guard
            let data = UserDefaults.standard.value(forKey: key) as? Data,
            let profile = try? decoder.decode(Profile.self, from: data)
        else { return nil }
        
        return profile
    }
    
    private func loadProtectedData() -> Token? {
        let decoder = JSONDecoder()
        let storage = Keychain().accessibility(.whenUnlocked)
        
        guard
            let data = try? storage.getData(keyProtected),
            let token = try? decoder.decode(Token.self, from: data)
        else { return nil }
        
        return token
    }
    
    func save(completion: ((Bool) -> Void)? = nil) {
        saveLocal()
        saveServer { result in
            completion?(result)
        }
    }
    
    func saveLocal() {
        let encoder = JSONEncoder()
        
        let profile = Profile(
            name: name,
            username: username,
            birthday: birthday,
            city: city,
            vk: vk,
            instagram: instagram,
            status: status,
            avatar: avatar,
            created: created,
            phone: phone,
            id: id,
            zodiac: zodiac,
            about: about,
            bigAvatar: bigAvatar,
            miniAvatar: miniAvatar)
        
        if let data = try? encoder.encode(profile) {
            UserDefaults.standard.set(data, forKey: key)
        }
        
        let token = Token(
            refreshToken: refreshToken,
            accessToken: accessToken)
        
        if let protectetData = try? encoder.encode(token) {
            let storage = Keychain().accessibility(.always)
            try? storage.set(protectetData, key: keyProtected)
        }
    }
}

extension User {
    
    private func saveServer(completion: @escaping ((Bool) -> Void)) {
    
        guard
            let accessToken = accessToken,
            let refreshToken = refreshToken
        else { return }
        
        networkService.refreshTokenIfNeeded(accessToken, refreshToken: refreshToken) { result in
            switch result {
            case let .success(model):
                self.accessToken = model.access_token
                self.refreshToken = model.refresh_token
                self.saveLocal()
                
                self.putMe { result in
                    completion(result)
                }
                
            case let .failure(error):
                AlertHelper.showErrorAlert(error)
            }
        }
    }
    
    private func putMe(completion: @escaping ((Bool) -> Void)) {
        let avatarJson: [String: Any] = [
            "filename": "avatar",
            "base_64": avatar ?? ""
        ]
        
        let parameters: [String: Any] = [
            "name": name as Any,
            "username": username as Any,
            "birthday": birthday as Any,
            "city": city as Any,
            "vk": vk as Any,
            "instagram": instagram as Any,
            "status": status as Any,
            "avatar": avatarJson
        ]
        
        networkService.putMe(accessToken ?? "", parameters: parameters) { result in
            switch result {
            case let .success(model):
                self.bigAvatar = model.avatars?.bigAvatar
                self.bigAvatar = model.avatars?.miniAvatar
                self.saveLocal()
                completion(true)
            case let .failure(error):
                completion(false)
                AlertHelper.showErrorAlert(error)
            }
        }
    }
}
