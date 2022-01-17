//
//  MainPage.swift
//  GoStop
//
//  Created by 이태현 on 2022/01/17.
//

import SwiftUI
import Lottie

struct MainPage: View {
    var body: some View {
            ZStack {
                VStack {
                    TopMainPage()
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(height: 10)
                    BottomMainPage()
            }
        }
    }
}

struct TopMainPage: View {
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
                    Button{
                        
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
                        
                    } label: {
                        Text("시작하기")
                            .fontWeight(.bold)
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
            }
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
