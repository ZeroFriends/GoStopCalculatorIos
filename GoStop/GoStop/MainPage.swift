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
    
    var body: some View {
        if isNavigationViewReady == false && readyForStart == false {
                ZStack {
                    VStack {
                        TopMainPage(isNavigationViewReady: $isNavigationViewReady, readyForstart: $readyForStart)
                        Rectangle()
                            .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.941))
                            .frame(height: 10)
                        BottomMainPage()
                }
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
                            .frame(width: 328, height: 44)
                    }
                    .foregroundColor(.white)
                }
                .frame(width: 328, height: 44)
            }
            .padding()
        }
        .padding(.horizontal)
    }
}

struct BottomMainPage: View {
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
                }
                .padding(.horizontal)
                Spacer()
                // data.isempty
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
                // else {}
                // text(date.now)
                // text(title) <- 입력받은 텍스트필드 데이터
            }
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
