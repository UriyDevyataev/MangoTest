//
//  NetworkService.swift
//  MangoTest
//
//  Created by Юрий Девятаев on 03.12.2022.
//

import Foundation

protocol NetworkService {
    func getAuthCode(for phone: String,
                     completion: @escaping (Result<SendAuthCodeModel, Error>) -> Void)
    func checkAuthCode(for phone: String,
                       code: String,
                       completion: @escaping (Result<CheckAuthCodeModel, Error>) -> Void)
    func registration(for phone: String,
                      name: String,
                      username: String,
                      completion: @escaping (Result<RegisterModel, Error>) -> Void)
    func getMe(_ token: String,
               completion: @escaping (Result<GetMeModel, Error>) -> Void)
    func putMe(_ token: String,
               parameters: [String: Any],
               completion: @escaping (Result<PutMeModel, Error>) -> Void)
    
    func refreshTokenIfNeeded(_ accessToken: String,
                              refreshToken: String,
                              completion: @escaping (Result<RegisterModel, Error>) -> Void)
}

enum Errors: Error {
    case invalidUrl
    case invalidState
    case invalidBody
    case jwtNotValid
}

final class NetworkServiceImp: NetworkService {
    
    static let shared: NetworkService = NetworkServiceImp()
    
    private enum APIPost {
        static let register = "https://plannerok.ru/api/v1/users/register/"
        static let sendCode = "https://plannerok.ru/api/v1/users/send-auth-code/"
        static let checkCode = "https://plannerok.ru/api/v1/users/check-auth-code/"
        static let refreshToken = "https://plannerok.ru/api/v1/users/refresh-token/"
    }
    
    private enum APIGet {
        static let getMe = "https://plannerok.ru/api/v1/users/me/"
        static let checkJwt = "https://plannerok.ru/api/v1/users/check-jwt/"
    }
    
