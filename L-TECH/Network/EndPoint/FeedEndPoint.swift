//
//  FeedEndPoint.swift
//  L-TECH
//
//  Created by Захар Бабкин on 22/05/2018.
//  Copyright © 2018 Захар Бабкин. All rights reserved.
//

import Foundation


public enum FeedEndPoint{
    case getFeed
}

extension FeedEndPoint: EndPointType{
    
    var baseURL: URL {
        guard let url = URL(string: "http://dev-exam.l-tech.ru") else {fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        return ""
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        return .request
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
