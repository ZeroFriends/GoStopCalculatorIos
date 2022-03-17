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
    
    let coreDM: CoreDataManager
    
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
            }
        } else if isNavigationViewReady == true && readyForStart == false {
            GuideView(isNavigationViewReady: $isNavigationViewReady, readyForStart: $readyForStart)
        } else {
            StartView(isPresent: $readyForStart)
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
                Spacer()
            }
            HStack {
                Text("오늘의 게임 👊")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 12.5).fill().foregroundColor(.white)
                    RoundedRectangle(cornerRadius: 12.5).stroke(lineWidth: 2).foregroundColor(.orange)
        
                    Button {
                        withAnimation {
                            isNavigationViewReady.toggle()
                        }
                    } label: {
                        Text("Guide")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.orange)
                }
                .frame(width: 57, height: 25)
            }
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 100).fill().foregroundColor(.red)
                    Button{
                        //시작하기 버튼 action
                        
                        withAnimation {
                            readyForstart.toggle()
                        }
                    } label: {
                        Text("시작하기")
                            .fontWeight(.bold)
                            .frame(height: 44)
                    }
                    .foregroundColor(.white)
                }
                .frame(height: 44)
            }
            .padding(.vertical)
        }
        .padding(.horizontal)
    }
}

struct BottomMainPage: View {
    let coreDM: CoreDataManager
    @State var showingAlert = false
    @State var mainPageHistories: [MainPageHistory] = []
    func populateAllMainPageHistories() {
        mainPageHistories = coreDM.getAllMainPageHistories()
    }
    
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
                    Spacer()
                }
                HStack {
                    Text("진행내역 🤝")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    Spacer()
                    Button("Save Test") {
                        coreDM.saveMainPageHistory()
                        populateAllMainPageHistories()
                    }
                }
                .padding(.horizontal)
                Spacer()
                
                if mainPageHistories.isEmpty {
                    VStack {
                        Image("group118")
                        Text("게임을 추가한 내역이 없습니다.")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                        HStack {
                            Text("상단에")
                            Text("시작하기")
                                .underline()
                                .fontWeight(.bold)
                            Text("버튼을 눌러 게임을 생성해주세요.")
                        }
                        .font(.system(size: 14))
                    }
                    Spacer()
                    Spacer()
                } else {
                    ScrollView {
                        VStack {
                            ForEach(mainPageHistories.reversed(), id: \.self) { history in
                                NavigationLink {
                                    IngameView()
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 18).fill().foregroundColor(.white)
                                        RoundedRectangle(cornerRadius: 18).stroke().foregroundColor(.gray)
                                        HStack {
                                            VStack(alignment: .leading, spacing: 3) {
                                                Text("생성일자 \(history.date ?? Date(), formatter: dateformat)")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.gray)
                                                Text(history.historyName ?? "")
                                                    .fontWeight(.bold)
                                                    .font(.system(size: 20))
                                            }
                                            .padding()
                                            Spacer()
                                            Button {
                                                showingAlert = true
                                            } label: {
                                                Image("moreVertBlack24Dp1")
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                                    .padding(.trailing)
                                            }
                                            .alert(isPresented: $showingAlert) {
                                                Alert(title: Text("삭제하시겠습니까?"), message: nil, primaryButton: .destructive(Text("삭제"), action: {
                                                    coreDM.deleteMainPageHistory(mainPageHistory: history)
                                                    populateAllMainPageHistories()
                                                }), secondaryButton: .cancel(Text("취소")))
                                            }
                                            
                                        }
                                        .foregroundColor(.black)
                                    }
                                    .frame(height: 67)
                                }
                                .padding([.top, .leading, .trailing])
                            }
                        }
                    }
                }
        }
        .onAppear {
            populateAllMainPageHistories()
        }
    }
}



struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage(coreDM: CoreDataManager())
    }
}
