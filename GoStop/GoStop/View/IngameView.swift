//
//  IngameView.swift
//  GoStop
//
//  Created by 이태현 on 2022/02/25.
//

import SwiftUI

struct IngameView: View {
    @State var toGoHome = false
    @State var calculateButton = false
    @State var gameRuleButton = false
    
    let coreDM: CoreDataManager
    var mainPageHistory: MainPageHistory
    
    @State var rounds: [Round] = []
    
    private func populateRounds() {
        rounds = coreDM.fetchRound(id: mainPageHistory.id ?? UUID())
    }
    
    var body: some View {
        ZStack {
            NavigationLink(isActive: $toGoHome) {
                MainPage()
            } label: { }
            NavigationLink(isActive: $gameRuleButton) {
                gameRuleView(mainPageHistory: mainPageHistory)
            } label: {
            }
            NavigationLink(isActive: $calculateButton) {
                CalculateView(coreDM: coreDM, mainPageHistory: mainPageHistory)
            } label: {
            }
            VStack {
                HStack {
                    Button {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            toGoHome = true
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }
                    .padding(.trailing, 28)
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
                
//                    RoundedRectangle(cornerRadius: 18)
//                        .foregroundColor(.white)
//                        .shadow(color: .gray, radius: 3, x: 0, y: 3)
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
                                    Button {
                                        calculateButton = true
                                    } label: {
                                        Text("정산내역 >")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                        .frame(height: 35)
                        .padding(.horizontal)
                        .padding(.top)
                        let columns = [
                                GridItem(.adaptive(minimum: 120))
                            ]
                        LazyVGrid(columns: columns) {
                            ForEach(mainPageHistory.playerlist, id: \.self) { player in
                                let specificCost = coreDM.fetchSpecificPlayerTotalCost(id: mainPageHistory.id ?? UUID())
                                HStack {
                                    Text("\(mainPageHistory.playerlist.firstIndex(of: player)!+1)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.red)
                                    Text(player.name ?? "")
                                    Spacer()
                                    Text("\(specificCost)")
                                    Text("원")
                                        .font(.system(size: 12, weight: .medium))
                                }
                                .frame(width: 150)
                                .padding([.leading, .trailing, .bottom])
                            }
                        }
                        .padding()
                    }
                    .background (
                        RoundedRectangle(cornerRadius: 18)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 3, x: 0, y: 3)
                    )
                    .padding(.horizontal)
                HStack {
                    Text("진행내역 🤝")
                        .font(.system(size: 28, weight: .bold))
                    Spacer()
                }
                .padding(.horizontal)
                if rounds.isEmpty {
                    Spacer()
                    Image("errorOutlineBlack24Dp1")
                    Text("게임을 진행한 내역이 없습니다.")
                        .font(.system(size: 16, weight: .semibold))
                    HStack {
                        Text("하단에")
                        Text("게임시작")
                            .underline()
                            .fontWeight(.semibold)
                        Text("버튼을 눌러 게임을 진행해주세요.")
                    }
                    .font(.system(size: 14))
                    Spacer()
                } else {
                    ScrollView {
                        VStack {
                            ForEach(rounds.reversed(), id: \.self) { round in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 18)
                                        .foregroundColor(.white)
                                        .frame(height: 148)
                                        .shadow(color: .gray, radius: 3, x: 0, y: 3)
                                    VStack {
                                        HStack {
                                            Text("\(Int(rounds.firstIndex(of: round)!)+1) 라운드")
                                                .font(.system(size: 24, weight: .bold))
                                            Spacer()
                                        }
                                        .padding(.vertical)
                                        HStack(spacing: 40) {
                                            HStack {
                                                Text("1   ")
                                                    .font(.system(size: 16, weight: .bold))
                                                    .foregroundColor(.red)
                                                Text(mainPageHistory.playerlist[0].name ?? "")
                                                    .font(.system(size: 16, weight: .medium))
                                                Spacer()
                                                Text("원")
                                                    .font(.system(size: 12, weight: .medium))
                                            }
                                            HStack {
                                                Text("2   ")
                                                    .font(.system(size: 16, weight: .bold))
                                                    .foregroundColor(.red)
                                                Text(mainPageHistory.playerlist[1].name ?? "")
                                                    .font(.system(size: 16, weight: .medium))
                                                Spacer()
                                                Text("원")
                                                    .font(.system(size: 12, weight: .medium))
                                            }
                                        }
                                        HStack(spacing: 40) {
                                            HStack {
                                                if mainPageHistory.playerlist.count >= 3 {
                                                    Text("3  ")
                                                        .font(.system(size: 16, weight: .bold))
                                                        .foregroundColor(.red)
                                                    Text(mainPageHistory.playerlist[2].name ?? "")
                                                        .font(.system(size: 16, weight: .medium))
                                                    Spacer()
                                                    Text("원")
                                                        .font(.system(size: 12, weight: .medium))
                                                }
                                            }
                                            HStack {
                                                if mainPageHistory.playerlist.count >= 4 {
                                                    Text("4   ")
                                                        .font(.system(size: 16, weight: .bold))
                                                        .foregroundColor(.red)
                                                    Text(mainPageHistory.playerlist[3].name ?? "")
                                                        .font(.system(size: 16, weight: .medium))
                                                    Spacer()
                                                    Text("원")
                                                        .font(.system(size: 12, weight: .medium))
                                                } else {
                                                    Spacer()
                                                }
                                            }
                                        }
                                        .padding(.vertical)
                                    }
                                    .padding(.horizontal)//VStack
                                }
                                .padding()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                Button {
                    //게임시작 action
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 22)
                            .foregroundColor(.red)
                            .frame(height: 44)
                        Text("게임시작")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                }
            }//VStack
        }//ZStack
        .navigationBarHidden(true)
        .onAppear {
            populateRounds()
        }
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

        return IngameView(coreDM: CoreDataManager(), mainPageHistory: testHistory).environment(\.managedObjectContext, context)
    }
}
