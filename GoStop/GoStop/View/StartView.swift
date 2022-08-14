//
//  StartView.swift
//  GoStop
//
//  Created by 이태현 on 2022/01/24.
//

import SwiftUI

struct StartView: View {
    @Binding var isPresent: Bool
    @State var HistoryNametextField = ""//모임이름
    @State var players: [String] = []//플레이어 목록
    @State var playersNumberExcess = false
    @State var playerNumber = 0
    @State var showingPopUp = false
    @State var showingHelpPopUp = false
    @State var terminateStartView = false
    @State var complete = false
    
    @State var titleLimitTrigger = false
    @State var titleLimit = false
    
    @State var headLine: [String] = ["플레이어 설정 👥","게임규칙 💡"]
    @State var guideLine: [String] = ["최소 플레이어는 2인입니다.\n5인 이상 추가하실 경우 4인 이하만 플레이 할 수 있습니다.","게임 플레이 시 적용될 금액입니다.\n과도한 금액이 나오지 않게 주의해 주세요 :)"]
    
    @State var lineIndex = 0
    @State var originIndex = 0
    
    @State var jumDang = ""
    @State var ppuck = ""
    @State var firstTadack = ""
    @State var sell = ""//rule
    
    @State var disableState = false
    
    let coreDM: CoreDataManager
    
