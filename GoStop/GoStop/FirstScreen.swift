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
    let saveAction: ()->Void
    
    
    var body: some View {
        ZStack {
            MainPage()
            
            if !mainScreenOn {
                LottieAnimationView()
                    .background(Color.white.edgesIgnoringSafeArea(.all))
                    .transition(.opacity)
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    mainScreenOn.toggle()
                }
            }
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var history = MainPageHistory(date: "2022-01-17", historyName: "2021-09-24", rule: CostRule(jumDant: 0, ppuck: 0, tatack: 0, sell: 0))
    static var mainPageHistory: [MainPageHistory] = [history]
    
    static var previews: some View {
        FirstScreen(mainPageHistories: .constant(mainPageHistory), saveAction: {} )
    }
}
