//
//  BookDB+CoreDataProperties.swift
//  jinyAssessment
//
//  Created by Jothi on 23/07/19.
//  Copyright © 2019 Widas. All rights reserved.
//
//

import Foundation
import CoreData


extension BookDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookDB> {
        return NSFetchRequest<BookDB>(entityName: "BookDB")
    }

    @NSManaged public var author_country: String?
    @NSManaged public var author_name: String?
    @NSManaged public var book_title: String?
    @NSManaged public var deletedBook: Bool
    @NSManaged public var favouriteBook: Bool
    @NSManaged public var genre: String?
    @NSManaged public var id: String?
    @NSManaged public var image_url: String?
    @NSManaged public var publisher: String?
    @NSManaged public var sold_count: Int64
    
    func setAttributesFrom(entity : BookDetailsEntity,with context:NSManagedObjectContext) {
        
        self.book_title = entity.book_title
        self.author_country = entity.author_country
        self.author_name = entity.author_name
        self.genre = entity.genre
        self.id = entity.id
        self.publisher = entity.publisher
        self.image_url = entity.image_url
        self.sold_count = entity.sold_count
        self.deletedBook = entity.deletedBook
        self.favouriteBook = entity.favouriteBook
    }
}
