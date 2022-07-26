//
//  CalculateView.swift
//  GoStop
//
//  Created by 이태현 on 2022/04/23.
//

import SwiftUI

struct CalculateView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var coreDM: CoreDataManager
    var mainPageHistory: MainPageHistory
    
    struct DiviedView: View {
        var mainPageHistory: MainPageHistory
        var coreDM: CoreDataManager
        var player: Player
        var body: some View {
            HStack {
                Text("\(mainPageHistory.playerlist.firstIndex(of: player)!+1)\t")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.red)
                Text(player.name ?? "")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                let totalCost = coreDM.fetchSpecificPlayerTotalCost(id: mainPageHistory.id!, name: player.name ?? "")
                if totalCost > 0 {
                    Text("+\(totalCost)원")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.red)
                } else if totalCost < 0 {
                    Text("\(totalCost)원")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.blue)
                } else {
                    Text("\(totalCost)원")
                        .font(.system(size: 16, weight: .bold))
                }
            }
            .padding(.bottom, 3)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                }
                Spacer()
                Text(mainPageHistory.historyName!)
                    .font(.system(size: 14))
                    .bold()
                Spacer()
                Image(systemName: "arrow.left")
                    .opacity(0)
            }
            .padding(.horizontal)
            divideRectangle()
            HStack {
                Text("정산내역")
                    .font(.system(size: 24, weight: .bold))
                Spacer()
            }
            .padding([.top, .leading, .trailing])
            
            ScrollView {
                VStack {
                    ForEach(mainPageHistory.playerlist, id: \.self) { player in
                        VStack {
                            DiviedView(mainPageHistory: mainPageHistory, coreDM: coreDM ,player: player)
                            
                            ForEach(mainPageHistory.playerlist, id: \.self) { innerPlayer in
                                let mainName = player.name ?? ""
                                let enemyName = innerPlayer.name ?? ""
                                let mainID = mainPageHistory.id ?? UUID()
                                if player != innerPlayer {
                                    HStack {
                                        let sum: Int32 = coreDM.fetchSpecificPlayerToPlayerCost(mainName: mainName, enemyName: enemyName, id: mainID)
                                        Text(innerPlayer.name ?? "")
                                            .font(.system(size: 14, weight: .medium))
                                        Text("에게")
                                            .font(.system(size: 14, weight: .medium))
                                        if sum > 0 {
                                            Text("+\(sum)원")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.red)
                                            Text("을 받아야 합니다.")
                                                .font(.system(size: 14, weight: .medium))
                                        } else if sum < 0 {
                                            Text("\(sum)원")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.blue)
                                            Text("을 줘야 합니다.")
                                                .font(.system(size: 14, weight: .medium))
                                        } else {
                                            Text("받을 금액이 없습니다.")
                                                .font(.system(size: 14, weight: .medium))
                                        }
                                        Spacer()
                                    }
                                }
                                
                            }
                        }
                        .padding()
                        .background (
                            RoundedRectangle(cornerRadius: 18)
                                .foregroundColor(.white)
                                .shadow(color: .gray, radius: 5, x: 0, y: 3)
                        )
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
        }
        .navigationBarHidden(true)
    }
}

struct CalculateView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager().persistentContainer.viewContext
        let testHistory = MainPageHistory(context: context)
        let players = ["플레이어1","플레이어2","플레이어3","플레이어4"]
        
        
        for i in 0 ..< 4 {
            let player = Player(context: context)
            player.name = players[i]
            testHistory.addToPlayer(player)
        }
        
        testHistory.historyName = "2021.09.01"
        
        return CalculateView(coreDM: CoreDataManager(), mainPageHistory: testHistory)
            .environment(\.managedObjectContext, context)
    }
}
