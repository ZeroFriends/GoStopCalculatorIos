//
//  EndGameSellView.swift
//  GoStop
//
//  Created by 이태현 on 2022/05/10.
//

import NavigationStack
import SwiftUI
import UIKit

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
    
    @State var nextActivity = false
    
    @State var sellerAlert = false
    
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
                        self.hideKeyboard()
                    } label: {
                        PopUpIcon(title: "광팔 수 있는 패", color: .red, size: 14)
                    }
                }
                .padding()
                ScrollView {
//                    VStack {
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
//                                    endGameVM.seller = Array(repeating: false, count: 4)
//                                    endGameVM.sellerInput = ["","","",""]
//                                    endGameVM.seller[index] = true
//                                    endGameVM.sellerIndex = index
                                } label: {
                                    HStack {
                                        TextField("0", text: $endGameVM.sellerInput[index])
                                            .multilineTextAlignment(.trailing)
                                            .keyboardType(.numberPad)
                                            .foregroundColor(.black)
                                        Text("장")
                                            .foregroundColor(endGameVM.seller[index] ? .black : .gray)
                                    }
                                }
                                .onChange(of: endGameVM.sellerInput[index]) { _ in
                                    if endGameVM.sellerInput[index] != "" {
                                        endGameVM.seller[index] = true
                                        endGameVM.sellerIndex = index
                                        
                                        for i in 0 ..< 4 {
                                            if i != index {
                                                endGameVM.seller[i] = false
                                                endGameVM.sellerInput[i] = ""
                                            }
                                        }
                                    }
                                    if endGameVM.sellerInput.filter({ $0 == "" }).count == 4 {
                                        nextActivity = false
                                    }
                                }//숫자입력부분 제외한 나머지 부분 false 처리위함
                            }
                            .onChange(of: endGameVM.sellerInput[index]) { _ in
                                if endGameVM.sellerInput[index] != "" {
                                    if Int(endGameVM.sellerInput[index]) ?? 0 > 0 && Int(endGameVM.sellerInput[index]) ?? 0 <= 12 {
                                        nextActivity = true
                                    } else {
                                        nextActivity = false
                                    }
                                    if Int(endGameVM.sellerInput[index]) ?? 0 > 12 {
                                        sellerAlert = true
                                        endGameVM.sellerInput[index] = "12"
                                    }
                                }
                            }//alert활성화
                            .alert(isPresented: $sellerAlert) {
                                Alert(title: Text(""), message: Text("광팔기는 최대 12장 까지 가능합니다."), dismissButton: .destructive(Text("확인")))
                            }
                            .padding(.horizontal)
                            HStack {
                                Text("  ")
                                Spacer()
                                Rectangle()
                                    .frame(width: 135, height: 1)
                                    .foregroundColor(endGameVM.seller[index] ? .red : .gray)
                            }
                            .padding(.top, -15)//15
                            .padding(.bottom, 10)//10
                        }
