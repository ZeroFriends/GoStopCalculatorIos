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
                            
//                            ForEach(ingamePlayer.enemyList, id: \.self) { enemy in
//                                HStack {
//                                    Text(enemy.name ?? "")
//                                        .font(.system(size: 14, weight: .medium))
//                                    Text("에게")
//                                        .font(.system(size: 14, weight: .medium))
//                                    if enemy.cost! > 0 {
//                                        Text("+\(enemy.cost!)원")
//                                            .font(.system(size: 14, weight: .bold))
//                                            .foregroundColor(.red)
//                                        Text("을 받아야 합니다.")
//                                            .font(.system(size: 14, weight: .medium))
//                                    } else if enemy.cost! < 0 {
//                                        Text("\(enemy.cost!)원")
//                                            .font(.system(size: 14, weight: .bold))
//                                            .foregroundColor(.blue)
//                                        Text("을 받아야 합니다.")
//                                            .font(.system(size: 14, weight: .medium))
//                                    } else {
//                                        Text("받을 금액이 없습니다.")
//                                            .font(.system(size: 14, weight: .medium))
//                                    }
//                                    Spacer()
//                                }
//                            }//이 부분의 ForEach만 추가하면 build가 느려짐 test code 작성의 문제인건지 이 부분이 문제인지 End game view 개발하면서 파악해야함
                            ForEach(round.ingamePlayerList, id: \.self) { innerIngamePlayer in
                                let sum = 0//cost fetch 부분 ingamePlayer와 innerIngamePlayer를 가지고 cost를 가져와야함 지금은 임시 데이터
                                if ingamePlayer.name != innerIngamePlayer.name {
                                    HStack {
                                        Text(innerIngamePlayer.name ?? "")
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
                                            Text("을 받아야 합니다.")
                                                .font(.system(size: 14, weight: .medium))
                                        } else {
                                            Text("받을 금액이 없습니다.")
                                                .font(.system(size: 14, weight: .medium))
                                        }
                                        Spacer()
                                    }//HStack
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
            }//ScrollView
        }//VStack
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
