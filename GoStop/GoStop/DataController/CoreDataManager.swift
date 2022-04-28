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
//    @Published var roundList: [Round] = [] // 원하는 mainPageHistory의 round를 담는 배열 역할
    
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
    
    func fetchRound(id: UUID) -> [Round] {
        let request = NSFetchRequest<Round>(entityName: "Round")
        
        do {
            return try persistentContainer.viewContext.fetch(request).filter { $0.id == id }
        } catch {
            return []
        }
    }
    
    func fetchPlayers(id: UUID) -> [Player] {
        let request = NSFetchRequest<Player>(entityName: "Player")
        
        do {
            return try persistentContainer.viewContext.fetch(request).filter { $0.id == id }
        } catch {
            return []
        }
    }
    
    func fetchSpecificPlayerTotalCost(id: UUID, name: String) -> Int32 {
        var ingamePlayer: [IngamePlayer] = []
        let request = NSFetchRequest<IngamePlayer>(entityName: "IngamePlayer")
        var sum: Int32 = 0
        
        do {
            ingamePlayer = try persistentContainer.viewContext.fetch(request).filter { $0.id == id }.filter { $0.name == name }
            for player in ingamePlayer {
                sum += player.totalCost
            }
            return sum
        } catch {
            return 0
        }
    }// 정산내역과 수익현황에 쓰이는 total
    
    func fetchSpecificPlayerToPlayerCost(mainName: String, enemyName: String, id: UUID) -> Int32 {
        var ingamePlayer: [IngamePlayer]
        let request = NSFetchRequest<IngamePlayer>(entityName: "IngamePlayer")
        var sum: Int32 = 0

        do {
            ingamePlayer = try persistentContainer.viewContext.fetch(request).filter{ $0.id == id}.filter{ $0.name == mainName }
            for player in ingamePlayer {
                let ingameList = player.ingamePlayerPlayList.filter{ $0.enemyName! == enemyName }
                for i in ingameList {
                    sum += i.cost
                }
            }
            return sum
        } catch {
            print("fetchSpecificPlayerToPlayerCost method error")
            return 0
        }

    }// 정산내역에 쓰이는 디테일한 내역
    
    func saveRoundInMainPageHistory(mainPageHistory: MainPageHistory) {
        let round = Round(context: persistentContainer.viewContext)
        round.id = mainPageHistory.id
        
        let ingamePlayers = ["플레이어1", "플레이어2", "플레이어3", "플레이어4"]
        
        for ingamePlayer in ingamePlayers {
            let player = IngamePlayer(context: persistentContainer.viewContext)
            player.id = mainPageHistory.id
            player.name = ingamePlayer
            player.totalCost = 0
            for oneOfEnemyList in ingamePlayers {
                if oneOfEnemyList != ingamePlayer {
                    let enemy = IngamePlayerPlayList(context: persistentContainer.viewContext)
                    enemy.cost = 0
                    enemy.id = mainPageHistory.id
                    enemy.enemyName = oneOfEnemyList
                    player.addToPlayList(enemy)
                }
            }
            
            round.addToIngamePlayer(player)
        }
        
        mainPageHistory.addToRound(round)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("\(error)")
        }
    }//round save test용 method
    
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
            player.id = mainPageHistory.id
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
