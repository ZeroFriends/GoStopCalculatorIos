//
//  EndGameSellView.swift
//  GoStop
//
//  Created by 이태현 on 2022/05/10.
//

import NavigationStack
import SwiftUI


struct PopUpIcon: View {
    
    var title: String
    var color: Color
    var size: CGFloat
    
    var body: some View {
        Text(title)
            .font(.system(size: size, weight: .bold))
            .foregroundColor(color)
            .padding(3)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 13).stroke(lineWidth: 1)
                    .foregroundColor(color)
            )
    }
}

struct BuildTopView: View {
    @Environment(\.presentationMode) var presentationMode
    var mainTitle: String
    var subTitle: String
    var subExplain: String
    
    var body: some View {
        VStack {
            HStack {
                
                PopView {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                }

                Spacer()
                Text(mainTitle)
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
        }
        .padding(.horizontal)
    }
}

struct EndGameSellView: View {//광팔기 view
    @State var sellListPopUp = false
    @Environment(\.presentationMode) var presentationMode
    var mainPageHistory: MainPageHistory
    let coreDM: CoreDataManager
    @ObservedObject var endGameVM: EndGameViewModel
    let subTitle = "광팔기"
    let subExplain = "4인 플레이경우 한명이 필수로 광을 팔아야 플레이가 가능합니다. 광을 판 플레이어를 선택해주세요"
    
