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
    var ingamePlayers: [String] = ["플레이어1","플레이어2","플레이어3","플레이어4"]
    @State var seller: [Bool] = Array(repeating: false, count: 4)// 광팔기 창은 4명이이어야하니까 count == 4
    @State var sellerInput = ["","","",""]//몇장을 팔지 기록용
    let subTitle = "광팔기"
    let subExplain = "4인 플레이경우 한명이 필수로 광을 팔아야 플레이가 가능합니다. 광을 판 플레이어를 선택해주세요"
    @State var sellerIndex = 0
    
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
                    ForEach(ingamePlayers, id: \.self) { ingamePlayer in
                        let index = ingamePlayers.firstIndex(of: ingamePlayer)!
                        HStack {
                            Text("\(index+1)")
                                .font(.system(size: 16, weight: seller[index] ? .bold : .medium))
                                .foregroundColor(.red)
                            Text(ingamePlayer)
                                .font(.system(size: 16, weight: seller[index] ? .bold : .medium))
                            Spacer()
                            Button {
                                seller = Array(repeating: false, count: 4)
                                sellerInput = ["","","",""]
                                seller[index] = true
                                sellerIndex = index
                            } label: {
                                VStack {
                                    HStack {
                                        TextField("-", text: $sellerInput[index])
                                            .multilineTextAlignment(.trailing)
                                            .keyboardType(.decimalPad)
                                            .frame(width: 110)
                                            .foregroundColor(.black)
                                        Text("장")
                                            .foregroundColor(seller[index] ? .black : .gray)
                                    }
                                }
                            }
                        }
                        HStack {
                            Text("  ")
                            Spacer()
                            Rectangle()
                                .frame(width: 135, height: 1)
                                .foregroundColor(seller[index] ? .red : .gray)
                        }
                        .padding(.top, -10)
                        .padding(.bottom, 20)
                    }//이 부분도 충분히 재사용할 수 있음 전환해보자
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                PushView(destination: EndGameOptionView(mainPageHistory: mainPageHistory,
                                                        coreDM: coreDM,
                                                        ingamePlayers: ingamePlayers,
                                                        sellerInput: sellerInput,
                                                        sellerIndex: sellerIndex))
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
                            .foregroundColor(seller.filter{ $0 == true}.count == 1 ? .red : .gray)
                    )
                    .padding(.horizontal)
                    .disabled(seller.filter{ $0 == true}.count == 0)
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
        return EndGameSellView(mainPageHistory: testHistory, coreDM: CoreDataManager())
    }
}

struct EndGameOptionView: View {
    @State var calculateScorePopUp = false
    @Environment(\.presentationMode) var presentationMode
    
    var mainPageHistory: MainPageHistory
    let coreDM: CoreDataManager
    var ingamePlayers: [String] = ["플레이어1","플레이어2","플레이어3","플레이어4"]
    let subTitle = "옵션 점수기록"
    let subExplain = "운이 좋네요!\n해당하는 곳에 체크를 해주세요."
    @State var sellerInput: [String] = ["","","",""]
    let sellerIndex: Int? // 누가 광을 판 사람인지
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
                    ForEach(ingamePlayers, id: \.self) { ingamePlayer in
                        let index = ingamePlayers.firstIndex(of: ingamePlayer)!
                        HStack {
                            Text("\(index+1)")
                                .font(.system(size: 16, weight: sellerIndex == index ? .medium : .bold))
                                .foregroundColor(sellerIndex == index ? .gray : .red)
                            Text(ingamePlayer)
                                .font(.system(size: 16, weight: sellerIndex == index ? .medium : .bold))
                            PopUpIcon(title: "광팜", color: .gray, size: 12)
                                .opacity(sellerIndex == index ? 1 : 0)
                            Spacer()
                            if sellerIndex != nil {
                                Text("\(sellerInput[sellerIndex!]) 장")
                                    .foregroundColor(.gray)
                                    .opacity(sellerIndex == index ? 1 : 0)
                            }
                        }
                        if sellerIndex == index {
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
                                optionSelecter()
                            }
                            .padding(.bottom, 10)
                        }
                }
                .padding(.horizontal)
                .padding(.horizontal)
                Spacer()
                PushView(destination: EndGamewinnerRecord(mainPageHistory: mainPageHistory,
                                                          coreDM: coreDM,
                                                          ingamePlayers: ingamePlayers,
                                                          sellerInput: sellerInput,
                                                          sellerIndex: sellerIndex))
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
        
        @State var firstPuck = false
        @State var secondPuck = false
        @State var thirdPuck = false
        @State var firstTatac = false
        
        var body: some View {
            Button {
                firstPuck.toggle()
                secondPuck = false
                thirdPuck = false
            } label: {
                PopUpIcon(title: "첫 뻑", color: firstPuck == false ? .gray : .red, size: 16)
            }
            Button {
                firstPuck = false
                secondPuck.toggle()
                thirdPuck = false
            } label: {
                PopUpIcon(title: "연 뻑", color: secondPuck == false ? .gray : .red, size: 16)
            }
            Button {
                firstPuck = false
                secondPuck = false
                thirdPuck.toggle()
            } label: {
                PopUpIcon(title: "삼연 뻑", color: thirdPuck == false ? .gray : .red, size: 16)
            }
            Button {
                firstTatac.toggle()
            } label: {
                PopUpIcon(title: "첫 따닥", color: firstTatac == false ? .gray : .red, size: 16)
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
                                 sellerInput: ["","3","",""],
                                 sellerIndex: 1)
    }
}

