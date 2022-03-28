//
//  MainScreen.swift
//  GoStop
//
//  Created by 이태현 on 2022/01/17.
//

import SwiftUI

struct FirstScreen: View {
    @State var mainScreenOn = false
    @State var cnt = 0
    let coreDM: CoreDataManager
    
    var body: some View {
        ZStack {
            MainPage(coreDM: coreDM)
            
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
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        FirstScreen(coreDM: CoreDataManager())
    }
}
