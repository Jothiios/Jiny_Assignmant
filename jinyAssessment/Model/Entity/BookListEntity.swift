//
//  BookListEntity.swift
//  jinyAssessment
//
//  Created by Jothi on 23/07/19.
//  Copyright © 2019 Widas. All rights reserved.
//

import Foundation

struct BookListEntity: Codable {
    
    var list: [BookDetailsEntity] = []
    
    private enum CodingKeys: String, CodingKey {
        case list
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        self.list = try container.decode([BookDetailsEntity].self, forKey: .list)
    }
}
