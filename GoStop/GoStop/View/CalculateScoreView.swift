//
//  CalculateScoreView.swift
//  GoStop
//
//  Created by 이태현 on 2022/05/18.
//

import SwiftUI

struct CalculateScoreView: View {
    
    @Environment(\.presentationMode) var presentationmode
    
    @State var option = true
    @State var winner = false
    @State var loser = false
    @State var fightFlower = false
    @State var doubleScore = false
    @State var gameProgress = false
    
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
                            option = true
                            winner = false
                            loser = false
                            fightFlower = false
                            doubleScore = false
                            gameProgress = false
                        } label: {
                            Text("옵션 점수")
                                .foregroundColor(option ? .black : .gray)
                                .font(.system(size: 14, weight: .bold))
                        }
                        Button {
                            option = false
                            winner = true
                            loser = false
                            fightFlower = false
                            doubleScore = false
                            gameProgress = false
                        } label: {
                            Text("승자 점수")
                                .foregroundColor(winner ? .black : .gray)
                                .font(.system(size: 14, weight: .bold))
                        }
                        Button {
                            option = false
                            winner = false
                            loser = true
                            fightFlower = false
                            doubleScore = false
                            gameProgress = false
                        } label: {
                            Text("패자 점수")
                                .foregroundColor(loser ? .black : .gray)
                                .font(.system(size: 14, weight: .bold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    HStack(spacing: 40) {
                        Button {
                            option = false
                            winner = false
                            loser = false
                            fightFlower = true
                            doubleScore = false
                            gameProgress = false
                        } label: {
                            Text("화투점수 계산")
                                .foregroundColor(fightFlower ? .black : .gray)
                                .font(.system(size: 14, weight: .bold))
                        }
                        Button {
                            option = false
                            winner = false
                            loser = false
                            fightFlower = false
                            doubleScore = true
                            gameProgress = false
                        } label: {
                            Text("점수 2배 만들기")
                                .foregroundColor(doubleScore ? .black : .gray)
                                .font(.system(size: 14, weight: .bold))
                        }
                        Button {
                            option = false
                            winner = false
                            loser = false
                            fightFlower = false
                            doubleScore = false
                            gameProgress = true
                        } label: {
                            Text("게임진행 방법")
                                .foregroundColor(gameProgress ? .black : .gray)
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
                    if option == true {
                        OptionScore()
                            .padding(.horizontal)
                    } else if winner == true {
                        WinnerScore()
                            .padding(.horizontal)
                    } else if loser == true {
                        LoserScore()
                            .padding(.horizontal)
                    } else if fightFlower == true {
                        FightFlowerScore()
                            .padding(.horizontal)
                    } else if doubleScore == true {
                        DoubleScoreMake()
                            .padding(.horizontal)
                    } else if gameProgress == true {
                        GameProgressRule()
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.top, -8)
        }//VStack
        .navigationBarHidden(true)
    }
    
    struct InnerShape: View {
        var boldTitle: [String] = []
        var explains: [String] = []
        
        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                ForEach(boldTitle, id: \.self) { title in
                    let index = boldTitle.firstIndex(of: title)
                    HStack {
                        Text(title)
                            .font(.system(size: 16, weight: .bold))
                        Spacer()
                    }
                    Text(explains[index!])
                    if index! < boldTitle.count - 1 {
                    Divider()
                    }
                }
            }
            .font(.system(size: 14, weight: .medium))
            .padding(.top, 15)
        }
    }
    struct OptionScore: View {
        var boldTitle = ["뻑", "첫 따닥"]
        var explains = ["""
                        첫 뻑 : 첫 턴에 뻑을 저지른 경우 설정 금액 즉시 획득.
                        
                        연 뻑 : 첫 뻑을 저지른 다음 턴에 다시 뻑을 저지른 경우 설정 금액의 2배 즉시 획득.
                        
                        삼연뻑 : 연뻑을 저지른 다음 턴에 다시 뻑을 저지른 경우. 12점의 점수로 게임 종료. 설정금액의 4배 즉시 획득.
                        """,
                        "첫 턴에 따닥을 성공시킨 경우. 점수에는 계산되지 않으나 3점에 해당하는 금액을 게임 도중에 즉시 획득."]
        var body: some View {
            InnerShape(boldTitle: boldTitle, explains: explains)
        }
    }
    
    struct WinnerScore: View {
        var boldTitle = ["고", "흔들기 & 폭탄", "역고", "나가리"]
        var explains = ["1고를 하면 +1점, 2고를 하면 +2점, 3고를 하면 점수의 x2점, 4고를 하면 점수의 x4점이 됩니다.",
                        "같은 월의 패를 3장 손에 들고 있는 경우, 이를 다른 사람들에게 보여줄 수 있으며 이를 흔들기라 한다. 흔들기를 하거나 폭탄을 던진 사람이 승리할 경우 그의 점수가 2배가 된다.",
                        "고를 부른 상대방보다 먼저 점수를 낸 다음 역으로 고를 부를경우 이를 역고라 한다. 역고를 한 이후 스톱하게 되면 점수가 두배로 계산되고 독박까지 쓰게 할수 있다.",
                        "마지막 패까지 돌았을 때, 아무도 3점(맞고 7점)을 내지 못하거나, 먼저 고를 선언한 참여자가 추가 점수를 내지 못해서 스톱을 선언하지 못한 경우 나가리가 성립된다.나가리가 날 경우, 선이 유지되고 게임을 처음부터 다시 시작한다.단 다음 게임의 점수는 2배로 계산한다."]
        
        var body: some View {
            InnerShape(boldTitle: boldTitle, explains: explains)
        }
    }
    
    struct LoserScore: View {
        var boldTitle = ["피박", "광박", "멍박", "고박"]
        var explains = ["승자가 피 10장 이상을 모아 점수를 얻었는데 피가 5장 이하인 경우. 승자에게 2배의 돈을 지불한다.",
                        "승자가 광 3장 이상을 모아 점수를 얻었는데 광이 1장도 없는 경우. 승자에게 2배의 돈을 지불한다.",
                        "승자가 열끗 5장 이상을 모아 점수를 얻었는데 열끗이 1장도 없는 경우. 승자에게 2배의 돈을 지불한다.",
                        "고를 했는데 다른 플레이어가 점수를 모아서 스톱을 선언한 경우. 고박 플레이어는 2배의 비용과 다른 플레이어 비용까지 지불한다. 광팔이 제외."]
        var body: some View {
            InnerShape(boldTitle: boldTitle, explains: explains)
        }
    }
    
    struct FightFlowerScore: View {
        var body: some View {
            VStack(spacing: 15) {
                HStack(spacing: 25) {
                    ZStack {
                        Rectangle()
                            .frame(width: 156, height: 156)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 1, x: 0, y: 0)
                        VStack(spacing: 25) {
                            Image("group")
                            Text("5광 • 15점")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .padding()
                    }
                    ZStack {
                        Rectangle()
                            .frame(width: 156, height: 156)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 1, x: 0, y: 0)
                        VStack(spacing: 25) {
                            Image("group16")
                            Text("4광 • 4점")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .padding()
                    }
                }
                HStack(spacing: 25) {
                    ZStack {
                        Rectangle()
                            .frame(width: 156, height: 156)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 1, x: 0, y: 0)
                        VStack(spacing: 25) {
                            Image("groupCopy2")
                            Text("3광 • 3점")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .padding()
                    }
                    ZStack {
                        Rectangle()
                            .frame(width: 156, height: 156)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 1, x: 0, y: 0)
                        VStack(spacing: 25) {
                            Image("group17")
                            VStack {
                                Text("비광 • 2점")
                                    .font(.system(size: 14, weight: .bold))
                                Text("광 2개+비광")
                                    .font(.system(size: 8, weight: .medium))
                            }
                        }
                        .padding()
                        .padding(.bottom, -8)
                    }
                }
                HStack(spacing: 25) {
                    ZStack {
                        Rectangle()
                            .frame(width: 156, height: 156)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 1, x: 0, y: 0)
                        VStack(spacing: 25) {
                            Image("group5")
                            VStack {
                                Text("5광 • 1점")
                                    .font(.system(size: 14, weight: .bold))
                                Text("1장 추가 시 1점씩 추가\n/고도리 중복계산 가능")
                                    .font(.system(size: 8, weight: .medium))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding()
                    }
                    ZStack {
                        Rectangle()
                            .frame(width: 156, height: 156)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 1, x: 0, y: 0)
                        VStack(spacing: 25) {
                            Image("group6")
                            VStack {
                                Text("5장 • 1점")
                                    .font(.system(size: 14, weight: .bold))
                                Text("1장 추가 시 1점씩 추가\n/홍단,청단,초단 중복계산 가능")
                                    .font(.system(size: 8, weight: .medium))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding()
                        .padding(.bottom, -8)
                    }
                }
                HStack(spacing: 25) {
                    ZStack {
                        Rectangle()
                            .frame(width: 156, height: 156)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 1, x: 0, y: 0)
                        VStack(spacing: 25) {
                            Image("group3")
                            Text("홍단 • 3점")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .padding()
                    }
                    ZStack {
                        Rectangle()
                            .frame(width: 156, height: 156)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 1, x: 0, y: 0)
                        VStack(spacing: 25) {
                            Image("group2")
                            Text("청단 • 3점")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .padding()
                    }
                }
                HStack(spacing: 25) {
                    ZStack {
                        Rectangle()
                            .frame(width: 156, height: 156)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 1, x: 0, y: 0)
                        VStack(spacing: 25) {
                            Image("group20")
                            Text("초단 • 3점")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .padding()
                    }
                    ZStack {
                        Rectangle()
                            .frame(width: 156, height: 156)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 1, x: 0, y: 0)
                        VStack(spacing: 25) {
                            Image("group21")
                            Text("고도리 • 5점")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .padding()
                    }
                }
                HStack(spacing: 25) {
                    ZStack {
                        Rectangle()
                            .frame(width: 156, height: 156)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 1, x: 0, y: 0)
                        VStack {
                            Image("group22")
                            Text("10장 • 1점")
                                .font(.system(size: 14, weight: .bold))
                            Text("1장 추가 시 1점씩 추가\n/쌍피 2점, 쓰리피 3점추가")
                                .font(.system(size: 8, weight: .medium))
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    }
                    ZStack {
                        Rectangle()
                            .frame(width: 156, height: 156)
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 1, x: 0, y: 0)
                        VStack(spacing: 25) {
                            Image("group21")
                            Text("고도리 • 5점")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .padding()
                    }
                    .opacity(0)//균형맞추기위해 만들었기때문에 투명도 설정으로 안보이게 함
                }
            }
            .padding(.top, 15)
        }
    }//화투점수 계산
    
    struct DoubleScoreMake: View {
        var boldTitle = ["피박", "광박", "고박", "흔들기", "폭탄"]
        var explains = ["피로 1점 이상 점수가 났을 때 상대방의 피가 5장 이하인 경우",
                        "광으로 점수가 났을 때 상대방이 광이 한 장도 없는 경우",
                        "고를 했는데 다른 플레이어가 점수를 모아서 스톱을 선언한 경우. 고박 플레이어는 2배의 비용과 다른 플레이어 비용까지 지불한다. 광팔이 제외",
                        "같은 월의 패를 3장 손에 들고 있는 경우",
                        "흔들 수 있는 상황인데 바닥에 같은 월의 나머지 한 장이 깔려 있는 경우, 3장을 한꺼번에 내려놓았을 경우"]
        
        var body: some View {
            InnerShape(boldTitle: boldTitle, explains: explains)
        }
    }
    
    struct GameProgressRule: View {
        var boldTitle = ["2명 게임을 플레이 할 경우", "3명 게임을 플레이 할 경우", "4명 게임을 플레이 할 경우", "게임 진행 방법"]
        var explains = ["2인은 목표 점수가 7점이며, 8장을 판에 깔고 10장씩 가져갑니다.",
                        "3인은 목표 점수가 3점이며 6장을 깔고 7장씩 가져갑니다.",
                        "4인은 목표 점수가 3점이며 6장을 깔고 7장씩 가져갑니다.1명은 반드시 광을 팔고 게임에서 제외됩니다.",
                        """
                        게임을 주도하는 선이 존재하며, 게임은 항상 선부터 시작하게 된다.
                        
                        1. 첫 게임에서는 먼저 선을 정한다. 화투장을 뒷면이 보이게 펼쳐놓아 한장씩 뽑거나, 기리를 떼는 방식으로 그 화투장의 월 수로 선을 정한다.
                        
                        2. 선은 패를 정리하고 잘 섞은 후, 자신의 좌측에 앉은 사람에게 적당한 양의 패를 떼어 더미를 쌓도록 한다. 이 때 한 장도 떼지 않는 경우에는 패를 손가락으로 톡 치면서 \"통\"이라고 말한다.
                        
                        3. 정상적으로 패를 돌렸으면 각 사람은 손에 패를 들고 있으며, 바닥에는 화투가 깔려 있다. 어떤 방법으로 돌려도 큰 상관이 없으나, 가장 일반적인 방법으로는 반시계방향으로 4장씩 돌린 후, 바닥에 3장을 패가 보이도록 내려놓는다. 이후 반시계방향으로 3장씩 돌리고, 다시 3장을 깐다. 퉁인 경우, 한꺼번에 깐다. 퉁이 아닌 경우 돌리다가 패가 모자라면 더미위에서 가져오고, 패가 남으면 더미 위에 올린다.
                        맞고: 4장씩 2번을 돌리고 5장씩 두번을 깐다.
                        
                        
                        4. 선부터 반시계방향으로 돌면서, 손에 들고 있는 패를 바닥에 내려놓고, 쌓여 있는 더미의 맨 위에서 한장을 뒤집어 바닥에 내려놓는다. 내려놓는 패와 같은 월의 패가 바닥에 깔려있다면 그 패를 먹을 수 있으며, 먹은 패는 점수 룰에 따라 점수를 계산한다.
                        
                        5. 어느 한 사람이 3점 이상(맞고: 7점)이 되면 "났다"고 하며, 그 사람은 게임을 계속할지, 아니면 중단할지를 결정할 수 있다. 게임을 계속하려면 "고"를, 중단하려면 "스톱"을 부르면 된다. 스톱하면 그 시점에서 게임을 승리하며, 패자는 최종점수에 해당하는 돈을 승자에게 지불하고, 승자는 다음 게임의 선이 된다.
                        
                        6. 고를 하면 게임은 계속된다. 고를 부른 사람이 다시 한번 추가점수 획득에 성공할 경우 보너스를 획득하며(추가 점수, 또는 점수 두 배 등)다시 한번 고/스톱을 결정할 수 있는 권리를 얻는다. 뻑이나 따닥, 쓸, 쪽 등으로 피를 뺏겨서 점수가 깎인 경우, 예전 점수를 회복한 후 추가점수를 내야한다. 고를 부르지 못한 사람이 먼저 3점을 만들어서 나게 되면 그 사람이 고/스톱을 결정할 권리를 얻는다. 스톱을 할 경우 맨 처음 고를 부른 사람은 '독박' 또는 '고박'이라고 하여 나머지 패자가 낼 금액까지 새로운 승자에게 모두 물어주어야 하는 페널티를 받는다. 쉽게 말해 역전패.
                        
                        점수 계산. 게임이 끝나면 더하는 점수를 먼저 더하고, 곱하는 배율을 나중에 곱하여 그에 해당하는 금액을 승자에게 지불한다.
                        """]
        
        var body: some View {
            InnerShape(boldTitle: boldTitle, explains: explains)
        }
    }
}

struct CalculateScoreView_Previews: PreviewProvider {
    static var previews: some View {
        CalculateScoreView()
    }
}

