//
//  NYCoreData.swift
//  mvoice-swift
//
//  Created by NY on 5/24/17.
//  Copyright © 2017 NY. All rights reserved.
//

import UIKit
import Foundation
import CoreData
let context = NSManagedObjectContext.init()

final class NYCoreData: NSObject {
    // Can't init is singleton
    private override init() {
        super.init()
    }
    
    // MARK: Shared Instance
    public static let shared = NYCoreData()
    
    // MARK: - Core Data stack
    private var managedObjectModel: NSManagedObjectModel {
        let url:URL = Bundle.main.url(forResource: "AudioModel", withExtension: "momd")!
        return NSManagedObjectModel.init(contentsOf: url)!
    }
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        let persistentStore = NSPersistentStoreCoordinator.init(managedObjectModel: managedObjectModel)
        let storeURL = FileManager.docPathURL().appendingPathComponent("AudioModel.sqlite")
        let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                       NSInferMappingModelAutomaticallyOption: true]
        
        do {
            try persistentStore.addPersistentStore(ofType: NSSQLiteStoreType,
                                                   configurationName: nil,
                                                   at: storeURL,
                                                   options: options)
        } catch  {
            assert(error.localizedDescription.utf8.count < 0, error.localizedDescription)
        }
        return persistentStore
    }
    private var managedObjectContext: NSManagedObjectContext {
        if context.persistentStoreCoordinator == nil {
            context.persistentStoreCoordinator = persistentStoreCoordinator
        }
        return context
    }
    
    public func saveContext()  {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                assert(error.localizedDescription.utf8.count < 0, error.localizedDescription)
            }
        }
    }
    
    // MARK: CRUD
    public func insert(entity:String, dictionary: Dictionary<String, Any>) {
        let object = NSEntityDescription.insertNewObject(forEntityName: entity, into: managedObjectContext)
        let keys = dictionary.keys
        
        for key in keys {
            let value = dictionary[key]
            object.setValue(value, forKey: key)
        }
        managedObjectContext.insert(object)
        saveContext()
    }
    
    func selectData(keys:Array<String>, entity:String, predicate: String, sortKey:String, ascending:Bool, limit:Int) -> Array<Any> {
        var results:Array<Any> = Array()
        
        let fetchRequest:NSFetchRequest = NSFetchRequest<NSManagedObject>.init(entityName: entity)
        if predicate.utf8.count > 0 {
            fetchRequest.predicate = NSPredicate.init(format:predicate)
        }
        if limit > 0 {
            fetchRequest.fetchLimit = limit
        }
        if sortKey.utf8.count > 0 {
            let sort = NSSortDescriptor.init(key: sortKey,
                                             ascending: ascending,
                                             selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
            fetchRequest.sortDescriptors = [sort]
        }
        
        do {
            let objects = try managedObjectContext.fetch(fetchRequest)
            for object in objects {
                results.append(resultDic(object: object))
            }
        } catch  {
            assert(error.localizedDescription.utf8.count < 0, error.localizedDescription)
        }
        return results
    }
    
    public func truncate() {
        deleteData(entity: entity, predicate:"")
    }
    
    public func deleteData(entity:String, predicate:String) {
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: entity)
        if predicate.utf8.count > 0 {
            request.predicate = NSPredicate.init(format: predicate)
        }
        do {
            let results:Array<NSManagedObject> = try managedObjectContext.fetch(request) as! Array<NSManagedObject>
            for object in results {
                context.delete(object)
            }
            saveContext()
        } catch  {
            assert(error.localizedDescription.utf8.count < 0, error.localizedDescription)
        }
    }
    
    
    public func updateData(entity:String, attributes:Array<String>, values:Array<Any>, predicate:String) {
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: entity)
        if predicate.utf8.count > 0 {
            request.predicate = NSPredicate.init(format: predicate)
            do {
                let results:Array<NSManagedObject> = try managedObjectContext.fetch(request) as! Array<NSManagedObject>
                
                for object in results {
                    let keys = object.entity.attributesByName.keys
                    
                    for i in 0 ..< attributes.count {
                        if keys.contains(attributes[i]) {
                            // ToDo: Any object
                            object.setValue(values[i], forKey: attributes[i])
                        }
                    }
                }
            } catch  {
                assert(error.localizedDescription.utf8.count < 0, error.localizedDescription)
            }
        }
    }
    
    // MARK: Helper
    private func resultDic(object:NSManagedObject) -> Dictionary<String, Any> {
        let keys = object.entity.attributesByName.keys
        var dictionary = Dictionary<String, Any>()
        
        for key in keys {
            dictionary[key] = object.value(forKey: key)
        }
        return dictionary
    }
    
}
