//
//  MainScreen.swift
//  GoStop
//
//  Created by 이태현 on 2022/01/17.
//

import SwiftUI

struct FirstScreen: View {
    @State var mainScreenOn = false
    
    var body: some View {
        ZStack {
            MainPage()
            
            if !mainScreenOn {
                LottieAnimationView()
                    .background(Color.white.edgesIgnoringSafeArea(.all))
                    .transition(.opacity)
            }
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
    static var previews: some View {
        FirstScreen()
    }
}
