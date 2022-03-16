//
//  CoreDataManager.swift
//  GoStop
//
//  Created by 이태현 on 2022/03/17.
//

import CoreData
import Foundation

class CoreDataManager{
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "DataModel")
        
        persistentContainer.loadPersistentStores { (decription, error) in
            if let error = error {
                fatalError("Core Data Store failed \(error.localizedDescription)")
            }
        }
    }
    
    
    
}
