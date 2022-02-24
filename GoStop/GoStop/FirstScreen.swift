//
//  MainScreen.swift
//  GoStop
//
//  Created by 이태현 on 2022/01/17.
//

import SwiftUI

struct FirstScreen: View {
    @State var mainScreenOn = false
    @Environment(\.scenePhase) var scenePhase
    @Binding var mainPageHistories: [MainPageHistory]
    @State var cnt = 0
    let saveAction: ()->Void
    
    
    var body: some View {
        ZStack {
            MainPage(mainPageHistories: $mainPageHistories)
            
            if !mainScreenOn {
                LottieAnimationView()
                    .background(Color.white.edgesIgnoringSafeArea(.all))
                    .transition(.opacity)
            }
        }
        .onAppear {
            if cnt == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        mainScreenOn.toggle()
                    }
                }
                cnt += 1//이렇게 안하면 첫화면일때 계속 로티이미지 떠버려서 막음
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var history = MainPageHistory(date: "2022-01-17", historyName: "2021-09-24", rule: CostRule())
    static var mainPageHistory: [MainPageHistory] = [history]
    
    static var previews: some View {
        FirstScreen(mainPageHistories: .constant(mainPageHistory), saveAction: {} )
    }
}
