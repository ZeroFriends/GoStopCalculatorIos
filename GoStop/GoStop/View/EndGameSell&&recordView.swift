//
//  EndGameSellView.swift
//  GoStop
//
//  Created by 이태현 on 2022/05/10.
//

import SwiftUI

struct PopUpIcon: View {
    
    var title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.red)
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 13).stroke(lineWidth: 1)
                    .foregroundColor(.red)
            )
    }
}

struct BuildTopView: View {
    @Binding var rootIsActive: Bool
    @Binding var goToPrev: Bool
    
    @Environment(\.presentationMode) var presentationMode
    var mainTitle: String
    var subTitle: String
    var subExplain: String
    
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
                Text(mainTitle)
                    .font(.system(size: 14))
                    .bold()
                Spacer()
                Button {
                    withAnimation {
                        self.rootIsActive = false
                        goToPrev = false
                    }
                } label: {
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
    @Binding var rootIsActive: Bool
    @Binding var goToSell: Bool
    @State var sellListPopUp = false
    
    var mainPageHistory: MainPageHistory
    let coreDM: CoreDataManager
    var ingamePlayers: [String] = ["플레이어1","플레이어2","플레이어3","플레이어4"]
    @State var seller: [Bool] = Array(repeating: false, count: 4)// 광팔기 창은 4명이이어야하니까 count == 4
    @State var sellerInput = ["","","",""]//몇장을 팔지 기록용
    let subTitle = "광팔기"
    let subExplain = "4인 플레이경우 한명이 필수로 광을 팔아야 플레이가 가능합니다. 광을 판 플레이어를 선택해주세요"
    
    var body: some View {
        ZStack {
            VStack {
                BuildTopView(rootIsActive: $rootIsActive,
                         goToPrev: $goToSell,
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
                        PopUpIcon(title: "광팔 수 있는 패")
                    }
                }
                .padding()
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
                Spacer()
                NavigationLink {
                    //옵션 점수기록으로 이동해야함
                } label: {
                    HStack {
                        Spacer()
                        Text("다음(1/4)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                }
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .foregroundColor(seller.filter{ $0 == true}.count == 1 ? .red : .gray)
                )
                .padding(.horizontal)
                .disabled(seller.filter{ $0 == true}.count == 0)
            }
            SellPopUpView(show: $sellListPopUp)
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard)
    }
}

struct EndGameOptionView: View {
    @Binding var rootIsActive: Bool
    @Binding var goToOption: Bool
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onTapGesture {
                goToOption = false
                rootIsActive = false
            }
    }
}
//EndGameView 전체적인 view 의 재사용성에 대한 고민



struct EndGameSellView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager().persistentContainer.viewContext
        let testHistory = MainPageHistory(context: context)

        testHistory.historyName = "2021.09.21"
        return EndGameSellView(rootIsActive: .constant(false),goToSell: .constant(false),mainPageHistory: testHistory, coreDM: CoreDataManager())
    }
}

struct EndGameOptionView_Previews: PreviewProvider {
    static var previews: some View {
        EndGameOptionView(rootIsActive: .constant(false),goToOption: .constant(false))
    }
}
