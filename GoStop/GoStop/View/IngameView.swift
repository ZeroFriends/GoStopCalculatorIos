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
        ZStack {
            NavigationLink(isActive: $toGoHome) {
                MainPage()
            } label: { }
            VStack {
                HStack {
                    Button {
                        toGoHome = true
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text(ingameHistory.historyName!)
                        .font(.system(size: 14))
                        .bold()
                    Spacer()
                    Text("게임규칙")
                        .font(.system(size:14))
                        .foregroundColor(.red)
                }
                .padding()
                divideRectangle()
                
            }
        }//ZStack
        .navigationBarHidden(true)
    }
}

struct divideRectangle: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/)
    }
}

struct IngameView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager().persistentContainer.viewContext
        let testHistory = MainPageHistory(context: context)
        
        testHistory.historyName = "2021.09.21"
        
        return IngameView(ingameHistory: testHistory).environment(\.managedObjectContext, context)
    }
}