struct EndGamewinnerRecord: View {
    var mainPageHistory: MainPageHistory
    let coreDM: CoreDataManager
    let subTitle = "승자 점수기록"
    let subExplain = "이긴 플레이어 선택하고,\n몇점을 내었는지 계산 후 점수를 적어주세요"
    var ingamePlayers: [String] = ["플레이어1","플레이어2","플레이어3","플레이어4"]
    @State var sellerInput: [String] = ["","","",""]
    let sellerIndex: Int?
    @State var winner: [Bool] = Array(repeating: false, count: 4)
    @State var winnerInput: [String] = ["","","",""]
    @State var winnerIndex: Int?
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
                ForEach(ingamePlayers, id: \.self) { ingamePlayer in
                    let index = ingamePlayers.firstIndex(of: ingamePlayer)!
                    HStack {
                        Text("\(index+1)")
                            .font(.system(size: 16, weight: sellerIndex == index ? .medium : .bold))
                            .foregroundColor(sellerIndex == index ? .gray : .red)
                        Text(ingamePlayer)
                            .font(.system(size: 16, weight: sellerIndex == index ? .medium : .bold))
                        PopUpIcon(title: "광팜", color: .gray, size: 12)
                            .opacity(sellerIndex == index ? 1 : 0)
                        Spacer()

                        if sellerIndex != nil {
                            if sellerIndex == index {
                                Text("\(sellerInput[sellerIndex!]) 장")
                                    .foregroundColor(.gray)
                            } else {
                                Button {
                                    winner = Array(repeating: false, count: 4)
                                    winnerInput = ["","","",""]
                                    winner[index] = true
                                    winnerIndex = index
                                } label: {
                                    TextField("-", text: $winnerInput[index])
                                        .multilineTextAlignment(.trailing)
                                        .keyboardType(.decimalPad)
                                        .foregroundColor(.black)
                                    Text("점")
                                        .foregroundColor(.black)
                                }
                            }
                        } else {
                            Button {
                                winner = Array(repeating: false, count: 4)
                                winnerInput = ["","","",""]
                                winner[index] = true
                                winnerIndex = index
                            } label: {
                                TextField("-", text: $winnerInput[index])
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.decimalPad)
                                    .foregroundColor(.black)
                                Text("점")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    if sellerIndex == index {
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
                                .foregroundColor(winner[index] ? .red : .white)
                        }
                        .padding(.top, -10)
                        .padding(.bottom, 20)
                    }
            }//foreach
            .padding(.horizontal)
            .padding(.horizontal)
            Spacer()
            PushView(destination: EndGameLoserRecord()) {
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
                                   sellerInput: ["","3","",""],
                                   sellerIndex: 1)
    }
}

struct EndGameLoserRecord: View {
    var body: some View {
        Text("loser record view")
    }
}
