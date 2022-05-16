//
//  SellPopUpView.swift
//  GoStop
//
//  Created by 이태현 on 2022/05/10.
//

import SwiftUI

struct SellPopUpView: View {
    
    @Binding var show: Bool
    
    let title = "광팔 수 있는 패"
    let subTitle = "*지역마다 약간의 다른 규칙이 있을 수 있습니다"
    
    var textList = ["1월","3월","8월","11월","12월"]
    
    var textView: some View {
        HStack {
            Text("1월")
            Spacer(minLength: 38)
            Text("3월")
            Spacer(minLength: 38)
            Text("8월")
            Spacer(minLength: 35)
            Text("11월")
            Spacer()
            Text("12월")
        }
        .padding(.leading, 35)
        .padding(.trailing, 28)
    }
    
    var body: some View {
        ZStack {
            if show {
                Color.black.opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)
                ZStack {
                    Color.white
                    VStack {
                        Text(title)
                            .foregroundColor(.black)
                            .font(.system(size: 20, weight: .bold))
                            .padding(.top)
                            .padding(.bottom, 1)
                        Text(subTitle)
                            .foregroundColor(.gray)
                            .font(.system(size: 12, weight: .medium))
                        Spacer()
                        
                        HStack {
                            Text("광)")
                                .font(.system(size: 16, weight: .bold))
                            Spacer()
                        }
                        .padding(.horizontal)
                        Image("group2")

                        textView
                            .padding(.bottom)
                        HStack {
                            Text("쌍피)")
                                .font(.system(size: 16, weight: .bold))
                            Spacer()
                            Spacer()
                            Text("보너스)")
                                .font(.system(size: 15, weight: .bold))
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Image("group14")
                            Spacer()
                        }
                        .padding(.horizontal)
                        Spacer()
                        
                        Button {
                            show = false
                        } label: {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.red)
                                Text("확인")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .frame(height: 44)
                        }
                    }
                }
                .frame(width: 340, height: 500)
            }
        }
    }
}

struct SellPopUpView_Previews: PreviewProvider {
    static var previews: some View {
        SellPopUpView(show: .constant(true))
    }
}
