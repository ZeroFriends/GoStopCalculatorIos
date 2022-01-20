//
//  NavigationViewTest.swift
//  GoStop
//
//  Created by 이태현 on 2022/01/18.
//

import SwiftUI

struct GuideView: View {
    @ObservedObject var viewModel: MainPageViewModel
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            viewModel.chooseNavigationButton()
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text("가이드")
                        .fontWeight(.bold)
                    Spacer()
                    Button {
                        withAnimation {
                            viewModel.chooseNavigationButton()
                        }
                    } label: {
                        Image(systemName: "multiply")
                            .foregroundColor(.black)
                    }
                }
                .padding([.top, .leading, .trailing], 25.0)
                .font(.system(size: 18))
                ZStack {
                    Color.red
                        .ignoresSafeArea(.all, edges: .bottom)
                    Image("그룹 93")
                        .offset(y: 70)
                    VStack {
                        Spacer()
                        Button {
                            
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 26)
                                    .frame(width: 318, height: 52, alignment: .bottom)
                                    .foregroundColor(.black)
                                Text("시작하기")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .font(.system(size: 16))
                            }
                        }
                    }
                }
            }
            
            
        }
    }
}

struct NavigationViewTest_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MainPageViewModel()
        GuideView(viewModel: viewModel)
    }
}
