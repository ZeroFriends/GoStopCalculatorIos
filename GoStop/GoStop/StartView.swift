//
//  StartView.swift
//  GoStop
//
//  Created by 이태현 on 2022/01/24.
//

import SwiftUI

struct StartView: View {
    @ObservedObject var viewModel: MainPageViewModel
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            viewModel.chooseStartbtn()
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }
                }
            }
        }
        
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MainPageViewModel()
        StartView(viewModel: viewModel)
    }
}
