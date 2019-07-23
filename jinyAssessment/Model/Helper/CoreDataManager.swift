//
//  CoreDataManager.swift
//  jinyAssessment
//
//  Created by Jothi on 23/07/19.
//  Copyright © 2019 Widas. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.widas.carbookPlus" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "jinyAssessment", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption:true,NSInferMappingModelAutomaticallyOption:true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            //dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            //            abort()
        }
        
        return coordinator
    }()
    func getManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        managedObjectContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
        return managedObjectContext
    }
    
    lazy var masterManagedObjectContext: NSManagedObjectContext = {
        let coordinator: NSPersistentStoreCoordinator?  = self.persistentStoreCoordinator
        let managedObjectContext                        = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext    = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = self.masterManagedObjectContext
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
      
        return managedObjectContext
    }()
    func workerContext() -> NSManagedObjectContext {
        let tempMOContext         = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        tempMOContext.parent      = self.mainManagedObjectContext
        tempMOContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return tempMOContext
    }
    func saveTempContext(_ context: NSManagedObjectContext) {
        var isError = false
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            isError = true
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        if !isError {
            saveMainContext()
        }
    }
    func saveMainContext() {
        var isError = false
        self.mainManagedObjectContext.perform({
            do {
                try self.mainManagedObjectContext.save()
            } catch {
                let nserror = error as NSError
                isError = true
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            if !isError {
                //Write to disk after saving on the main UI context
                self.saveMasterContext()
            }
        })
    }
    func saveMasterContext() {
        var isError = false
        self.masterManagedObjectContext.perform({
            do {
                try self.masterManagedObjectContext.save()
            } catch {
                let nserror = error as NSError
                isError = true
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        })
    }
    
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "jinyAssessment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
