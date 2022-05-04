//
//  EndGameView.swift
//  GoStop
//
//  Created by 이태현 on 2022/05/03.
//

import SwiftUI

struct EndGameView: View {
    let coreDM: CoreDataManager
    var mainPageHistory: MainPageHistory
    
    @State var ingamePlayers: [String] = []
    @Environment(\.presentationMode) var presentationMode
    
    var subTitle = ["시작하기", "광팔기", "옵션점수 기록", "승자점수 기록", "패자 점수기록"]
    var subExplain = ["2인 이상 4인까지 게임을 플레이 할 수 있으며,\n4인 플레이를 할 경우 1명은 광을 반드시 팔아야 합니다.",
                      "4인 플레이의 경우 한명이 필수로 광을 팔아야\n플레이가 가능합니다. 광을 판 플레이어를 선택해주세요.",
                      "운이 좋네요!\n해당하는 곳에 체크를 해주세요",
                      "이긴 플레이어를 선택하고,\n몇점을 내었는지 계산 후 점수를 적어주세요.",
                      "게임에서 패배한 플레이어들의 박 여부를 체크해주세요."]
    @State private var index = 0
    @State private var checkBoxOn = Array(repeating: false, count: 10)
    @State private var recordOption: [String] = []
    var body: some View {
        VStack {
            HStack {
                Button {
                    if index == 2 {
                        if ingamePlayers.count == 4 {
                            index = 1
                        } else {
                            index = 0
                        }
                    } else {
                        index -= 1
                    }
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .opacity(index == 0 ? 0 : 1 )
                }
                Spacer()
                Text(mainPageHistory.historyName ?? "mainPage 이름 설정 안함")
                    .font(.system(size: 14))
                    .bold()
                Spacer()
                Button {
                    // X 의 기능
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "multiply")
                        .foregroundColor(.black)
                }
            }
            divideRectangle()
                .padding(.horizontal, -20)
            VStack(alignment: .center,spacing: 10) {
                HStack {
                    Text(subTitle[index])
                        .font(.system(size: 20, weight: .bold))
                }
                HStack {
                    Spacer()
                    Text(subExplain[index])
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
                if index == 1 {
                    Button {
                        //광팔 수 있는 패 popup
                    } label: {
                        Text("광팔 수 있는 패")
                            .padding(.horizontal)
                            .foregroundColor(.red)
                            .font(.system(size: 14, weight: .bold))
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12).stroke().foregroundColor(.red)
                    )
                } else if index >= 2 {
                    Button {
                        
                    } label: {
                        Text("점수 계산 법")
                            .padding(.horizontal)
                            .foregroundColor(.red)
                            .font(.system(size: 14, weight: .bold))
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12).stroke().foregroundColor(.red)
                    )
                }
            }
            .padding(.vertical, 10)
            ScrollView {
                if index == 0 {
                    VStack {
                        ForEach(mainPageHistory.playerlist, id:\.self) { player in
                            let checkBoxIndex = mainPageHistory.playerlist.firstIndex(of: player)!
                            Button {
                                checkBoxOn[checkBoxIndex].toggle()
                            } label: {
                                HStack {
                                    Text("\(checkBoxIndex+1)\t")
                                        .font(.system(size: 16, weight: checkBoxOn[checkBoxIndex] ? .bold : .medium))
                                        .foregroundColor(.red)
                                    Text(player.name ?? "")
                                        .font(.system(size: 16, weight: checkBoxOn[checkBoxIndex] ? .bold : .medium))
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(checkBoxOn[checkBoxIndex] ? "checkCircleBlack24Dp" : "radioButtonUncheckedBlack24DpCopy")
                                }
                                .padding()
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(checkBoxOn[checkBoxIndex] ? CustomColor.checkBoxColor : .white)
                            )
                        }
                    }//VStack
                } else if index == 1 {//광팔기 view
                    VStack {
                        ForEach(ingamePlayers, id:\.self) { ingamePlayer in
                            let playerIndex = ingamePlayers.firstIndex(of: ingamePlayer)!
                            HStack {
                                Text("\(playerIndex+1)\t")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.red)
                                Text(ingamePlayer)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            HStack {
                                Text(" ")
                                Spacer()
                                Rectangle()
                                    .frame(width: 135, height: 1)
                            }
                            .padding(.top, -5)
                            .padding(.bottom, 20)
//                                VStack {
//                                    HStack {
//                                        Text("3 ")
//                                            .foregroundColor(.red)
//                                            .font(.system(size: 16))
//                                            .fontWeight(.bold)
//                                        Text("첫 따닥 ")
//                                            .fontWeight(.medium)
//                                        Spacer()
//                                        TextField("0", text: $firstTadack)
//                                            .multilineTextAlignment(.trailing)
//                                            .keyboardType(.decimalPad)
//                                            .frame(width: 110)
//                                        Text("원")
//                                    }
//                                    HStack {
//                                        Text("  ")
//                                        Spacer()
//                                        Rectangle()
//                                            .frame(width: 135, height: 1)
//                                    }
//                                    .padding(.top, -5)
//                                    .padding(.bottom, 20)
//                                }
                        }
                    }
                } else if index == 2 {//옵션 점수 기록
                    
                } else if index == 3 {//승자 점수 기록
                    
                } else if index == 4 {//패자 점수 기록
                    
                }
            }//ScrollView
            if index == 0 {
                Button {
                    for checkIndex in 0 ..< checkBoxOn.count {
                        if checkBoxOn[checkIndex] == true {
                            ingamePlayers.append(mainPageHistory.playerlist[checkIndex].name!)
                        }
                    }
                    if ingamePlayers.count == 4 {
                        index = 1
                    } else {
                        index = 2
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("완료")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .foregroundColor(checkBoxOn.filter{ $0 == true }.count < 2 ||
                                             checkBoxOn.filter{ $0 == true }.count > 4 ? .gray : .red)
                    )
                }
                .disabled(checkBoxOn.filter{ $0 == true }.count < 2 || checkBoxOn.filter{ $0 == true }.count > 4)
            } else if index == 1 {
                Button {
                    
                } label: {
                    
                }
            }
        }//VStack
        .padding()
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
        return EndGameView(coreDM: CoreDataManager(), mainPageHistory: testHistory).environment(\.managedObjectContext, context)
    }
}
