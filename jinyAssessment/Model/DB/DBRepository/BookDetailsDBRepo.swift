//
//  BookDetailsDBRepo.swift
//  jinyAssessment
//
//  Created by Jothi on 23/07/19.
//  Copyright © 2019 Widas. All rights reserved.
//

import Foundation
import CoreData

class BookDetailsDBRepo {
    
    open func createOrUpdateBookList(_ bookDetail:BookDetailsEntity, contxt:NSManagedObjectContext?, callback:@escaping (Bool)->()) {
        
        let temp:NSManagedObjectContext?
        if contxt != nil{
            temp = contxt
        }else{
            temp = CoreDataManager.shared.workerContext()
        }
        
        let newInstance = BookDB.newInstance(temp!)
        
        temp?.perform({
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookDB")
            let predicate = NSPredicate(format: "id == %@",bookDetail.id)
            fetchRequest.predicate = predicate
            fetchRequest.fetchLimit = 1
            if let fetchResults = (try? temp!.fetch(fetchRequest)) as? [BookDB] {
                if(fetchResults.count > 0){
                    if let v = fetchResults.first{
                        v.setAttributesFrom(entity: bookDetail, with: temp!)
                    }
                }else {
                    newInstance.setAttributesFrom(entity: bookDetail, with: temp!)
                }
            }
            CoreDataManager.shared.saveTempContext(temp!)
            callback(true)
        })
    }
    
    open func bulkUpdateBookList(_  bookDetail:[BookDetailsEntity], context:NSManagedObjectContext?,callback:@escaping (Bool)->()) {
        
        var count = 0
        
        autoreleasepool(invoking: {
            
            for (_, book) in bookDetail.enumerated() {
                
                count += 1
                self.createOrUpdateBookList(book, contxt: CoreDataManager.shared.workerContext(), callback: { (res) in })
                if count == bookDetail.count {
                    DispatchQueue.main.async {
                        callback(true)
                    }
                }
            }
        })
    }
    
    
    open func updateBookList(_ type:String, query: String,deletedBook:Bool,favorite:Bool) {
        
        let context = CoreDataManager.shared.workerContext()
        
        context.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"BookDB")
            var predicate = NSPredicate(format: "book_title == %@",query)
            if type == FilterType.country.rawValue {
                predicate = NSPredicate(format: "author_country == %@",query)
            }else if type == FilterType.genre.rawValue {
                predicate = NSPredicate(format: "genre == %@",query)
            }
            else if type == FilterType.author.rawValue{
                predicate = NSPredicate(format: "author_name == %@",query)
            }
            fetchRequest.predicate = predicate
            
            if let fetchResults = (try? context.fetch(fetchRequest)) as? [BookDB] {
                if fetchResults.count > 0 {
                    for book in fetchResults
                    {
                        book.favouriteBook = favorite
                        book.deletedBook = deletedBook
                        CoreDataManager.shared.saveTempContext(context)
                    }
                    
                }
            }
        }
    }
    
    
    
    open func fetchBookList(_ type:String, query: String,deletedBook:Bool, callback:@escaping ([BookDetailsEntity])->()) {
        
        let context = CoreDataManager.shared.workerContext()
        
        context.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"BookDB")
            var predicate = NSPredicate(format: "book_title == %@ AND deletedBook == %@",query,NSNumber(value: deletedBook))
            if type == FilterType.country.rawValue {
                predicate = NSPredicate(format: "author_country == %@ AND deletedBook == %@",query,NSNumber(value: deletedBook))
            }else if type == FilterType.genre.rawValue {
                predicate = NSPredicate(format: "genre == %@ AND deletedBook == %@",query,NSNumber(value: deletedBook))
            }
            else if type == FilterType.author.rawValue{
                predicate = NSPredicate(format: "author_name == %@ AND deletedBook == %@",query,NSNumber(value: deletedBook))
            }
            else if type == ""{
                predicate = NSPredicate(format: "deletedBook == %@",NSNumber(value: deletedBook))
            }
            fetchRequest.predicate = predicate
            
            do {
                if let fetchResults = (try? context.fetch(fetchRequest)) as? [BookDB] {
                    if fetchResults.count > 0 {
                        callback(fetchResults.map({self.convertAttributes(entity: $0)}))
                    }else {
                        callback([])
                    }
                }
            }
        }
    }
    
    
    
    
    open func fetchBookDetailBy(_ id:String, callback:@escaping (BookDetailsEntity?)->()) {
        
        let context = CoreDataManager.shared.workerContext()
        
        context.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"BookDB")
            let predicate = NSPredicate(format: "id == %@",id)
            fetchRequest.predicate = predicate
            
            do {
                if let fetchResults = (try? context.fetch(fetchRequest)) as? [BookDB] {
                    if fetchResults.count > 0 {
                        callback(self.convertAttributes(entity: fetchResults.first!))
                    }else {
                        callback(nil)
                    }
                }
            }
        }
    }
    
    func deleteAllData() {
        let context = CoreDataManager.shared.workerContext()
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "BookDB")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    
    private func convertAttributes(entity:BookDB) -> BookDetailsEntity {
        var bookEntity = BookDetailsEntity()
        bookEntity.author_country = entity.author_country ?? ""
        bookEntity.author_name = entity.author_name ?? ""
        bookEntity.book_title = entity.book_title ?? ""
        bookEntity.genre = entity.genre ?? ""
        bookEntity.id = entity.id ?? ""
        bookEntity.image_url = entity.image_url ?? ""
        bookEntity.publisher = entity.publisher ?? ""
        bookEntity.sold_count = entity.sold_count
        bookEntity.deletedBook = entity.deletedBook
        bookEntity.favouriteBook = entity.favouriteBook
        return bookEntity
    }
}
