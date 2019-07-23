//
//  BookDetailsEntity.swift
//  jinyAssessment
//
//  Created by Jothi on 23/07/19.
//  Copyright © 2019 Widas. All rights reserved.
//

import Foundation
struct BookDetailsEntity: Codable {
    
    var id: String = ""
    var book_title: String = ""
    var author_name: String = ""
    var genre: String = ""
    var publisher: String = ""
    var author_country: String = ""
    var sold_count: Int64 = 0
    var image_url: String = ""
    var favouriteBook : Bool = false
    var deletedBook : Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case id, book_title, author_name, genre, publisher, author_country, sold_count, image_url,favouriteBook,deletedBook
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.book_title = try container.decode(String.self, forKey: .book_title)
        self.author_name = try container.decode(String.self, forKey: .author_name)
        self.genre = try container.decode(String.self, forKey: .genre)
        self.publisher = try container.decode(String.self, forKey: .publisher)
        self.author_country = try container.decode(String.self, forKey: .author_country)
        self.sold_count = try container.decode(Int64.self, forKey: .sold_count)
        self.image_url = try container.decode(String.self, forKey: .image_url)
        //        self.favouriteBook = try container.decode(Bool.self, forKey: .favouriteBook)
        //        self.deletedBook = try container.decode(Bool.self, forKey: .deletedBook)
    }
    
}


enum FilterType: String {
    
    case country = "COUNTRY"
    case author = "AUTHOR"
    case genre = "GENRE"
    
    static let allValues = [country, author, genre]
}
