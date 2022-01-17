//
//  MainPage.swift
//  GoStop
//
//  Created by 이태현 on 2022/01/17.
//

import SwiftUI

struct MainPage: View {
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("NEW GAME")
                        .font(.system(size: 12))
                        .padding(.horizontal)
                    Spacer()
                }
                HStack {
                    Text("오늘의 게임 👊")
                        .font(.system(size: 24))
                    Spacer()
                    Button("Guide") {}
                    .frame(width: 57, height: 25)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
