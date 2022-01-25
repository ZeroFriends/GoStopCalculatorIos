//
//  StartView.swift
//  GoStop
//
//  Created by 이태현 on 2022/01/24.
//

import SwiftUI

struct StartView: View {
    @Binding var isPresent: Bool
    @State var currentPage: Int = 1
    @State var textField = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.red
                    .ignoresSafeArea()
                Image("group183")
                    .position(x: geometry.size.width - 60, y: 40)
                    .aspectRatio(2/3, contentMode: .fit)
                VStack {
                    HStack {
                        Button {
                            withAnimation {
                                isPresent.toggle()
                            }
                        } label: {
                            Image(systemName: "arrow.left")
                        }
                        
                        Spacer()
                        Text("게임설정 (\(currentPage)/2)")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "multiply")
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    VStack {
                        HStack {
                            Text("플레이어 설정 👥")
                                .font(.system(size: 24))
                                .fontWeight(.bold)
                                .padding(.bottom)
                            Spacer()
                        }
                        HStack {
                            Text("최소 플레이어는 2인입니다.\n5인 이상 추가하실 경우 4인 이하만 플레이 할 수 있습니다.")
                                .font(.system(size: 14))
                            Spacer()
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .foregroundColor(.white)
                            .ignoresSafeArea()
                        VStack(alignment: .leading) {
                            
                            Text("모임이름")
                                .fontWeight(.bold)
                                .font(.system(size: 16))
                            TextField("날짜", text: $textField)
                            //텍스트필드 테두리 수정하기 + 여기서 입력받은 값 어떻게 처리할것인지
                            Text("플레이어")
                                .fontWeight(.bold)
                                .font(.system(size: 16))
                                .padding(.vertical)
                            HStack {
                                Spacer()
                                Text("플레이어 추가 버튼으로 플레이어를 등록해주세요")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            //텍스트필드에 맞는 custom 하기
                            .padding(.vertical)
                            HStack {
                                Spacer()
                                Button {
                                    
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 18).fill().foregroundColor(.white)
                                         RoundedRectangle(cornerRadius: 18).stroke(lineWidth: 2).foregroundColor(.black)
                                        Text("+ 플레이어 추가")
                                            .foregroundColor(.black)
                                            .fontWeight(.bold)
                                    }
                                }
                                .frame(width: 328, height: 36)
                                Spacer()
                            }
                            Spacer()
                            HStack {
                                Spacer()
                                Button {
                                    
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 18).fill().foregroundColor(.gray)
                                    Text("다음")
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                    }
                                }
                                .frame(width: 328, height: 36)
                                Spacer()
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(isPresent: .constant(true))
    }
}
