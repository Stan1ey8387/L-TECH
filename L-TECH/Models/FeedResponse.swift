//
//  FeedResponse.swift
//  L-TECH
//
//  Created by Захар Бабкин on 22/05/2018.
//  Copyright © 2018 Захар Бабкин. All rights reserved.
//

import Foundation

struct FeedElement: Decodable {
    let id: Int?
    let title, text, image: String?
    let sort: Int?
    let date: String?
}
