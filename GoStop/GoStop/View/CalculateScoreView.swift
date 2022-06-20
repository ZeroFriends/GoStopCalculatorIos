//
//  CalculateScoreView.swift
//  GoStop
//
//  Created by 이태현 on 2022/05/18.
//

import SwiftUI

struct CalculateScoreView: View {
    
    @Environment(\.presentationMode) var presentationmode
    @State var standard = optionScore()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presentationmode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                }
                Spacer()
                Text("점수 계산 법")
                    .font(.system(size: 14))
                    .bold()
                Spacer()
                Image(systemName: "multiply")
                    .foregroundColor(.black)
                    .opacity(0)
            }
            .padding(.horizontal)
            divideRectangle()
            HStack {
                Text("고스톱 설명서")
                    .font(.system(size: 24, weight: .bold))
                Spacer()
            }
            .padding(.bottom)
            .padding(.horizontal)
            ZStack {
                HStack(spacing: 135) {
                    Rectangle()
                        .frame(width: 1, height: 80)
                    Rectangle()
                        .frame(width: 1, height: 80)
                }
                .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.941))

                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.941))
                VStack(spacing: 20) {
                    HStack(spacing: 65) {
                        Button {
                            
                        } label: {
                            Text("옵션 점수")
                                .foregroundColor(.black)
                                .font(.system(size: 14, weight: .bold))
                        }
                        Button {
                            
                        } label: {
                            Text("승자 점수")
                                .foregroundColor(.black)
                                .font(.system(size: 14, weight: .bold))
                        }
                        Button {
                            
                        } label: {
                            Text("패자 점수")
                                .foregroundColor(.black)
                                .font(.system(size: 14, weight: .bold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    HStack(spacing: 40) {
                        Button {
                            
                        } label: {
                            Text("화투점수 계산")
                                .foregroundColor(.black)
                                .font(.system(size: 14, weight: .bold))
                        }
                        Button {
                            
                        } label: {
                            Text("점수 2배 만들기")
                                .foregroundColor(.black)
                                .font(.system(size: 14, weight: .bold))
                        }
                        Button {
                            
                        } label: {
                            Text("게임진행 방법")
                                .foregroundColor(.black)
                                .font(.system(size: 14, weight: .bold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }//ZStack
            Rectangle()
                .frame(height:10)
                .padding(.horizontal, -20)
                .padding(.top, -7)
                .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.941))
            ZStack {
//                Color.gray.ignoresSafeArea()
                Color("ExplainColor").ignoresSafeArea()
                ScrollView {
                    standard
                        .padding(.horizontal)
                }
            }
            .padding(.top, -8)
        }//VStack
        .navigationBarHidden(true)
    }
    
    struct optionScore: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("뻑")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
                Text("첫 뻑 : 첫 턴에 뻑을 저지른 경우 설정금액 즉시 획득.")
                Text("연 뻑 : 첫 뻑을 저지른 다음 턴에서 다시 뻑을 저지른 경우 설정 금액의 2배 죽시 지급")
                Text("삼연뻑 : 연뻑을 저지른 다음 턴에 다시 뻑을 저지른 경우. 12점의 점수로 게임 종료. 설정금액의 4배 즉시 획득")
                Divider()
            }
            .font(.system(size: 14, weight: .medium))
            .padding(.vertical)
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("첫 따닥")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
                Text("첫 턴에 따닥을 성공시킨 경우, 점수에는 계산되지 않으나 3점에 해당하는 금액을 게임 도중에 즉시 획득.")
            }
            .font(.system(size: 14, weight: .medium))
        }
    }
    
}

struct CalculateScoreView_Previews: PreviewProvider {
    static var previews: some View {
        CalculateScoreView()
    }
}
