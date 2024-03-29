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
    @ObservedObject var endGameVM = EndGameViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var endGameSell = false
    @State var endGameOption = false
    
    @State var isActive = false
    
    var subTitle = "시작하기"
    var subExplain = "2인 이상 4인까지 게임을 플레이 할 수 있으며,\n4인 플레이를 할 경우 1명은 광을 반드시 팔아야 합니다."

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
                .frame(height: 35)
                divideRectangle()
                    .padding(.horizontal, -20)
                    .padding(.bottom, 6)
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
                        .shadow(color: Color(hex: 0xbdbdbd), radius: 5, x: 0, y: 3)
                )
                
                HStack {
                    Text("플레이어 리스트")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.top, 20)
                ScrollView {
                    VStack {
                        ForEach(mainPageHistory.playerlist, id:\.self) { player in
                            let checkBoxIndex = mainPageHistory.playerlist.firstIndex(of: player)!
                            Button {
//                                checkBoxOn[checkBoxIndex].toggle()
                                if endGameVM.checkBoxOn[checkBoxIndex] == false && endGameVM.checkBoxOn.filter({ $0 == true }).count == 4 {
                                    isActive = true
                                } else {
                                    endGameVM.checkBoxOn[checkBoxIndex].toggle()
                                }
                            } label: {
                                HStack {
                                    Text("\(checkBoxIndex+1)\t")
                                        .font(.system(size: 16, weight: endGameVM.checkBoxOn[checkBoxIndex] == true ? .bold : .medium))
                                        .foregroundColor(.red)
                                    Text(player.name ?? "")
                                        .font(.system(size: 16, weight: endGameVM.checkBoxOn[checkBoxIndex] == true ? .bold : .medium))
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(endGameVM.checkBoxOn[checkBoxIndex] == true ? "checkCircleBlack24Dp" : "radioButtonUncheckedBlack24DpCopy")
                                }
                                .padding()
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(endGameVM.checkBoxOn[checkBoxIndex] == true ? CustomColor.checkBoxColor : .white)
                            )
                            .alert(isPresented: $isActive) {
                                Alert(title: Text(""), message: Text("플레이어는 2인이상 4인이하만 지정."), dismissButton: .destructive(Text("확인")))
                            }
                        }
                    }//VStack
                    //광팔기 view
                }//ScrollView

                Spacer()

                PushView(destination: EndGameSellView(
                    mainPageHistory: mainPageHistory,
                    coreDM: coreDM,
                    endGameVM: endGameVM), isActive: $endGameSell) {}
                
                PushView(destination: EndGameOptionView(
                    mainPageHistory: mainPageHistory,
                    coreDM: coreDM,
                    endGameVM: endGameVM), isActive: $endGameOption) {}
                
                Button {
                    endGameVM.ingamePlayers = []
                    for checkIndex in 0 ..< 10 {
                        if endGameVM.checkBoxOn[checkIndex] == true {
                            endGameVM.ingamePlayers.append(mainPageHistory.playerlist[checkIndex].name!)
                        }
                    }
                    if endGameVM.ingamePlayers.count == 4 {
                        endGameSell = true
                        // 플레이어 4명이면 무조건 광을 팔아야 하니까
                    } else {
                        endGameOption = true
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 22)
                            .foregroundColor(endGameVM.checkBoxOn.filter{ $0 == true}.count < 2 ||
                                             endGameVM.checkBoxOn.filter{ $0 == true}.count > 4 ? Color(hex: 0xbdbdbd) : .red)
                            .frame(height: 44)
                        Text("다음")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .disabled(endGameVM.checkBoxOn.filter{ $0 == true}.count < 2 || endGameVM.checkBoxOn.filter{ $0 == true}.count > 4)
                .padding(.bottom, 5)
            }//VStack
            .padding(.horizontal)
            .navigationBarHidden(true)
    }
}



struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager().persistentContainer.viewContext
        let testHistory = MainPageHistory(context: context)
        testHistory.historyName = "2021.09.01"
        return EndGameStartView(coreDM: CoreDataManager(), mainPageHistory: testHistory) .environment(\.managedObjectContext, context)
    }
}
