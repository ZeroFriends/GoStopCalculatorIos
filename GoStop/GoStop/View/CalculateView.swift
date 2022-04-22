//
//  CalculateView.swift
//  GoStop
//
//  Created by 이태현 on 2022/04/23.
//

import SwiftUI

struct CalculateView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var mainPageHistory: MainPageHistory
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationBarHidden(true)
    }
}

struct CalculateView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager().persistentContainer.viewContext
        let testHistory = MainPageHistory(context: context)
        
        CalculateView(mainPageHistory: testHistory)
    }
}
