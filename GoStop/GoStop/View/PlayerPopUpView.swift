//
//  PlayerPopUpView.swift
//  GoStop
//
//  Created by 이태현 on 2022/03/28.
//

import SwiftUI

struct PlayerPopUpView: View {
    @Binding var players: [String]
    @Binding var originIndex: Int
    @Binding var show: Bool
    @State var playerName = ""
    @State var guideText = ""
    
    var body: some View {
        ZStack {
            if show {
                // PopUp background color
                Color.black.opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)
                // PopUp Window
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.white)
                        VStack {
                            HStack {
                                Spacer()
                                Text("이름수정하기")
                                    .frame(maxWidth: .infinity)
                                    .font(Font.system(size: 14, weight: .bold))
                                    .padding(.leading, 35.0)
                                Spacer()
                                Button {
                                    withAnimation(.linear(duration: 0.3)) {
                                        show = false
                                    }
                                } label: {
                                    Image(systemName: "multiply")
                                        .foregroundColor(.black)
                                        .padding(.trailing)
                                }
                            }
                            .padding(.vertical)
                            Spacer()
                            Spacer()
                            TextField("\(players[originIndex])", text: $playerName)
                                .textFieldStyle(OvalTextFieldStyle())
                                .keyboardType(.default)
                                .padding(.horizontal)
                            HStack {
                                Text(guideText)
                                    .foregroundColor(.red)
                                    .font(.system(size: 10, weight: .bold))
                                Spacer()
                            }
                            .padding(.leading)
                            Spacer()
                            Button {
                                if players.contains(playerName) || playerName == "" {
                                    guideText = "중복된 플레이어 이름이있습니다."
                                } else if players.count > 8 {
                                  guideText = "이름 최대 8자를 초과할 수 없습니다."
                                } else {
                                    players.insert(playerName, at: originIndex)
                                    players.remove(at: originIndex+1)
                                    show = false
                                }
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(.red)
                                    Text("수정하기")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .frame(height: 40)
                                .padding([.leading, .bottom, .trailing])
                            }
                        }
                    }
                }
                .frame(height:220)
                .frame(maxWidth: 310)
            }
        }
    }
}

struct PlayerPopUpView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerPopUpView(players: .constant(["test1", "test2"]), originIndex: .constant(0), show: .constant(true))
    }
}
