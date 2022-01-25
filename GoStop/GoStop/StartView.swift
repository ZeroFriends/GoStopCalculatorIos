//
//  StartView.swift
//  GoStop
//
//  Created by 이태현 on 2022/01/24.
//

import SwiftUI

struct StartView: View {
    @Binding var isPresent: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            isPresent.toggle()
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text("게임설정(1/2)")
                    Spacer()
                }
            }
        }
        
    }
}

//struct StartView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartView()
//    }
//}
