//
//  RoundDetailView.swift
//  GoStop
//
//  Created by 이태현 on 2022/04/28.
//

import SwiftUI

struct RoundDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var coreDM: CoreDataManager
    var mainPageHistory: MainPageHistory
    var round: Round
//    @State var ingamePlayers: [IngamePlayer] = []
//
//    private func populateIngamePlayer() {
//        ingamePlayers = coreDM.fetchIngamePlayers(id: mainPageHistory.id!, roundId: round.roundId!)
//    }
    
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
            }//HStack
            .padding(.horizontal)
            divideRectangle()
            HStack {
                Text("상세보기")
                    .font(.system(size: 24, weight: .bold))
                Spacer()
            }
            .padding([.top, .leading, .trailing])
            
            ScrollView {
                VStack {
                    ForEach(round.ingamePlayerList, id: \.self) { ingamePlayer in
                        let inner = ingamePlayer.innerArray
                        
                        VStack {
                            HStack {
                                Text("\(round.ingamePlayerList.firstIndex(of: ingamePlayer)!+1)\t")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.red)
                                Text(ingamePlayer.name ?? "no name")
                                    .font(.system(size: 16, weight: .bold))
                                Spacer()
                                if ingamePlayer.totalCost > 0 {
                                    Text("+\(ingamePlayer.totalCost)원")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.red)
                                } else if ingamePlayer.totalCost < 0 {
                                    Text("-\(ingamePlayer.totalCost)원")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.blue)
                                } else {
                                    Text("\(ingamePlayer.totalCost)원")
                                        .font(.system(size: 16, weight: .bold))
                                }
                            }//HStack
                            .padding(.bottom, 3)
                            
                            ForEach(inner, id: \.self) { innerIngamePlayer in

                                let cost = innerIngamePlayer.cost
                                HStack {
                                    Text(innerIngamePlayer.enemyName ?? "")
                                        .font(.system(size: 14, weight: .medium))
                                    Text("에게")
                                        .font(.system(size: 14, weight: .medium))
                                    if cost > 0 {
                                        Text("+\(cost)원")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.red)
                                        Text("을 받아야 합니다.")
                                            .font(.system(size: 14, weight: .medium))
                                    } else if cost < 0 {
                                        Text("\(cost)원")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.blue)
                                        Text("을 받아야 합니다.")
                                            .font(.system(size: 14, weight: .medium))
                                    } else {
                                        Text("받을 금액이 없습니다.")
                                            .font(.system(size: 14, weight: .medium))
                                    }
                                    Spacer()
                                }//HStack
                            }//ForEach

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
            }//ScrollView
        }//VStack
        .onAppear {
//            populateIngamePlayer()
        }
        .navigationBarHidden(true)
    }
}

struct RoundDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager().persistentContainer.viewContext
        let testHistory = MainPageHistory(context: context)
        let players = ["플레이어1","플레이어2","플레이어3","플레이어4"]
        let round = Round(context: context)
        
        for i in 0 ..< 4 {
            let player = Player(context: context)
            player.name = players[i]
            testHistory.addToPlayer(player)
        }
        testHistory.id = UUID()
        
        round.id = testHistory.id
        
        for i in 0 ..< 4 {
            let player = IngamePlayer(context: context)
            player.name = players[i]
            player.id = round.id
            player.totalCost = 0
            round.addToIngamePlayer(player)
        }
        
        testHistory.addToRound(round)
        testHistory.historyName = "2021.09.01"
        
        return RoundDetailView(coreDM: CoreDataManager(), mainPageHistory: testHistory, round: round)
            .environment(\.managedObjectContext, context)
    }
}
