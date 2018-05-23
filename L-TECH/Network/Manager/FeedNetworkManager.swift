//
//  FeedNetworkManager.swift
//  L-TECH
//
//  Created by Захар Бабкин on 22/05/2018.
//  Copyright © 2018 Захар Бабкин. All rights reserved.
//

import Foundation


struct FeedNetworkManager {
    
    let router = Router<FeedEndPoint>()
    
    static let shared = FeedNetworkManager()
    
    func getFeed(completion: @escaping(_ feed: [FeedElement]?, _ error: String?) -> ()){
        router.request(.getFeed) { (data, response, error) in
            guard error == nil else { completion(nil, NetworkResponse.badConnect.rawValue); return }
            guard let response = response as? HTTPURLResponse else { completion(nil, "Fail create response"); return }
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                guard let responseData = data else { completion(nil, NetworkResponse.noData.rawValue); return }
                do {
                    let apiResponse = try JSONDecoder().decode([FeedElement].self, from: responseData)
                    completion(apiResponse,nil)
                }catch {
                    completion(nil, NetworkResponse.unableToDecode.rawValue)
                }
            case .failure(let networkFailureError):
                completion(nil, networkFailureError)
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
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
