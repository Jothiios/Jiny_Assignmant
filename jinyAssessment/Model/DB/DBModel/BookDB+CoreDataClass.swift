//
//  BookDB+CoreDataClass.swift
//  jinyAssessment
//
//  Created by Jothi on 23/07/19.
//  Copyright © 2019 Widas. All rights reserved.
//
//

import Foundation
import CoreData

@objc(BookDB)
public class BookDB: NSManagedObject {
    class func newInstance(_ context:NSManagedObjectContext) -> BookDB {
        return NSEntityDescription.insertNewObject(forEntityName: "BookDB", into: context) as! BookDB
    }
}
