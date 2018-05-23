//
//  AuthEndPoint.swift
//  L-TECH
//
//  Created by Захар Бабкин on 22/05/2018.
//  Copyright © 2018 Захар Бабкин. All rights reserved.
//

import Foundation


public enum AuthEndPoint{
    case getPhoneMask
    case auth(phone: Int, password: String)
}

extension AuthEndPoint: EndPointType{
    
    var baseURL: URL {
        guard let url = URL(string: "http://dev-exam.l-tech.ru/") else {fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .getPhoneMask: return "phoneMask.php"
        case .auth: return "auth.php"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getPhoneMask: return .get
        case .auth: return .post
        }
    }
    
    var task: HTTPTask {
        
        switch self {
        case .getPhoneMask: return .request
        case .auth(let phone, let password):
            let param: Parameters = ["phone": phone, "password": password]
            return .requestParametersAndHeaders(bodyParameters: param, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: headers)
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getPhoneMask: return nil
        case .auth:
            let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
            return headers
        }
    }
}
