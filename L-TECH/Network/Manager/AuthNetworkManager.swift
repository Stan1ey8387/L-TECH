//
//  AuthNetworkManager.swift
//  L-TECH
//
//  Created by Захар Бабкин on 22/05/2018.
//  Copyright © 2018 Захар Бабкин. All rights reserved.
//

import Foundation

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    case badConnect = "Please check your network connection."
    case badParam = "Param is not found."
    case badAuth = "User is not found."
}

enum Result<String>{
    case success
    case failure(String)
}

struct AuthNetworkManager {
    
    let router = Router<AuthEndPoint>()
    
    static let shared = AuthNetworkManager()
    
    func getPhoneMask(completion: @escaping(_ phoneMask: PhoneMaskResponse?, _ error: String?) -> ()){
        router.request(.getPhoneMask) { (data, response, error) in
            guard error == nil else { completion(nil, NetworkResponse.badConnect.rawValue); return }
            guard let response = response as? HTTPURLResponse else { completion(nil, "Fail create response"); return }
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                guard let responseData = data else { completion(nil, NetworkResponse.noData.rawValue); return }
                do {
                    let apiResponse = try JSONDecoder().decode(PhoneMaskResponse.self, from: responseData)
                    completion(apiResponse,nil)
                }catch {
                    completion(nil, NetworkResponse.unableToDecode.rawValue)
                }
            case .failure(let networkFailureError):
                completion(nil, networkFailureError)
            }
        }
    }
    
    func auth(phone: Int, password: String, completion: @escaping(_ phoneMask: AuthResponse?, _ error: String?) -> ()){
        router.request(.auth(phone: phone, password: password)) { (data, response, error) in
            guard error == nil else { completion(nil, NetworkResponse.badConnect.rawValue); return }
            guard let response = response as? HTTPURLResponse else { completion(nil, "Fail create response"); return }
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                guard let responseData = data else { completion(nil, NetworkResponse.noData.rawValue); return }
                do {
                    let apiResponse = try JSONDecoder().decode(AuthResponse.self, from: responseData)
                    if apiResponse.success == false {
                        completion(nil,NetworkResponse.badParam.rawValue)
                    } else {
                        completion(apiResponse,nil)
                    }
                }catch {
                    completion(nil, NetworkResponse.unableToDecode.rawValue)
                }
            case .failure(let networkFailureError):
                completion(nil, networkFailureError)
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        print("response.statusCode = \(response.statusCode)")
        switch response.statusCode {
        case 200...299: return .success
        case 400: return .failure(NetworkResponse.badParam.rawValue)
        case 401: return .failure(NetworkResponse.badAuth.rawValue)
        case 402...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
