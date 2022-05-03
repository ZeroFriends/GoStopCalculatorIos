//
//  EndGameView.swift
//  GoStop
//
//  Created by 이태현 on 2022/05/03.
//

import SwiftUI

struct EndGameView: View {
    let coreDM: CoreDataManager
    var mainPageHistory: MainPageHistory
    
//    var mainPlayer = mainPageHistory.playerlist
    @State var ingamePlayer: [String] = []
    @Environment(\.presentationMode) var presentationMode
    
    var subTitle = ["시작하기", "광팔기", "옵션점수 기록", "승자점수 기록", "패자 점수기록"]
    var subExplain = ["2인 이상 4인까지 게임을 플레이 할 수 있으며,4인 플레이를 할 경우 1명은 반드시 광을 팔아야 합니다.",
                      "4인 플레이의 경우 한명이 필수로 광을 팔아야 플레이가 가능합니다. 광을 판 플레이어를 선택해주세요.",
                      "운이 좋네요!해당하는 곳에 체크를 해주세요",
                      "이긴 플레이어를 선택하고, 몇점을 내었는지 계산 후 점수를 적어주세요.",
                      "게임에서 패배한 플레이어들의 박 여부를 체크해주세요."]
    
    @State var index = 0
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                }
                Spacer()
                Text(mainPageHistory.historyName ?? "mainPage 이름 설정 안함")
                    .font(.system(size: 14))
                    .bold()
                Spacer()
                Button {
                    // X 의 기능
                } label: {
                    Image(systemName: "multiply")
                        .foregroundColor(.black)
                        .opacity(ingamePlayer.isEmpty ? 0 : 1 )
                }
            }
            divideRectangle()
                .padding(.horizontal, -20)
            VStack(alignment: .center,spacing: 10) {
                HStack {
                    Text(subTitle[index])
                        .font(.system(size: 20, weight: .bold))
                }
                HStack() {
                    Spacer()
                    Text(subExplain[index])
                        .font(.system(size: 14, weight: .medium))
                    Spacer()
                }
            }//VStack
            .padding(.vertical)
            .background (
                RoundedRectangle(cornerRadius: 18)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 5, x: 0, y: 3)
            )
            
            HStack {
                Text("플레이어 리스트")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .padding(.vertical, 10)
            
            
            
        }//VStack
        .padding()
        .navigationBarHidden(true)
    }
}

struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager().persistentContainer.viewContext
        let testHistory = MainPageHistory(context: context)
        testHistory.historyName = "2021.09.01"
        return EndGameView(coreDM: CoreDataManager(), mainPageHistory: testHistory).environment(\.managedObjectContext, context)
    }
}
