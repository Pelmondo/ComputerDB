//
//  JSONParser.swift
//  ComputerDB
//
//  Created by Сергей Прокопьев on 15.03.2020.
//  Copyright © 2020 PelmondoProd. All rights reserved.
//

import Foundation


struct Response: Decodable {
    let items: [Items]
    let page: Int
}

struct Items: Decodable {
    let id: Int
    let name: String
    let company: Company?
}

struct Company: Decodable {
    let id: Int?
    let name: String?
}

struct ComputerCard: Decodable {
    let id: Int
    let name: String
    let introduced: String?
    let discounted: String?
    let imageUrl: String?
    let company: Company?
    let description: String
}