//                    }
                }//ScrollView
                .padding(.horizontal)
                Spacer()
                PushView(destination: EndGameOptionView(mainPageHistory: mainPageHistory,
                                                        coreDM: coreDM,
                                                        endGameVM: endGameVM))
                {
                    ZStack {
                        RoundedRectangle(cornerRadius: 22)
                            .foregroundColor(nextActivity ? .red : .gray)
                            .frame(height: 44)
                        Text("다음(1/4)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                }
                .disabled(!nextActivity)
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
    let subTitle = "점수기록"
    let subExplain = "운이 좋네요!\n해당하는 곳에 체크를 해주세요."
    
    @State var showingAlert = false
    @State var pushActivity = false
    
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
                        PopUpIcon(title: "고스톱 설명서", color: .red, size: 14)
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
                            .padding(.top, -15)
                            .padding(.bottom, 10)
                        } else {
                            HStack {
                                optionSelecter(optionIndex: $endGameVM.selectOption[index],
                                    tatacIndex:
                                                $endGameVM.firstTatac[index])
                            }
                            .padding(.bottom, 10)
                            .onChange(of: endGameVM.selectOption[index]) { _ in
                                if endGameVM.selectOption[index] == 2 {
                                    showingAlert = true
                                }
                            }
//                            .alert(isPresented: $showingAlert) {
//                                Alert(title: Text("삼연뻑이 있습니다"), message: Text("게임을 종료하시겠습니까?"), primaryButton: .destructive(Text("확인"), action: {
//                                        pushActivity = true
//                                }), secondaryButton: .cancel(Text("취소")))
//                            }
                            .alert(isPresented: $showingAlert) {
                                Alert(title: Text("삼연뻑이 있습니다"), message: Text("게임을 종료하시겠습니까?"), primaryButton: .destructive(Text("확인"), action: {
                                    pushActivity = true
                                }), secondaryButton: .cancel(Text("취소"), action: {
                                    for i in 0 ..< 4 {
                                        endGameVM.selectOption[i] = -1
                                    }
                                }))
                            }
                        }
                }
                .padding(.horizontal)
                .padding(.horizontal)
                Spacer()
                PushView(destination: LastView(mainPageHistory: mainPageHistory, coreDM: coreDM, endGameVM: endGameVM), isActive: $pushActivity) {}
                PushView(destination: EndGamewinnerRecord(mainPageHistory: mainPageHistory,
                                                          coreDM: coreDM,
                                                          endGameVM: endGameVM))
                {
                    ZStack {
                        RoundedRectangle(cornerRadius: 22)
                            .foregroundColor(.red)
                            .frame(height: 44)
                        Text(endGameVM.ingamePlayers.count == 4 ? "다음(2/4)" : "다음(1/3)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard, edges: .bottom)
//        .onChange(of: showingAlert) { _ in
//            if showingAlert == false {
////                endGameVM.selectOption[2] = -1
//                for i in 0 ..< 4 {
//                    endGameVM.selectOption[i] = -1
//                }
//            }
//        }
    }
    struct optionSelecter: View {
        
        @Binding var optionIndex: Int
        @Binding var tatacIndex: Bool
        
        var body: some View {
            Button {
                optionIndex =  optionIndex == 0 ? -1 : 0
            } label: {
                PopUpIcon(title: "첫 뻑", color: optionIndex != 0 ? .gray : .red, size: 16)
            }
            Button {
                optionIndex =  optionIndex == 1 ? -1 : 1
            } label: {
                PopUpIcon(title: "연 뻑", color: optionIndex != 1 ? .gray : .red, size: 16)
            }
            Button {
                optionIndex =  optionIndex == 2 ? -1 : 2
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
    
    @State var nextActivity = false
    @State var maximumValueAlert = false
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
                        PopUpIcon(title: "고스톱 설명서", color: .red, size: 14)
                    }
                }
                .padding()
                ScrollView {
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

                            if endGameVM.sellerIndex != -1 {//광팔기가 존재한다면
                                if endGameVM.sellerIndex == index {
                                    Text("\(endGameVM.sellerInput[endGameVM.sellerIndex]) 장")
                                        .foregroundColor(.gray)
                                } else {
                                    Button {
                                        
                                    } label: {
                                        TextField("0", text: $endGameVM.winnerInput[index])
                                            .multilineTextAlignment(.trailing)
                                            .keyboardType(.numberPad)
                                            .foregroundColor(.black)
                                            .onChange(of: endGameVM.winnerInput[index]) { _ in
                                                    
                                                if endGameVM.winnerInput[index] != "" {
                                                        endGameVM.winner[index] = true
                                                        endGameVM.winnerIndex = index
                                                        
                                                        for i in 0 ..< 4 {
                                                            if i != index {
                                                                endGameVM.winner[i] = false
                                                                endGameVM.winnerInput[i] = ""
                                                            }
                                                        }
                                                    if Int(endGameVM.winnerInput[index]) ?? 0 > 0 && Int(endGameVM.winnerInput[index]) ?? 0 < 8519680 {
                                                        nextActivity = true
                                                        
                                                    } else {
                                                        nextActivity = false
                                                    }
                                                    if Int(endGameVM.winnerInput[index]) ?? 0 > 8519680 {
                                                        maximumValueAlert = true
                                                        endGameVM.winnerInput[index] = "0"
                                                    }
                                                }
                                                if endGameVM.winnerInput.filter({ $0 == "" }).count != 3 {
                                                    nextActivity = false
                                                } else {
                                                    nextActivity = true
                                                }
                                            }
                                        Text("점")
                                            .foregroundColor(.black)
                                    }
                                }
                            } else {
                                Button {
//                                    endGameVM.winner = Array(repeating: false, count: 4)
//                                    endGameVM.winnerInput = ["","","",""]
//                                    endGameVM.winner[index] = true
//                                    endGameVM.winnerIndex = index
                                } label: {
                                    TextField("0", text: $endGameVM.winnerInput[index])
                                        .multilineTextAlignment(.trailing)
                                        .keyboardType(.numberPad)
                                        .foregroundColor(.black)
                                        .onChange(of: endGameVM.winnerInput[index]) { _ in
                                                
                                            if endGameVM.winnerInput[index] != "" {
                                                    endGameVM.winner[index] = true
                                                    endGameVM.winnerIndex = index
                                                    
                                                    for i in 0 ..< 4 {
                                                        if i != index {
                                                            endGameVM.winner[i] = false
                                                            endGameVM.winnerInput[i] = ""
                                                        }
                                                    }
                                                if Int(endGameVM.winnerInput[index]) ?? 0 > 0 && Int(endGameVM.winnerInput[index]) ?? 0 < 8519680 {
                                                    nextActivity = true
                                                    
                                                } else {
                                                    nextActivity = false
                                                }
                                                if Int(endGameVM.winnerInput[index]) ?? 0 > 8519680 {
                                                    maximumValueAlert = true
                                                    endGameVM.winnerInput[index] = "0"
                                                }
                                            }
                                            if endGameVM.winnerInput.filter({ $0 == "" }).count != 3 {
                                                nextActivity = false
                                            } else {
                                                nextActivity = true
                                            }
                                        }
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
                            .padding(.top, -15)
                            .padding(.bottom, 10)
                        } else {
                            HStack {
                                Text("  ")
                                Spacer()
                                Rectangle()
                                    .frame(width: 135, height: 1)
                                    .foregroundColor(endGameVM.winner[index] ? .red : .white)
                            }
                            .padding(.top, -15)
                            .padding(.bottom, 10)
                        }
                    }//foreach
                    .padding(.horizontal)
                    .alert(isPresented: $maximumValueAlert) {
                        Alert(title: Text(""), message: Text("고스톱에서 날 수 있는 가장 큰 점수는 8,519,680점입니다."), dismissButton: .destructive(Text("확인")))
                    }
                }//ScrollView
                .padding(.horizontal)
                Spacer()
                PushView(destination: EndGameLoserRecord(mainPageHistory: mainPageHistory,
                                                         coreDM: coreDM,
                                                         endGameVM: endGameVM))
                {
                    ZStack {
                        RoundedRectangle(cornerRadius: 22)
                            .foregroundColor(nextActivity ? .red : .gray)
                            .frame(height: 44)
                        Text(endGameVM.ingamePlayers.count == 4 ? "다음(3/4)" : "다음(2/3)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .disabled(!nextActivity)
            }//VStack
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard, edges: .bottom)
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
    
    @State var showingAlert = false
    @State var pushActivity = false
    
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
                    PopUpIcon(title: "고스톱 설명서", color: .red, size: 14)
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
                    .onChange(of: endGameVM.loserOption[index][3]) { _ in
                        if endGameVM.loserOption[index][3] == true {
                            for i in 0 ..< 4 {
                                if i != index {
                                    endGameVM.loserOption[i][3] = false
                                }
                            }
                        }
                    }
                }
                    
            }//foreach
            .padding(.horizontal)
            .padding(.horizontal)
            Spacer()
            PushView(destination: LastView(mainPageHistory: mainPageHistory,
                                           coreDM: coreDM,
                                           endGameVM: endGameVM), isActive: $pushActivity) { }
            
            Button {
                 showingAlert = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 22)
                        .foregroundColor(.red)
                        .frame(height: 44)
                    Text("금액 계산")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("해당 라운드의 금액 계산을 하시겠습니까?"), message: nil, primaryButton: .destructive(Text("확인"), action: {
                    pushActivity = true
            }), secondaryButton: .cancel(Text("취소")))
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
    @State private var isCompleted = false
    
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
            Text("수고하셨습니다!")
                .font(.system(size: 24, weight: .bold))
            HStack {
                Text("하단에")
                Text("저장하기")
                    .underline()
                    .fontWeight(.bold)
                Text("버튼을 누르고 다음게임을 진행해주세요.")
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(CustomColor.lastViewTextColor)
            Spacer()

            VStack {
                HStack {
                    Text("\(mainPageHistory.rounds.count) 라운드")
                    Spacer()
                }
                let columns = [
                        GridItem(.adaptive(minimum: 120))
                    ]
                LazyVGrid(columns: columns) {
                    ForEach(endGameVM.ingamePlayers, id: \.self) { player in
                        let index = endGameVM.ingamePlayers.firstIndex(of: player)!
                        VStack {
                            HStack {
                                if index == endGameVM.sellerIndex {
                                    Text("광팜")
                                        .font(.system(size: 8, weight: .medium))
                                } else if index == endGameVM.winnerIndex {
                                    Text("승자")
                                        .font(.system(size: 8, weight: .medium))
                                } else {
                                    Text("  ")
                                        .font(.system(size: 8, weight: .medium))
                                }
                                Spacer()
                            }
                            .padding(.leading, 16)
                            HStack {
                                Text("\(index+1)")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.red)
                                Text(player)
                                    .font(.system(size: 14, weight: .medium))
                                Spacer()
                                Text("\(endGameVM.totalCost[index])")
                                Text("원")
                                    .font(.system(size: 12, weight: .medium))
                            }
                            HStack {
                                if endGameVM.selectOption[index] == 0 {
                                    Text("첫뻑")
                                        .font(.system(size: 8, weight: .medium))
                                }
                                if endGameVM.selectOption[index] == 1 {
                                    Text("연뻑")
                                        .font(.system(size: 8, weight: .medium))
                                }
                                if endGameVM.selectOption[index] == 2 {
                                    Text("삼연뻑")
                                        .font(.system(size: 8, weight: .medium))
                                }
                                if endGameVM.firstTatac[index] == true {
                                    Text("첫따닥")
                                        .font(.system(size: 8, weight: .medium))
                                }
                                if endGameVM.loserOption[index][0] == true {
                                    Text("피박")
                                        .font(.system(size: 8, weight: .medium))
                                }
                                if endGameVM.loserOption[index][1] == true {
                                    Text("광박")
                                        .font(.system(size: 8, weight: .medium))
                                }
                                if endGameVM.loserOption[index][2] == true {
                                    Text("멍박")
                                        .font(.system(size: 8, weight: .medium))
                                }
                                if endGameVM.loserOption[index][3] == true {
                                    Text("고박")
                                        .font(.system(size: 8, weight: .medium))
                                }
                                Text("")
                                Spacer()
                            }
                            .padding(.leading, 16)
                        }
                    }
                }
            }// 라운드 이름, 플레이어, 금액 다 나와야하는곳
            .padding()
            .background (
                RoundedRectangle(cornerRadius: 18)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 5, x: 0, y: 3)
            )
            .padding(.horizontal)
            PopView(destination: .root) {
                ZStack {
                    RoundedRectangle(cornerRadius: 22)
                        .foregroundColor(.red)
                        .frame(height: 44)
                    Text("저장하기")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            .onAppear {
                //라운드 저장부분

    //            coreDM.saveRoundInMainPageHistory(mainPageHistory: mainPageHistory)
                coreDM.saveRoundOfGameResult(mainPageHistory: mainPageHistory, endGameViewModel: endGameVM)
            }
        }

    }
}

struct LastView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = CoreDataManager().persistentContainer.viewContext
        let testHistory = MainPageHistory(context: context)
        let endGameVM = EndGameViewModel()
        endGameVM.ingamePlayers = ["플레이어 1","플레이어 2"]
        endGameVM.totalCost = [200, -200]
        testHistory.historyName = "2021.09.21"
        
        return LastView(mainPageHistory: testHistory,
                 coreDM: CoreDataManager(),
                 endGameVM: endGameVM)
    }
}
