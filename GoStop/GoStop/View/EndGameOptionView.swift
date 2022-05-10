//
//  EndGameOptionView.swift
//  GoStop
//
//  Created by 이태현 on 2022/05/10.
//

import SwiftUI

struct EndGameOptionView: View {
    @Binding var rootIsActive: Bool
    @Binding var goToOption: Bool
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onTapGesture {
                goToOption = false
                rootIsActive = false
            }
    }
}

struct EndGameOptionView_Previews: PreviewProvider {
    static var previews: some View {
        EndGameOptionView(rootIsActive: .constant(false),goToOption: .constant(false))
    }
}
