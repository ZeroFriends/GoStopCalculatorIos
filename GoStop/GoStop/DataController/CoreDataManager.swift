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
    
    func getAllMainPageHistories() -> [MainPageHistory] {
        let fetchRequest: NSFetchRequest<MainPageHistory> = MainPageHistory.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func saveMainPageHistory() {
        let mainPageHistory = MainPageHistory(context: persistentContainer.viewContext)
        
        mainPageHistory.historyName = "Test"
        mainPageHistory.date = Date()
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("mainPageHistory save error \(error)")
        }
    }
    
    func deleteMainPageHistory(mainPageHistory: MainPageHistory) {
        persistentContainer.viewContext.delete(mainPageHistory)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
}
