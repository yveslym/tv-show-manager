//
//  CoreDataStack.swift
//  Tv show app
//
//  Created by Yveslym on 5/31/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation

import CoreData


class CoreDataStack {
    static var instance = CoreDataStack()
    
    private lazy var persistanceContainer: NSPersistentContainer = {
        let contenainer = NSPersistentContainer(name: "TVModel")
        contenainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError?{
                fatalError("Unresolved error \(error), \(error.userInfo)") // need to be change
            }
        })
        return contenainer
    }()
    
    lazy var viewContext:NSManagedObjectContext = {
        let context = persistanceContainer.viewContext
        return context
    }()
    
    lazy var privateContext: NSManagedObjectContext = {
        return persistanceContainer.newBackgroundContext()
    }()
    
    func saveTo(context: NSManagedObjectContext){
        if context.hasChanges{
            do{
                try context.save()
            }
            catch{
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                // need to change by the alert view
            }
        }
    }
    
    func delete(context: NSManagedObjectContext, item: NSManagedObject){
        context.delete(item)
        saveTo(context: context)
    }
    
    
    func fetchRecordsForEntity(_ entity: Entity, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
            
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }
    
}
enum Entity: String{
    case FavoriteTV
}
