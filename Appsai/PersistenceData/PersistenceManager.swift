//
//  PersistenceManager.swift
//  Appsai
//
//  Created by Henrikas J on 13/05/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

import Foundation
import CoreData

final class PersistenceManager{
    
    private init(){}
    static let shared = PersistenceManager()
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "DataModel")
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
    
    lazy var context = persistentContainer.viewContext

    // MARK: - Core Data Saving support

    func saveContext () {
        print("Trying To Save")
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("SAVED SUCCESSFULLY")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                print("SAVED FAILED")
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }else{
            print("NO CHANGES")
        }
    }
    
    func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T]{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: objectType))
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]()
        } catch {
            print(error)
            return [T]()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        context.delete(object)
        saveContext()
    }
}