    private enum APIPut {
        static let putMe = "https://plannerok.ru/api/v1/users/me/"
    }
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(urlSession: URLSession = .shared, jsonDecoder: JSONDecoder = .init()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    func getAuthCode(for phone: String, completion: @escaping (Result<SendAuthCodeModel, Error>) -> Void) {
        
        guard let url = URL(string: APIPost.sendCode) else {
            completion(.failure(Errors.invalidUrl))
            return
        }
        
        let parameters: [String: Any] = [
            "phone": phone
        ]
        
        let request = createRequest(with: url, body: parameters, httpMethod: "POST")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, _, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let model = try jsonDecoder.decode(SendAuthCodeModel.self, from: data)
                    completion(.success(model))
                } catch {
                    let err = self.parseError(data)
                    completion(.failure(err))
                }
            case let (nil, .some(error)):
                completion(.failure(error))
            default:
                completion(.failure(Errors.invalidState))
            }
        }
        task.resume()
    }
    
    func checkAuthCode(for phone: String,
                       code: String,
                       completion: @escaping (Result<CheckAuthCodeModel, Error>) -> Void) {
        
        guard let url = URL(string: APIPost.checkCode) else {
            completion(.failure(Errors.invalidUrl))
            return
        }
        
        let parameters: [String: Any] = [
            "phone": phone,
            "code": code
        ]
        
        let request = createRequest(with: url, body: parameters, httpMethod: "POST")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, _, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let model = try jsonDecoder.decode(CheckAuthCodeModel.self, from: data)
                    completion(.success(model))
                } catch {
                    let err = self.parseError(data)
                    completion(.failure(err))
                }
                
            case let (nil, .some(error)):
                completion(.failure(error))
            default:
                completion(.failure(Errors.invalidState))
            }
        }
        task.resume()
    }
    
    func registration(for phone: String,
                      name: String,
                      username: String,
                      completion: @escaping (Result<RegisterModel, Error>) -> Void) {
        
        guard let url = URL(string: APIPost.register) else {
            completion(.failure(Errors.invalidUrl))
            return
        }
        
        let parameters: [String: Any] = [
            "phone": phone,
            "name": name,
            "username": username
        ]
        
        let request = createRequest(with: url, body: parameters, httpMethod: "POST")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, _, error in
            
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let model = try jsonDecoder.decode(RegisterModel.self, from: data)
                    completion(.success(model))
                } catch {
                    let err = self.parseError(data)
                    completion(.failure(err))
                }
                
            case let (nil, .some(error)):
                completion(.failure(error))
            default:
                completion(.failure(Errors.invalidState))
            }
        }
        task.resume()
    }
    
    func getMe(_ token: String,
               completion: @escaping (Result<GetMeModel, Error>) -> Void) {
        
        guard let url = URL(string: APIGet.getMe) else {
            completion(.failure(Errors.invalidUrl))
            return
        }
        
        let request = createRequestWithHeader(with: url, token: token, httpMethod: "GET")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, _, error in
            
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let model = try jsonDecoder.decode(GetMeModel.self, from: data)
                    completion(.success(model))
                } catch {
                    let err = self.parseError(data)
                    completion(.failure(err))
                }
                
            case let (nil, .some(error)):
                completion(.failure(error))
            default:
                completion(.failure(Errors.invalidState))
            }
        }
        task.resume()
    }
    
    func putMe(_ token: String,
               parameters: [String: Any],
               completion: @escaping (Result<PutMeModel, Error>) -> Void) {
        
        guard let url = URL(string: APIPut.putMe) else {
            completion(.failure(Errors.invalidUrl))
            return
        }
        
        var request = createRequest(with: url, body: parameters, httpMethod: "PUT")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, _, error in
            
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let model = try jsonDecoder.decode(PutMeModel.self, from: data)
                    completion(.success(model))
                } catch {
                    let err = self.parseError(data)
                    completion(.failure(err))
                }
                
            case let (nil, .some(error)):
                completion(.failure(error))
            default:
                completion(.failure(Errors.invalidState))
            }
        }
        task.resume()
    }
    
    func refreshTokenIfNeeded(_ accessToken: String,
                              refreshToken: String,
                              completion: @escaping (Result<RegisterModel, Error>) -> Void) {
        
        checkJWT(accessToken) { result in
            
            switch result {
            case .success:
                let updateModel = RegisterModel(
                    refresh_token: refreshToken,
                    access_token: accessToken,
                    user_id: nil)
                completion(.success(updateModel))
                
            case let .failure(error):
                if error as? Errors == .jwtNotValid {
                    self.refreshToken(refreshToken) { result in
                        switch result {
                        case let .success(model):
                            completion(.success(model))
                        case let .failure(error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
}

// MARK: - Check JWT and Refresh token
extension NetworkServiceImp {
    
    private func checkJWT(_ token: String,
                          completion: @escaping (Result<CheckJWTModel, Error>) -> Void) {
        
        guard let url = URL(string: APIGet.checkJwt) else {
            completion(.failure(Errors.invalidUrl))
            return
        }
        
        let request = createRequestWithHeader(with: url, token: token, httpMethod: "GET")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 401 {
                completion(.failure(Errors.jwtNotValid))
                return
            }
            
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let model = try jsonDecoder.decode(CheckJWTModel.self, from: data)
                    if model.is_valid, !model.errors {
                        completion(.success(model))
                    } else {
                        completion(.failure(Errors.jwtNotValid))
                    }
                } catch {
                    let err = self.parseError(data)
                    completion(.failure(err))
                }
            case let (nil, .some(error)):
                completion(.failure(error))
            default:
                completion(.failure(Errors.invalidState))
            }
        }
        task.resume()
    }
    
    private func refreshToken(_ refreshToken: String,
                              completion: @escaping (Result<RegisterModel, Error>) -> Void) {
        
        guard let url = URL(string: APIPost.refreshToken) else {
            completion(.failure(Errors.invalidUrl))
            return
        }
        
        let parameters: [String: Any] = [
            "refresh_token": refreshToken
        ]
        
        let request = createRequest(with: url, body: parameters, httpMethod: "POST")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, _, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let model = try jsonDecoder.decode(RegisterModel.self, from: data)
                    completion(.success(model))
                } catch {
                    let err = self.parseError(data)
                    completion(.failure(err))
                }
                
            case let (nil, .some(error)):
                completion(.failure(error))
            default:
                completion(.failure(Errors.invalidState))
            }
        }
        task.resume()
    }
}

// MARK: - Create Request
extension NetworkServiceImp {
    
    private func createRequest(with url: URL, body: [String: Any], httpMethod: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func createRequestWithHeader(with url: URL, token: String, httpMethod: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

// MARK: - Parse error
extension NetworkServiceImp {
    private func parseError(_ data: Data) -> Error {
        if let model = try? jsonDecoder.decode(ResponseErrorOne.self, from: data) {
            return NSError(domain: model.detail[0].msg, code: 404, userInfo: nil)
        } else if let model = try? jsonDecoder.decode(ResponseErrorTwo.self, from: data) {
            return NSError(domain: model.detail.message, code: 404, userInfo: nil)
        } else if let model = try? jsonDecoder.decode(ResponseErrorThree.self, from: data) {
            return NSError(domain: model.detail, code: 404, userInfo: nil)
        }
        return NSError(domain: "unknown".localized, code: 404, userInfo: nil)
    }
}

// let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
//    if let responseJSON = responseJSON as? [String: Any] {
//        print(responseJSON)
//    }
