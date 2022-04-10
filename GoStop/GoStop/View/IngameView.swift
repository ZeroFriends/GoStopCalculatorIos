//
//  IngameView.swift
//  GoStop
//
//  Created by 이태현 on 2022/02/25.
//

import SwiftUI

struct IngameView: View {
    @State var toGoHome = false
    @State var gameRuleButton = false
    var mainPageHistory: MainPageHistory
    
    var body: some View {
        ZStack {
            NavigationLink(isActive: $toGoHome) {
                MainPage()
            } label: { }
            NavigationLink(isActive: $gameRuleButton) {
                gameRuleView(mainPageHistory: mainPageHistory)
            } label: {
            }
            VStack {
                HStack {
                    Button {
                        toGoHome = true
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text(mainPageHistory.historyName!)
                        .font(.system(size: 14))
                        .bold()
                    Spacer()
                    Button {
                        gameRuleButton = true
                    } label: {
                        Text("게임규칙")
                            .font(.system(size:14))
                            .foregroundColor(.red)
                            .bold()
                    }
                }
                .padding(.horizontal)
                divideRectangle()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .foregroundColor(.white)
                        .frame(height: 148)
                        .shadow(color: .gray, radius: 3, x: 0, y: 3)
                    VStack {
                        HStack {
                            Text("수익현황 👏").font(.system(size: 24, weight: .bold))
                            Spacer()
                            Button {
                                //정산내역 action
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12.5)
                                        .foregroundColor(.white)
                                        .frame(width: 79, height: 25)
                                    RoundedRectangle(cornerRadius: 12.5)
                                        .stroke(lineWidth: 1)
                                        .foregroundColor(.red)
                                        .frame(width: 79, height: 25)
                                    Text("정산내역 >")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(.vertical)
                        HStack(spacing: 40) {
                            HStack {
                                Text("1   ")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.red)
                                Text(mainPageHistory.playerlist[0].name!)
                                    .font(.system(size: 16, weight: .medium))
                                Spacer()
                                Text("원")
                                    .font(.system(size: 12, weight: .medium))
                            }
                            HStack {
                                Text("2   ")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.red)
                                Text(mainPageHistory.playerlist[1].name!)
                                    .font(.system(size: 16, weight: .medium))
                                Spacer()
                                Text("원")
                                    .font(.system(size: 12, weight: .medium))
                            }
                        }
                        HStack(spacing: 40) {
                            HStack {
                                if mainPageHistory.playerlist.count == 3 ||
                                    mainPageHistory.playerlist.count == 4  {
                                    Text("3   ")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.red)
                                    Text(mainPageHistory.playerlist[2].name!)
                                        .font(.system(size: 16, weight: .medium))
                                    Spacer()
                                    Text("원")
                                        .font(.system(size: 12, weight: .medium))
                                }
                            }
                            HStack {
                                if mainPageHistory.playerlist.count == 4 {
                                    Text("4   ")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.red)
                                    Text(mainPageHistory.playerlist[3].name!)
                                        .font(.system(size: 16, weight: .medium))
                                    Spacer()
                                    Text("원")
                                        .font(.system(size: 12, weight: .medium))
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                    .padding(.horizontal)
                }
                .padding([.leading, .trailing, .bottom])
                
            }//VStack
        }//ZStack
        .navigationBarHidden(true)
    }
}

struct divideRectangle: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/)
    }
}

struct IngameView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager().persistentContainer.viewContext
        let testHistory = MainPageHistory(context: context)
        let players = ["플레이어1","플레이어2","플레이어3","플레이어4"]
        
        for i in 0 ..< 4 {
            let player = Player(context: context)
            player.name = players[i]
            testHistory.addToPlayer(player)
        }
        
        testHistory.historyName = "2021.09.21"

        return IngameView(mainPageHistory: testHistory).environment(\.managedObjectContext, context)
    }
}
