//
//  IngameView.swift
//  GoStop
//
//  Created by 이태현 on 2022/02/25.
//

import SwiftUI

struct IngameView: View {
    @State var toGoHome = false
    var ingameHistory: MainPageHistory
    
    var body: some View {
        NavigationLink(isActive: $toGoHome) {
            MainPage()
        } label: { }
        Text(ingameHistory.historyName ?? "nil")
            .onTapGesture {
                toGoHome = true
            }
            .navigationBarHidden(true)
    }
}

struct IngameView_Previews: PreviewProvider {
    static var previews: some View {
        IngameView(ingameHistory: MainPageHistory())
    }
}