    var body: some View {
        ZStack {
            VStack {
                BuildTopView(
                             mainTitle: mainPageHistory.historyName ?? "",
                             subTitle: subTitle,
                             subExplain: subExplain)
                HStack {
                    Text("플레이어 리스트")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    Button {
                        withAnimation {
                            sellListPopUp = true
                        }
                    } label: {
                        PopUpIcon(title: "광팔 수 있는 패", color: .red, size: 14)
                    }
                }
                .padding()
                ScrollView {
                    ForEach(endGameVM.ingamePlayers, id: \.self) { ingamePlayer in
                        let index = endGameVM.ingamePlayers.firstIndex(of: ingamePlayer)!
                        HStack {
                            Text("\(index+1)")
                                .font(.system(size: 16, weight: endGameVM.seller[index] ? .bold : .medium))
                                .foregroundColor(.red)
                            Text(ingamePlayer)
                                .font(.system(size: 16, weight: endGameVM.seller[index] ? .bold : .medium))
                            Spacer()
                            Button {
                                endGameVM.seller = Array(repeating: false, count: 4)
                                endGameVM.sellerInput = ["","","",""]
                                endGameVM.seller[index] = true
                                endGameVM.sellerIndex = index
                            } label: {
                                VStack {
                                    HStack {
                                        TextField("-", text: $endGameVM.sellerInput[index])
                                            .multilineTextAlignment(.trailing)
                                            .keyboardType(.decimalPad)
                                            .frame(width: 110)
                                            .foregroundColor(.black)
                                        Text("장")
                                            .foregroundColor(endGameVM.seller[index] ? .black : .gray)
                                    }
                                }
                            }
                        }
                        HStack {
                            Text("  ")
                            Spacer()
                            Rectangle()
                                .frame(width: 135, height: 1)
                                .foregroundColor(endGameVM.seller[index] ? .red : .gray)
                        }
                        .padding(.top, -10)
                        .padding(.bottom, 20)
                    }//이 부분도 충분히 재사용할 수 있음 전환해보자
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                PushView(destination: EndGameOptionView(mainPageHistory: mainPageHistory,
                                                        coreDM: coreDM,
                                                        endGameVM: endGameVM))
                {
                    HStack {
                        Spacer()
                        Text("다음(1/4)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .foregroundColor(endGameVM.seller.filter{ $0 == true}.count == 1 ? .red : .gray)
                    )
                    .padding(.horizontal)
                    .disabled(endGameVM.seller.filter{ $0 == true}.count == 0)
                }
            }
            SellPopUpView(show: $sellListPopUp)
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct EndGameSellView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager().persistentContainer.viewContext
        let testHistory = MainPageHistory(context: context)

        testHistory.historyName = "2021.09.21"
        return EndGameSellView(mainPageHistory: testHistory, coreDM: CoreDataManager(), endGameVM: EndGameViewModel())
    }
}

struct EndGameOptionView: View {
    @State var calculateScorePopUp = false
    @Environment(\.presentationMode) var presentationMode
    var mainPageHistory: MainPageHistory
    let coreDM: CoreDataManager
    @ObservedObject var endGameVM: EndGameViewModel
    let subTitle = "옵션 점수기록"
    let subExplain = "운이 좋네요!\n해당하는 곳에 체크를 해주세요."

    var body: some View {
        ZStack {
            VStack {
                BuildTopView(mainTitle: mainPageHistory.historyName ?? "",
                         subTitle: subTitle,
                         subExplain: subExplain)
                HStack {
                    Text("플레이어 리스트")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    NavigationLink {
                        CalculateScoreView()
                    } label: {
                        PopUpIcon(title: "점수 계산 법", color: .red, size: 14)
                    }
                }
                .padding()
                ForEach(endGameVM.ingamePlayers, id: \.self) { ingamePlayer in
                    let index = endGameVM.ingamePlayers.firstIndex(of: ingamePlayer)!
                        HStack {
                            Text("\(index+1)")
                                .font(.system(size: 16, weight: endGameVM.sellerIndex == index ? .medium : .bold))
                                .foregroundColor(endGameVM.sellerIndex == index ? .gray : .red)
                            Text(ingamePlayer)
                                .font(.system(size: 16, weight: endGameVM.sellerIndex == index ? .medium : .bold))
                            PopUpIcon(title: "광팜", color: .gray, size: 12)
                                .opacity(endGameVM.sellerIndex == index ? 1 : 0)
                            Spacer()
                            if endGameVM.sellerIndex != -1 {
                                Text("\(endGameVM.sellerInput[endGameVM.sellerIndex]) 장")
                                    .foregroundColor(.gray)
                                    .opacity(endGameVM.sellerIndex == index ? 1 : 0)
                            }
                        }
                    if endGameVM.sellerIndex == index {
                            HStack {
                                Text("  ")
                                Spacer()
                                Rectangle()
                                    .frame(width: 135, height: 1)
                                    .foregroundColor(.gray)
                            }//광파는 사람만 나타나게 해야함
                            .padding(.top, -20)
                            .padding(.bottom, 10)
                        } else {
                            HStack {
                                optionSelecter(optionIndex: $endGameVM.selectOption[index],
                                    tatacIndex:
                                                $endGameVM.firstTatac[index])
                            }
                            .padding(.bottom, 10)
                        }
                }
                .padding(.horizontal)
                .padding(.horizontal)
                Spacer()
                PushView(destination: EndGamewinnerRecord(mainPageHistory: mainPageHistory,
                                                          coreDM: coreDM,
                                                          endGameVM: endGameVM))
                {
                    HStack {
                        Spacer()
                        Text("다음(2/4)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                }
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .foregroundColor(.red)
                )
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard, edges: .bottom)

    }
    struct optionSelecter: View {
        
        @Binding var optionIndex: Int
        @Binding var tatacIndex: Bool
        
        var body: some View {
            Button {
                optionIndex = 0
            } label: {
                PopUpIcon(title: "첫 뻑", color: optionIndex != 0 ? .gray : .red, size: 16)
            }
            Button {
                optionIndex = 1
            } label: {
                PopUpIcon(title: "연 뻑", color: optionIndex != 1 ? .gray : .red, size: 16)
            }
            Button {
                optionIndex = 2
            } label: {
                PopUpIcon(title: "삼연 뻑", color: optionIndex != 2 ? .gray : .red, size: 16)
            }
            Button {
                tatacIndex.toggle()
            } label: {
                PopUpIcon(title: "첫 따닥", color: tatacIndex == false ? .gray : .red, size: 16)
            }
            Spacer()
        }
    }
    
}

struct EndGameOptionView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager().persistentContainer.viewContext
        let testHistory = MainPageHistory(context: context)
        
        testHistory.historyName = "2021.09.21"
        return EndGameOptionView(mainPageHistory: testHistory,
                                 coreDM: CoreDataManager(),
                                 endGameVM: EndGameViewModel())
    }
}

struct EndGamewinnerRecord: View {
    var mainPageHistory: MainPageHistory
    let coreDM: CoreDataManager
    @ObservedObject var endGameVM: EndGameViewModel
    let subTitle = "승자 점수기록"
    let subExplain = "이긴 플레이어 선택하고,\n몇점을 내었는지 계산 후 점수를 적어주세요"
    var body: some View {
        VStack {
            BuildTopView(mainTitle: mainPageHistory.historyName ?? "",
                         subTitle: subTitle,
                         subExplain: subExplain)
            HStack {
                Text("플레이어 리스트")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                NavigationLink {
                    CalculateScoreView()
                } label: {
                    PopUpIcon(title: "점수 계산 법", color: .red, size: 14)
                }
            }
            .padding()
            ForEach(endGameVM.ingamePlayers, id: \.self) { ingamePlayer in
                let index = endGameVM.ingamePlayers.firstIndex(of: ingamePlayer)!
                HStack {
                    Text("\(index+1)")
                        .font(.system(size: 16, weight: endGameVM.sellerIndex == index ? .medium : .bold))
                        .foregroundColor(endGameVM.sellerIndex == index ? .gray : .red)
                    Text(ingamePlayer)
                        .font(.system(size: 16, weight: endGameVM.sellerIndex == index ? .medium : .bold))
                    PopUpIcon(title: "광팜", color: .gray, size: 12)
                        .opacity(endGameVM.sellerIndex == index ? 1 : 0)
                    Spacer()

                    if endGameVM.sellerIndex != -1 {
                        if endGameVM.sellerIndex == index {
                            Text("\(endGameVM.sellerInput[endGameVM.sellerIndex]) 장")
                                .foregroundColor(.gray)
                        } else {
                            Button {
                                endGameVM.winner = Array(repeating: false, count: 4)
                                endGameVM.winnerInput = ["","","",""]
                                endGameVM.winner[index] = true
                                endGameVM.winnerIndex = index
                            } label: {
                                TextField("-", text: $endGameVM.winnerInput[index])
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.decimalPad)
                                    .foregroundColor(.black)
                                Text("점")
                                    .foregroundColor(.black)
                            }
                        }
                    } else {
                        Button {
                            endGameVM.winner = Array(repeating: false, count: 4)
                            endGameVM.winnerInput = ["","","",""]
                            endGameVM.winner[index] = true
                            endGameVM.winnerIndex = index
                        } label: {
                            TextField("-", text: $endGameVM.winnerInput[index])
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                                .foregroundColor(.black)
                            Text("점")
                                .foregroundColor(.black)
                        }
                    }
                }
                if endGameVM.sellerIndex == index {
                    HStack {
                        Text("  ")
                        Spacer()
                        Rectangle()
                            .frame(width: 135, height: 1)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, -10)
                    .padding(.bottom, 20)
                } else {
                    HStack {
                        Text("  ")
                        Spacer()
                        Rectangle()
                            .frame(width: 135, height: 1)
                            .foregroundColor(endGameVM.winner[index] ? .red : .white)
                    }
                    .padding(.top, -10)
                    .padding(.bottom, 20)
                }
            }//foreach
            .padding(.horizontal)
            .padding(.horizontal)
            Spacer()
            PushView(destination: EndGameLoserRecord(mainPageHistory: mainPageHistory,
                                                     coreDM: coreDM,
                                                     endGameVM: endGameVM))
            {
                HStack {
                    Spacer()
                    Text("다음(3/4)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .foregroundColor(.red)
            )
            .padding(.horizontal)
        }//VStack
    }
}

struct EndGamewinnerRecord_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager().persistentContainer.viewContext
        let testHistory = MainPageHistory(context: context)
        
        testHistory.historyName = "2021.09.21"
        return EndGamewinnerRecord(mainPageHistory: testHistory,
                                   coreDM: CoreDataManager(),
                                   endGameVM: EndGameViewModel())
    }
}

struct EndGameLoserRecord: View {
    var mainPageHistory: MainPageHistory
    let coreDM: CoreDataManager
    @ObservedObject var endGameVM: EndGameViewModel
    let subTitle = "패자 점수기록"
    let subExplain = "게임에서 패배한 플레이어들의 박 여부를 체크해주세요."
    
    var body: some View {
        VStack {
            BuildTopView(mainTitle: mainPageHistory.historyName ?? "", subTitle: subTitle, subExplain: subExplain)
            
            HStack {
                Text("플레이어 리스트")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                NavigationLink {
                    CalculateScoreView()
                } label: {
                    PopUpIcon(title: "점수 계산 법", color: .red, size: 14)
                }
            }
            .padding()
            ForEach(endGameVM.ingamePlayers, id: \.self) { ingamePlayer in
                let index = endGameVM.ingamePlayers.firstIndex(of: ingamePlayer)!
                HStack {
                    Text("\(index+1)")
                        .font(.system(size: 16, weight: endGameVM.sellerIndex == index || endGameVM.winnerIndex == index ? .medium : .bold))
                        .foregroundColor(endGameVM.sellerIndex == index || endGameVM.winnerIndex == index ? .gray : .red)
                    Text(ingamePlayer)
                        .font(.system(size: 16, weight: endGameVM.sellerIndex == index || endGameVM.winnerIndex == index ? .medium : .bold))
                    if endGameVM.sellerIndex == index {
                        PopUpIcon(title: "광팜", color: .gray, size: 12)
                    } else if endGameVM.winnerIndex == index {
                        PopUpIcon(title: "승자", color: .gray, size: 12)
                    }
                    Spacer()
                    if endGameVM.sellerIndex == index {
                        Text("\(endGameVM.sellerInput[endGameVM.sellerIndex]) 장")
                            .foregroundColor(.gray)
                    }
                    if endGameVM.winnerIndex == index {
                        Text("\(endGameVM.winnerInput[endGameVM.winnerIndex]) 장")
                            .foregroundColor(.gray)
                    }
                    
                }
                if endGameVM.sellerIndex == index || endGameVM.winnerIndex == index {
                    HStack {
                        Text("  ")
                        Spacer()
                        Rectangle()
                            .frame(width: 135, height: 1)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, -20)
                    .padding(.bottom, 10)
                } else {
                    HStack {
                        loseOptionSelecter(loserOptionArray: $endGameVM.loserOption[index])
                    }
                }
                    
            }//foreach
            .padding(.horizontal)
            .padding(.horizontal)
            Spacer()
            PushView(destination: LastView(mainPageHistory: mainPageHistory,
                                           coreDM: coreDM,
                                           endGameVM: endGameVM))
            {
                HStack {
                    Spacer()
                    Text("금액 계산")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .foregroundColor(.red)
            )
            .padding(.horizontal)
        }
    }
    struct loseOptionSelecter: View {
        
        @Binding var loserOptionArray: [Bool]
        
        var body: some View {
            Button {
                loserOptionArray[0].toggle()
            } label: {
                PopUpIcon(title: "피박", color: loserOptionArray[0] == false ? .gray : .red, size: 16)
            }
            Button {
                loserOptionArray[1].toggle()
            } label: {
                PopUpIcon(title: "광박", color: loserOptionArray[1] == false ? .gray : .red, size: 16)
            }
            Button {
                loserOptionArray[2].toggle()
            } label: {
                PopUpIcon(title: "멍박", color: loserOptionArray[2] == false ? .gray : .red, size: 16)
            }
            Button {
                loserOptionArray[3].toggle()
            } label: {
                PopUpIcon(title: "고박", color: loserOptionArray[3] == false ? .gray : .red, size: 16)
            }
            Spacer()
        }
    }
}

struct EndGameLoserRecord_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager().persistentContainer.viewContext
        let testHistory = MainPageHistory(context: context)
        
        testHistory.historyName = "2021.09.21"
        
        return EndGameLoserRecord(mainPageHistory: testHistory,
                                  coreDM: CoreDataManager(),
                                  endGameVM: EndGameViewModel())
    }

}

struct LastView: View {
    var mainPageHistory: MainPageHistory
    let coreDM: CoreDataManager
    @ObservedObject var endGameVM: EndGameViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("게임종료")
                    .font(.system(size: 14))
                    .bold()
            }
            divideRectangle()
                .padding(.horizontal, -20)
            Spacer()
            Image("confetti")
            Spacer()
        }
    }
}

struct LastView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = CoreDataManager().persistentContainer.viewContext
        let testHistory = MainPageHistory(context: context)
        
        testHistory.historyName = "2021.09.21"
        
        return LastView(mainPageHistory: testHistory,
                 coreDM: CoreDataManager(),
                 endGameVM: EndGameViewModel())
    }
}
