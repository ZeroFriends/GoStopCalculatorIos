//
//  HelpPopUpView.swift
//  GoStop
//
//  Created by 이태현 on 2022/03/31.
//

import SwiftUI

struct HelpPopUpView: View {
    @Binding var show: Bool
    
    let jumDang = "점 당 : 게임이 끝나면 점수를 계산해 그에 해당하는 금액을 승자에게 지불. (승자점수x 점 당)"
    let ppuck = "뻑 : 게임이 시작되고 처음 패에서 뻑이 났으면 첫뻑이라 하며, 설정된 금액을 다른 사람에게서 받는다. 연속으로 뻑이 났으면 연뻑이라 하며, 추가로 약속된 금액의 2배, 뻑이 3번 나는 경우 삼연뻑이라 하며, 설정 금액의 4배를 받고 게임승리."
    let tatak = "따닥 : 바닥에 같은 월의 패가 2장 깔려 있을 때, 이를 먹으려고 패를 내려놓고 더미에서 뒤집었을 때 같은 월이 나와서 4장이 한꺼번에 나온 경우, 이를 따닥이라고 한다. "
    let sell = "광팔기 : 4인 고스톱을 치는 경우, 세 명을 제외한 나머지는 게임에서 빠져야 하는데 이를 광팔이라고 한다."
    
    
    var body: some View {
        ZStack {
            if show {
                Color.black.opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)
                ZStack {
                    Color.white
                    VStack {
                        Text("도움말")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top)
                        VStack(spacing: 14) {
                            hilightedText(str: jumDang, searched: "점 당 ")
                            hilightedText(str: ppuck, searched: "뻑 ")
                            VStack(alignment: .leading) {
                                hilightedText(str: tatak, searched: "따닥 ")
                                Text("뻑과는 달리 연속으로 따딱을 했다고 돈을 추가로 받지는 않는다.")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            hilightedText(str: sell, searched: "광팔기 ")
                        }
                        .frame(height: 420)
                        .padding([.leading, .trailing])
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
                .frame(width: 350, height: 540)
                    
            }
        }
    }
    func hilightedText(str: String, searched: String) -> Text {
        guard !str.isEmpty && !searched.isEmpty else { return Text(str) }

        var result: Text!
        let parts = str.components(separatedBy: searched)
//        print(parts)
        for i in parts.indices {
            result = (result == nil ? Text(parts[i]) : result + Text(parts[i]))

            if i != parts.count - 1 {
                result = result + Text(searched).bold()
            }
        }
        return result ?? Text(str).font(.system(size: 14))
    }
}

struct HelpPopUpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpPopUpView(show: .constant(true))
    }
}
