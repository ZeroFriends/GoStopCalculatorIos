//
//  EndGameView.swift
//  GoStop
//
//  Created by 이태현 on 2022/05/03.
//

import NavigationStack
import SwiftUI

struct EndGameStartView: View {
    let coreDM: CoreDataManager
    var mainPageHistory: MainPageHistory
    
    @State var ingamePlayers: [String] = []
    @Environment(\.presentationMode) var presentationMode
    
    @State var endGameSell = false
    @State var endGameOption = false
    
    var subTitle = "시작하기"
    var subExplain = "2인 이상 4인까지 게임을 플레이 할 수 있으며,\n4인 플레이를 할 경우 1명은 광을 반드시 팔아야 합니다."

    @State private var checkBoxOn = Array(repeating: false, count: 10)

    var body: some View {

            VStack {
                HStack {
                    Button {
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                            .opacity(0)
                    }
                    Spacer()
                    Text(mainPageHistory.historyName ?? "mainPage 이름 설정 안함")
                        .font(.system(size: 14))
                        .bold()
                    Spacer()
                    PopView(destination: .root) {
                        Image(systemName: "multiply")
                            .foregroundColor(.black)
                    }
                }
                divideRectangle()
                    .padding(.horizontal, -20)
                VStack(alignment: .center,spacing: 10) {
                    HStack {
                        Text(subTitle)
                            .font(.system(size: 20, weight: .bold))
                    }
                    HStack {
                        Spacer()
                        Text(subExplain)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 14, weight: .medium))
                        Spacer()
                    }
                }//VStack
                .padding(.vertical)
                .background (
                    RoundedRectangle(cornerRadius: 18)
                        .foregroundColor(.white)
                        .shadow(color: .gray, radius: 5, x: 0, y: 3)
                )
                
                HStack {
                    Text("플레이어 리스트")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
                .padding(.vertical, 10)
                ScrollView {
                    VStack {
                        ForEach(mainPageHistory.playerlist, id:\.self) { player in
                            let checkBoxIndex = mainPageHistory.playerlist.firstIndex(of: player)!
                            Button {
                                checkBoxOn[checkBoxIndex].toggle()
                            } label: {
                                HStack {
                                    Text("\(checkBoxIndex+1)\t")
                                        .font(.system(size: 16, weight: checkBoxOn[checkBoxIndex] == true ? .bold : .medium))
                                        .foregroundColor(.red)
                                    Text(player.name ?? "")
                                        .font(.system(size: 16, weight: checkBoxOn[checkBoxIndex] == true ? .bold : .medium))
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(checkBoxOn[checkBoxIndex] == true ? "checkCircleBlack24Dp" : "radioButtonUncheckedBlack24DpCopy")
                                }
                                .padding()
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(checkBoxOn[checkBoxIndex] == true ? CustomColor.checkBoxColor : .white)
                            )
                        }
                    }//VStack
                    //광팔기 view
                }//ScrollView

                Spacer()

                PushView(destination: EndGameSellView(
                    mainPageHistory: mainPageHistory,
                    coreDM: coreDM,
                    ingamePlayers: ingamePlayers), isActive: $endGameSell) {}
                
                PushView(destination: EndGameOptionView(
                    mainPageHistory: mainPageHistory,
                    coreDM: coreDM,
                    ingamePlayers: ingamePlayers,
                    sellerIndex: nil), isActive: $endGameOption) {}
                
                Button {
                    ingamePlayers = []
                    for checkIndex in 0 ..< checkBoxOn.count {
                        if checkBoxOn[checkIndex] == true {
                            ingamePlayers.append(mainPageHistory.playerlist[checkIndex].name!)
                        }
                    }
                    if ingamePlayers.count == 4 {
                        endGameSell = true
                        // 플레이어 4명이면 무조건 광을 팔아야 하니까
                    } else {
                        endGameOption = true
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("완료")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .foregroundColor(checkBoxOn.filter{ $0 == true}.count < 2 ||
                                             checkBoxOn.filter{ $0 == true}.count > 4 ? .gray : .red)
                    )
                }
                .disabled(checkBoxOn.filter{ $0 == true}.count < 2 || checkBoxOn.filter{ $0 == true}.count > 4)
                
            }//VStack
            .padding(.horizontal)
            .navigationBarHidden(true)
    }
}

struct CustomColor {
    static let checkBoxColor = Color("checkBoxColor")
}

struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager().persistentContainer.viewContext
        let testHistory = MainPageHistory(context: context)
        testHistory.historyName = "2021.09.01"
        return EndGameStartView(coreDM: CoreDataManager(), mainPageHistory: testHistory) .environment(\.managedObjectContext, context)
    }
}