    var dateformat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"
        return formatter
    }
    
    var body: some View {
        if complete {
            IngameView(coreDM: coreDM, mainPageHistory: coreDM.mainPageHistoryList.last!)
        } else {
            ZStack {
                GeometryReader { geometry in
                    ZStack {
                        Color.red
                            .ignoresSafeArea()
                        
                        Image("group183")
                            .position(x: geometry.size.width * 0.85)
                            .offset(y: 120)
                        
                        VStack {
                            HStack {
                                Button {
                                    if lineIndex == 0 {
                                        terminateStartView = true
                                    } else {
                                        lineIndex = 0
                                        disableState = true
                                    }
                                } label: {
                                    Image(systemName: "arrow.left")
                                }
                                
                                Spacer()
                                Text("게임설정 (\(lineIndex+1)/2)")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                Spacer()
                                Button {
                                    terminateStartView = true
                                } label: {
                                    if lineIndex == 0 {
                                        Image(systemName: "multiply")
                                            .opacity(0)
                                    } else {
                                        Image(systemName: "multiply")
                                    }
                                }
                                .alert(isPresented: $terminateStartView) {
                                    Alert(title: Text("게임설정을 종료하시겠습니까?"), message: nil, primaryButton: .destructive(Text("네"), action: {
                                        withAnimation {
                                            isPresent = false
                                        }
                                    }), secondaryButton: .cancel(Text("아니요")))
                                }
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            VStack {
                                HStack {
                                    Text(headLine[lineIndex])
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                        .padding(.bottom)
                                    Spacer()
                                }
                                HStack {
                                    Text(guideLine[lineIndex])
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
                                    if lineIndex < 1 {
                                        HStack {
                                            Text("모임이름")
                                                .fontWeight(.bold)
                                                .font(.system(size: 16))
                                            Spacer()
                                        }
                                        TextField("\(Date(), formatter: dateformat)", text: $HistoryNametextField)
                                            .limitInputLength(value: $HistoryNametextField, length: 16)
                                            .keyboardType(.default)
                                            .textFieldStyle(OvalTextFieldStyle())
                                        //텍스트필드 테두리 수정하기 + 여기서 입력받은 값 어떻게 처리할것인지
                                            .alert(isPresented: $titleLimit) {
                                                Alert(title: Text("모임이름은 최대 16자 입니다."), message: nil, dismissButton: .destructive(Text("확인")))
                                            }
                                        Text("플레이어")
                                            .fontWeight(.bold)
                                            .font(.system(size: 16))
                                            .padding(.vertical)

                                        if players.isEmpty {
                                            VStack {
                                                HStack {
                                                    Spacer()
                                                    Text("플레이어 추가 버튼으로 플레이어를 등록해주세요")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.gray)
                                                    Spacer()
                                                }
                                                HStack {
                                                    Button {
                                                        //플레이어추가 버튼 기능 구현하기
                                                        playerNumber += 1
                                                        players.append("플레이어 \(playerNumber)")//임시 값
                                                    } label: {
                                                        ZStack {
                                                            RoundedRectangle(cornerRadius: 18).fill().foregroundColor(.white)
                                                             RoundedRectangle(cornerRadius: 18).stroke(lineWidth: 2).foregroundColor(.black)
                                                            Text("+ 플레이어 추가")
                                                                .foregroundColor(.black)
                                                                .fontWeight(.bold)
                                                        }
                                                    }
                                                    .frame(height: 36)
                                                    .padding()
                                                }
                                            }
                                            .padding(.vertical)
                                        } else {
                                            ScrollView {
                                                VStack {
                                                    ForEach(players, id: \.self) { player in
                                                        HStack {
                                                            let number = players.firstIndex(of: player)!
                                                            Text("\(number+1)")
                                                                .foregroundColor(.red)
                                                                .font(.system(size: 16))
                                                                .fontWeight(.bold)
                                                            Text(player)
                                                                .font(.system(size: 16))
                                                                .fontWeight(.bold)
                                                            Button {
                                                                //modify
                                                                originIndex = number
                                                                showingPopUp.toggle()
                                                            } label: {
                                                                Image("modeEditBlack24Dp")
                                                                    .padding(.horizontal)
                                                            }
                                                            Spacer()
                                                            Button {
                                                                players.remove(at: number)
                                                            } label: {
                                                                Image("deleteBlack24Dp")
                                                            }
                                                        }
                                                        .frame(height: 44)
                                                        .padding(.horizontal)
                                                    }
                                                }
                                                .frame(maxWidth: .infinity)
                                                HStack {
                                                    Button {
                                                        //플레이어추가 버튼 기능 구현하기
                                                        if players.count < 10 {
                                                        playerNumber += 1
                                                        players.append("플레이어 \(playerNumber)")
                                                        } else {
                                                            playersNumberExcess = true
                                                        }
                                                        
                                                    } label: {
                                                        ZStack {
                                                            RoundedRectangle(cornerRadius: 18).fill().foregroundColor(.white)
                                                             RoundedRectangle(cornerRadius: 18).stroke(lineWidth: 2).foregroundColor(.black)
                                                            Text("+ 플레이어 추가")
                                                                .foregroundColor(.black)
                                                                .fontWeight(.bold)
                                                        }
                                                    }
                                                    .frame(height: 36)
                                                    .padding()
                                                }
                                            }
                                            .alert(isPresented: $playersNumberExcess) {
                                                Alert(title: Text("플레이어 수는 최대 10명입니다."), message: nil, dismissButton: .cancel(Text("확인")))
                                            }
                                        }
                                    } else {
                                        VStack {
                                            HStack {
                                                Text("금액설정")
                                                    .fontWeight(.bold)
                                                    .font(.system(size: 16))
                                                Spacer()
                                                Button {
                                                    // 도움말
                                                    showingHelpPopUp.toggle()
                                                } label: {
                                                    ZStack {
                                                        RoundedRectangle(cornerRadius: 12.5).fill().foregroundColor(.white)
                                                        RoundedRectangle(cornerRadius: 12.5).stroke(lineWidth: 2).foregroundColor(.red)
                                                        Text("도움말")
                                                            .foregroundColor(.red)
                                                            .fontWeight(.bold)
                                                    }
                                                    .frame(width: 69, height: 25)
                                                }
                                            }
                                            .padding(.top, 30.0)
                                            
                                            VStack(spacing: 0) {
                                                HStack {
                                                    Text("1 ")
                                                        .foregroundColor(.red)
                                                        .font(.system(size: 16))
                                                        .fontWeight(.bold)
                                                    Text("점 당 ")
                                                        .fontWeight(.medium)
                                                    Image("starBlack24Dp")
                                                        .resizable()
                                                        .frame(width: 12, height: 12)
                                                    Spacer()
                                                    TextField("0", text: $jumDang)
                                                        .multilineTextAlignment(.trailing)
                                                        .keyboardType(.numberPad)
                                                        .frame(width: 110)
                                                    Text("원")
                                                }
                                                HStack {
                                                    Text("  ")
                                                    Text(" 필수항목입니다")
                                                        .font(.system(size: 10))
                                                        .foregroundColor(.gray)
                                                    Spacer()
                                                    Rectangle()
                                                        .frame(width: 135, height: 1)
                                                }
                                                .padding(.top, -5)
                                                .padding(.bottom, 20)
                                                HStack {
                                                    Text("2 ")
                                                        .foregroundColor(.red)
                                                        .font(.system(size: 16))
                                                        .fontWeight(.bold)
                                                    Text("뻑 ")
                                                        .fontWeight(.medium)
       
                                                    Spacer()
                                                    TextField("0", text: $ppuck)
                                                        .multilineTextAlignment(.trailing)
                                                        .keyboardType(.numberPad)
                                                        .frame(width: 110)
                                                    Text("원")
                                                }
                                                HStack {
                                                    Text("  ")
                                                    Spacer()
                                                    Rectangle()
                                                        .frame(width: 135, height: 1)
                                                }
                                                .padding(.top, -5)
                                                .padding(.bottom, 20)
                                                HStack {
                                                    Text("3 ")
                                                        .foregroundColor(.red)
                                                        .font(.system(size: 16))
                                                        .fontWeight(.bold)
                                                    Text("첫 따닥 ")
                                                        .fontWeight(.medium)
                                                    Spacer()
                                                    TextField("0", text: $firstTadack)
                                                        .multilineTextAlignment(.trailing)
                                                        .keyboardType(.numberPad)
                                                        .frame(width: 110)
                                                    Text("원")
                                                }
                                                HStack {
                                                    Text("  ")
                                                    Spacer()
                                                    Rectangle()
                                                        .frame(width: 135, height: 1)
                                                }
                                                .padding(.top, -5)
                                                .padding(.bottom, 20)
                                                HStack {
                                                    Text("4 ")
                                                        .foregroundColor(.red)
                                                        .font(.system(size: 16))
                                                        .fontWeight(.bold)
                                                    Text("광팔기 ")
                                                        .fontWeight(.medium)
                                                    Spacer()
                                                    TextField("0", text: $sell)
                                                        .multilineTextAlignment(.trailing)
                                                        .keyboardType(.numberPad)
                                                        .frame(width: 110)
                                                    Text("원")
                                                }
                                                HStack {
                                                    Text("  ")
                                                    Text("  4인 플레이 시에만 적용됩니다.")
                                                        .font(.system(size: 10))
                                                        .foregroundColor(.gray)
                                                    Spacer()
                                                    Rectangle()
                                                        .frame(width: 135, height: 1)
                                                }
                                                .padding(.top, -5)
                                            }
                                            .padding()
                                        }
                                    }
                                    Spacer()
                                    HStack {
                                        Button {
                                            disableState = false
                                            withAnimation {
                                                if lineIndex < 1 {
                                                    lineIndex += 1
                                                } else {
                                                    coreDM.saveMainPageHistory(players: players, historyName: HistoryNametextField, jumDang: jumDang, ppuck: ppuck, firstTadack: firstTadack, sell: sell)
                                                    complete.toggle()
                                                }
                                            }
                                        } label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 18).fill()
                                                    .foregroundColor(disableState ? .red : .gray)
                                                Text(lineIndex < 1 ? "다음" : "완료")
                                                    .foregroundColor(.white)
                                                    .fontWeight(.bold)
                                            }
                                        }
                                        .frame(height: 44)
                                        .disabled(!disableState)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                    .ignoresSafeArea(.keyboard)//모임이름 설정할때 keyboard로 인하여 view크기 재설정으로 인해 레이아웃 망가짐 방지
                }
                .navigationBarHidden(true)
                PlayerPopUpView(players: $players, originIndex: $originIndex,show: $showingPopUp)
                HelpPopUpView(show: $showingHelpPopUp)
            }
            .onChange(of: HistoryNametextField) { textField in
                if textField.count == 16 {
                    HistoryNametextField.removeLast()
                        titleLimit = true
                }
            }
            .onChange(of: players.count) { _ in
                if (players.count >= 2 && lineIndex == 0) {
                    disableState = true
                } else {
                    disableState = false
                }
            }
            .onChange(of: jumDang) { _ in
                if Int(jumDang) ?? 0 > 0 {
                    disableState = true
                } else {
                    disableState = false
                }
            }
            .onChange(of: lineIndex) { _ in
                if Int(jumDang) ?? 0 > 0 {
                    disableState = true
                }
            }
            .onTapGesture {
                self.hideKeyboard()
            }
        }
    }
}

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .foregroundColor(.gray)
            .background(Color.white)
            .cornerRadius(18)
            .overlay(RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.gray, lineWidth: 2)
            )
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(isPresent: .constant(true), coreDM: CoreDataManager())
    }
}
