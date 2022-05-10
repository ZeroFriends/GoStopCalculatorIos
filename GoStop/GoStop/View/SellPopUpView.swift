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
                        Text(subTitle)
                            .foregroundColor(.gray)
                            .font(.system(size: 12, weight: .medium))
                        Spacer()
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
