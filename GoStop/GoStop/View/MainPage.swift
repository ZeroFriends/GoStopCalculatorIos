//
//  MainPage.swift
//  GoStop
//
//  Created by 이태현 on 2022/01/17.
//

import SwiftUI

struct MainPage: View {
    @State var isNavigationViewReady = false
    @State var readyForStart = false
    
    let coreDM: CoreDataManager = CoreDataManager()
    
    var body: some View {
        if isNavigationViewReady == false && readyForStart == false {
                ZStack {
                    VStack {
                        TopMainPage(isNavigationViewReady: $isNavigationViewReady, readyForstart: $readyForStart)
                        Rectangle()
                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.941))
                            .frame(height: 10)
                        BottomMainPage(coreDM: coreDM)
                }
                .navigationBarHidden(true)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Button("완료") {
                            self.hideKeyboard()
                        }
                    }
                }
            }
        } else if isNavigationViewReady == true && readyForStart == false {
            GuideView(isNavigationViewReady: $isNavigationViewReady, readyForStart: $readyForStart)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Button("완료") {
                            self.hideKeyboard()
                        }
                    }
                }
        } else {
            StartView(isPresent: $readyForStart, coreDM: coreDM)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Button("완료") {
                            self.hideKeyboard()
                        }
                    }
                }
        }
    }
}

struct TopMainPage: View {
    @Binding var isNavigationViewReady: Bool
    @Binding var readyForstart: Bool
    var body: some View {
        VStack(spacing: 3) {
            HStack {
                Text("NEW GAME")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: 0x212121))
                Spacer()
            }
            HStack {
                Text("오늘의 게임 👊")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 12.5).fill().foregroundColor(.white)
                    RoundedRectangle(cornerRadius: 12.5).stroke(lineWidth: 1).foregroundColor(.red)
        
                    Button {
                        withAnimation {
                            isNavigationViewReady.toggle()
                        }
                    } label: {
                        Text("Guide")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.red)
                }
                .frame(width: 57, height: 25)
            }
            HStack {
                Button{
                    //시작하기 버튼 action
                    
                    withAnimation {
                        readyForstart.toggle()
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 100).fill().foregroundColor(.red)
                            .frame(height: 44)
                        Text("시작하기")
                            .fontWeight(.bold)
                            .frame(height: 44)
                    }
                }
                .foregroundColor(.white)
            }
            .padding(.vertical)
        }
        .padding(.horizontal)
    }
}

struct BottomMainPage: View {
    let coreDM: CoreDataManager
    @State var uselessHistory: MainPageHistory?
    @State var showingAlert = false
    
    var dateformat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"
        return formatter
    }
    var body: some View {
            VStack(spacing: 3) {
                HStack {
                    Text("HISTORY")
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                        .padding([.top, .leading, .trailing])
                        .foregroundColor(Color(hex: 0x424242))
                    Spacer()
                }
                HStack {
                    Text("진행내역 🤝")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, -10)
                Spacer()
                
                if coreDM.mainPageHistoryList.isEmpty {
                    VStack(spacing: 3) {
                        Image("group118")
                            .padding(.bottom, 2)
                        Text("게임을 추가한 내역이 없습니다.")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                        HStack {
                            Text("상단에")
                                .padding(.trailing, -3)
                                .font(.system(size: 12))
                            Text("시작하기")
                                .underline()
                                .fontWeight(.bold)
                                .font(.system(size: 12))
                            Text("버튼을 눌러 게임을 생성해주세요.")
                                .font(.system(size: 12))
                                .padding(.leading, -3)
                        }
                        .font(.system(size: 14))
                    }
                    Spacer()
                    Spacer()
                } else {
                    ScrollView {
                        VStack {
                            ForEach(coreDM.mainPageHistoryList.reversed(), id: \.self) { history in
                                    NavigationLink {
                                        IngameView(coreDM: coreDM, mainPageHistory: history)
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 18).fill().foregroundColor(.white)
                                                .shadow(color: Color(hex: 0xbdbdbd), radius: 3, x: 0, y: 3)
                                            HStack {
                                                VStack(alignment: .leading, spacing: 3) {
                                                    Text("생성일자 \(history.date ?? Date(), formatter: dateformat)")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.gray)
                                                    Text(history.historyName ?? "")
                                                        .fontWeight(.bold)
                                                        .font(.system(size: 20))
                                                }
                                                .padding()//16
                                                Spacer()
                                                Button {
                                                    uselessHistory = history
                                                    showingAlert = true
                                                } label: {
                                                    Image("moreVertBlack24Dp1")
                                                        .resizable()
                                                        .frame(width: 24, height: 24)
                                                        .padding(.trailing)
                                                }
                                                .alert(isPresented: $showingAlert) {
                                                    Alert(title: Text("삭제하시겠습니까?"), message: nil, primaryButton: .destructive(Text("삭제"), action: {
//                                                        print(uselessHistory ?? "no history")
                                                        coreDM.deleteMainPageHistory(mainPageHistory: uselessHistory!)
                                                    }), secondaryButton: .cancel(Text("취소")))
                                                }
                                                
                                            }
                                            .foregroundColor(.black)
                                        }
                                        .frame(height: 67)
                                    }
                                    .padding([.top, .leading, .trailing])
                            }//ForEach
                        }//VStack
                    }
                }
        }
    }
}



struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
