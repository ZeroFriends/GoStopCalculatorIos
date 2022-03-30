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
    
    func saveMainPageHistory(players: [String], historyName: String, jumDang: String, ppuck: String, firstTadack: String, sell: String) {
        let mainPageHistory = MainPageHistory(context: persistentContainer.viewContext)
        
        var mainPageHistoryName: String
        if historyName.isEmpty {
            let nowDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY.MM.dd"
            mainPageHistoryName = dateFormatter.string(from: nowDate)
        } else {
            mainPageHistoryName = historyName
        }
        mainPageHistory.historyName = mainPageHistoryName
        
        for i in players.indices {
            let player = Player(context: persistentContainer.viewContext)
            player.name = players[i]
            mainPageHistory.addToPlayer(player)
        }
        mainPageHistory.rule = Rule(context: persistentContainer.viewContext)
        mainPageHistory.rule?.jumDang = Int32(jumDang) ?? 0
        mainPageHistory.rule?.ppuck = Int32(ppuck) ?? 0
        mainPageHistory.rule?.firstTadack = Int32(firstTadack) ?? 0
        mainPageHistory.rule?.jumDang = Int32(jumDang) ?? 0
        
        do {
            try persistentContainer.viewContext.save()

            print(mainPageHistory.rule)
        } catch {
            print("Failed \(error)")
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
