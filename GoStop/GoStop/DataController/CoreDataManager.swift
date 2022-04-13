//
//  CoreDataManager.swift
//  GoStop
//
//  Created by 이태현 on 2022/03/17.
//

import CoreData
import Foundation

class CoreDataManager: ObservableObject {
    @Published var mainPageHistoryList: [MainPageHistory] = []
    @Published var roundList: [Round] = [] // 원하는 mainPageHistory의 round를 담는 배열 역할
    
    let persistentContainer = NSPersistentContainer(name: "DataModel")
    
    init() {
        persistentContainer.loadPersistentStores { (decription, error) in
            if let error = error {
                fatalError("Core Data Store failed \(error.localizedDescription)")
            }
        }
        fetchMainPageHistories()
    }
    
    func fetchMainPageHistories() {
        let request = NSFetchRequest<MainPageHistory>(entityName: "MainPageHistory")
        
        do {
            mainPageHistoryList = try persistentContainer.viewContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    //round fetch 함수 선언부
    
    //round를 생성할때 어떤 MainPageHistory 소속의 round인지를 파악하기 위해 id를 MainPageHistory랑 맞춰서 save 진행 예정
    
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
        mainPageHistory.date = Date()
        mainPageHistory.id = UUID()
        
        for i in players.indices {
            let player = Player(context: persistentContainer.viewContext)
            player.name = players[i]
            mainPageHistory.addToPlayer(player)
        }
        mainPageHistory.rule = Rule(context: persistentContainer.viewContext)
        mainPageHistory.rule?.jumDang = Int32(jumDang) ?? 0
        mainPageHistory.rule?.ppuck = Int32(ppuck) ?? 0
        mainPageHistory.rule?.firstTadack = Int32(firstTadack) ?? 0
        mainPageHistory.rule?.sell = Int32(sell) ?? 0
        
        do {
            try persistentContainer.viewContext.save()
            fetchMainPageHistories()
        } catch {
            print("Failed \(error)")
        }
        
    }
    
    func deleteMainPageHistory(mainPageHistory: MainPageHistory) {
        persistentContainer.viewContext.delete(mainPageHistory)
        
        do {
            try persistentContainer.viewContext.save()
            fetchMainPageHistories()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
}
