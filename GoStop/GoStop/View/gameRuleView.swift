//
//  gameRuleVIew.swift
//  GoStop
//
//  Created by 이태현 on 2022/04/11.
//

import SwiftUI

struct gameRuleView: View {
    @Environment(\.presentationMode) var presentationMode
    var mainPageHistory: MainPageHistory
    
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
                Text(mainPageHistory.historyName!)
                    .font(.system(size: 14))
                    .bold()
                Spacer()
                Image(systemName: "arrow.left")
                    .opacity(0)
            }
            .frame(height: 35)
            .padding(.horizontal)
            divideRectangle()
            VStack {
                HStack {
                    Text("게임규칙")
                        .font(.system(size: 24, weight: .bold))
                    Spacer()
                }
                .padding(.top, 30)
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .foregroundColor(.white)
                        .frame(height: 148)
                        .shadow(color: Color(hex: 0xbdbdbd), radius: 3, x: 0, y: 3)
                    VStack {
                        HStack(spacing: 40) {
                            HStack {
                                Text("1   ")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.red)
                                Text("점 당")
                                    .font(.system(size: 16, weight: .medium))
                                Spacer()
                                Text("\(mainPageHistory.rule!.jumDang)원")
                                    .font(.system(size: 12, weight: .medium))
                            }
                            HStack {
                                Text("2   ")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.red)
                                Text("뻑")
                                    .font(.system(size: 16, weight: .medium))
                                Spacer()
                                Text("\(mainPageHistory.rule!.ppuck)원")
                                    .font(.system(size: 12, weight: .medium))
                            }
                        }
                        .padding()
                        HStack(spacing: 40) {
                            HStack {
                                Text("3   ")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.red)
                                Text("첫 따닥")
                                    .font(.system(size: 16, weight: .medium))
                                Spacer()
                                Text("\(mainPageHistory.rule!.firstTadack)원")
                                    .font(.system(size: 12, weight: .medium))
                            }
                            HStack {
                                Text("4   ")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.red)
                                Text("광팔기")
                                    .font(.system(size: 16, weight: .medium))
                                Spacer()
                                Text("\(mainPageHistory.rule!.sell)원")
                                    .font(.system(size: 12, weight: .medium))
                            }
                        }
                        .padding()
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
    }
}

struct gameRuleView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager().persistentContainer.viewContext
        let testHistory = MainPageHistory(context: context)
        
        testHistory.historyName = "2021.09.21"
        
        testHistory.rule = Rule(context: context)
        testHistory.rule?.jumDang = 100
        testHistory.rule?.ppuck = 100
        testHistory.rule?.firstTadack = 100
        testHistory.rule?.sell = 100
        
        
        return gameRuleView(mainPageHistory: testHistory).environment(\.managedObjectContext, context)
    }
}
