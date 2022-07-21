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
    
    func fetchIngamePlayers(id: UUID, roundId: UUID) -> [IngamePlayer] {
        let request = NSFetchRequest<IngamePlayer>(entityName: "IngamePlayer")
        
        do {
            return try persistentContainer.viewContext.fetch(request).filter{ $0.id == id }.filter{ $0.roundId == roundId }
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
                print(player.innerArray)
                let ingameList = player.innerArray.filter{ $0.enemyName! == enemyName }
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
        round.roundId = UUID()
        let ingamePlayers = ["플레이어 1", "플레이어 2", "플레이어 3", "플레이어 4"]
        var playerseq:Int16 = 0
        for ingamePlayer in ingamePlayers {
            let player = IngamePlayer(context: persistentContainer.viewContext)
            player.id = mainPageHistory.id
            player.name = ingamePlayer
            player.roundId = round.roundId
            player.totalCost = 100
            player.sequence = playerseq
            playerseq+=1
            var sum: Int32 = -100//here
            var ingameseq: Int16 = 0
            for oneOfEnemyList in ingamePlayers {
                if oneOfEnemyList != ingamePlayer {
                    let enemy = IngamePlayerPlayList(context: persistentContainer.viewContext)
                    enemy.cost = sum//here
                    enemy.id = mainPageHistory.id
                    enemy.roundId = round.roundId
                    enemy.enemyName = oneOfEnemyList
                    enemy.sequence = ingameseq
                    player.addToPlayList(enemy)
                    sum += 200//here
                    ingameseq+=1
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
    
    func saveRoundOfGameResult(mainPageHistory: MainPageHistory, endGameViewModel: EndGameViewModel) {
        endGameViewModel.calculate(mainPageHistory: mainPageHistory)
        //이제 점수저장하자~
        let round = Round(context: persistentContainer.viewContext)
        round.id = mainPageHistory.id
        round.roundId = UUID()
        
        var playerSeq: Int16 = 0
        for playerIndex in 0 ..< endGameViewModel.ingamePlayers.count {
            let player = IngamePlayer(context: persistentContainer.viewContext)
            player.id = mainPageHistory.id
            player.name = endGameViewModel.ingamePlayers[playerIndex]
            player.roundId = round.roundId
            player.totalCost = endGameViewModel.totalCost[playerIndex]
            if playerIndex == endGameViewModel.sellerIndex {
                player.seller = true
            } else {
                player.seller = false
            }//광판사람 설정
            if playerIndex == endGameViewModel.winnerIndex {
                player.winner = true
            } else {
                player.winner = false
            }//승자 설정
            if endGameViewModel.selectOption[playerIndex] == 0 {
                player.firstpuck = true
                player.secondpuck = false
                player.thirdpuck = false
            } else if endGameViewModel.selectOption[playerIndex] == 1 {
                player.firstpuck = false
                player.secondpuck = true
                player.thirdpuck = false
            } else if endGameViewModel.selectOption[playerIndex] == 2 {
                player.firstpuck = false
                player.secondpuck = false
                player.thirdpuck = true
            } else {
                player.firstpuck = false
                player.secondpuck = false
                player.thirdpuck = false
            }//옵션 점수 기록
            if endGameViewModel.firstTatac[playerIndex] == true {
                player.firsttatack = true
            } else {
                player.firsttatack = false
            }
            if endGameViewModel.loserOption[playerIndex][0] == true {
                player.peeback = true
            } else {
                player.peeback = false
            }
            if endGameViewModel.loserOption[playerIndex][1] == true {
                player.gwangback = true
            } else {
                player.gwangback = false
            }
            if endGameViewModel.loserOption[playerIndex][2] == true {
                player.mungback = true
            } else {
                player.mungback = false
            }
            if endGameViewModel.loserOption[playerIndex][3] == true {
                player.goback = true
            } else {
                player.goback = false
            }
            player.sequence = playerSeq
            playerSeq += 1
            var ingameSeq: Int16 = 0
            for enemyIndex in 0 ..< endGameViewModel.ingamePlayers.count {
                if playerIndex != enemyIndex {
                    let enemy = IngamePlayerPlayList(context: persistentContainer.viewContext)
                    enemy.cost = endGameViewModel.eachCostList[playerIndex][enemyIndex]
                    enemy.id = mainPageHistory.id
                    enemy.roundId = round.roundId
                    enemy.enemyName = endGameViewModel.ingamePlayers[enemyIndex]
                    enemy.sequence = ingameSeq
                    player.addToPlayList(enemy)
                    ingameSeq += 1
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
    }
    
    func saveMainPageHistory(players: [String], historyName: String, jumDang: String, ppuck: String, firstTadack: String, sell: String) {
        let mainPageHistory = MainPageHistory(context: persistentContainer.viewContext)
        
        var seq: Int16 = 0
        
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
        
        mainPageHistory.rule = Rule(context: persistentContainer.viewContext)
        mainPageHistory.rule?.jumDang = Int32(jumDang) ?? 0
        mainPageHistory.rule?.ppuck = Int32(ppuck) ?? 0
        mainPageHistory.rule?.firstTadack = Int32(firstTadack) ?? 0
        mainPageHistory.rule?.sell = Int32(sell) ?? 0
        
        
        for i in players.indices {
            let player = Player(context: persistentContainer.viewContext)
            player.name = players[i]
            player.id = mainPageHistory.id
            player.sequence = seq
            mainPageHistory.addToPlayer(player)
            seq += 1
        }

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
    
    func deleteRound(round: Round) {
        persistentContainer.viewContext.delete(round)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
        
    }
}
