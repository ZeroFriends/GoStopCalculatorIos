//
//  EndGameViewModel.swift
//  GoStop
//
//  Created by 이태현 on 2022/07/10.
//

import Foundation

class EndGameViewModel: ObservableObject {
    
    @Published var ingamePlayers: [String] = []
    @Published var checkBoxOn = Array(repeating: false, count: 10)
    //시작부분
    
    @Published var seller = Array(repeating: false, count: 4)
    @Published var sellerInput = ["","","",""]
    @Published var sellerIndex = -1
    //광팔기용
    
    @Published var selectOption: [Int] = [-1,-1,-1,-1]
    @Published var firstTatac = Array(repeating: false, count: 4)
    
    @Published var loserOption = Array(repeating: Array(repeating: false, count: 4), count: 4)
    
    @Published var winner = Array(repeating: false, count: 4)
    @Published var winnerInput = ["","","",""]
    @Published var winnerIndex = -1
    //승자기록
    
    @Published var totalCost: [Int32] = [0,0,0,0]
    @Published var eachCostList: [[Int32]] = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
    
    
    //totalCost 계산은 어떻게?
    func calculate(mainPageHistory: MainPageHistory) {

            for playerIndex in 0 ..< ingamePlayers.count {
                
                for enemyIndex in 0 ..< ingamePlayers.count {
                    if playerIndex == sellerIndex {
                        eachCostList[playerIndex][enemyIndex] += mainPageHistory.rule!.sell*Int32(sellerInput[sellerIndex])!
                        eachCostList[enemyIndex][playerIndex] -= mainPageHistory.rule!.sell*Int32(sellerInput[sellerIndex])!
                    }//광팔기
                    if selectOption[playerIndex] != -1 {//첫 뻑, 연 뻑, 삼연 뻑 중 하나 택한 상황
                        if enemyIndex != sellerIndex {
                            if selectOption[playerIndex] == 0 {//첫 뻑
                                eachCostList[playerIndex][enemyIndex] += mainPageHistory.rule!.ppuck
                                eachCostList[enemyIndex][playerIndex] -= mainPageHistory.rule!.ppuck
                            } else if selectOption[playerIndex] == 1 {//연 뻑
                                eachCostList[playerIndex][enemyIndex] += mainPageHistory.rule!.ppuck*2
                                eachCostList[enemyIndex][playerIndex] -= mainPageHistory.rule!.ppuck*2
                            } else {//삼연 뻑
                                eachCostList[playerIndex][enemyIndex] += mainPageHistory.rule!.ppuck*4
                                eachCostList[enemyIndex][playerIndex] -= mainPageHistory.rule!.ppuck*4
                            }
                        }
                    }
                    if firstTatac[playerIndex] == true {//첫 따닥 인 경우
                        if enemyIndex != sellerIndex {
                            eachCostList[playerIndex][enemyIndex] += mainPageHistory.rule!.firstTadack*3
                            eachCostList[enemyIndex][playerIndex] -= mainPageHistory.rule!.firstTadack*3
                        }//3점에 해당하는 금액을 즉시 획득한다는 뜻이 rule에서 첫따닥 점당 점수 *3 이라는 말이겠지?
                    }
                    
                    if playerIndex == winnerIndex {//승자 점수기록
                        
                        if enemyIndex != sellerIndex {
                            
                            eachCostList[playerIndex][enemyIndex] += mainPageHistory.rule!.jumDang*Int32(winnerInput[winnerIndex])!
                            eachCostList[enemyIndex][playerIndex] -= mainPageHistory.rule!.jumDang*Int32(winnerInput[winnerIndex])!
                            
                        }
                        
                    }
                    
                    if playerIndex != winnerIndex || playerIndex != sellerIndex {//패자 점수기록
                        if loserOption[playerIndex].contains(true) && enemyIndex == winnerIndex {
                            var cost = mainPageHistory.rule!.jumDang*Int32(winnerInput[winnerIndex])!
                            
                            eachCostList[playerIndex][enemyIndex] += cost
                            eachCostList[enemyIndex][playerIndex] -= cost
//                            var check = 0
                            for i in 0 ..< 4 {
                                
                                if loserOption[playerIndex][i] == true {
//                                    check += 1
                                    cost *= 2
                                }
                            }
//                            if check != 0 {
//                                cost = cost*(Int32(check)*2)
//                            }
                            eachCostList[playerIndex][enemyIndex] -= cost
                            eachCostList[enemyIndex][playerIndex] += cost
                        }
                    }
                    
                    
                    
                }
                

                
            }
            
        for i in 0 ..< ingamePlayers.count {
            for j in 0 ..< 4 {
                totalCost[i] += eachCostList[i][j]
            }
            
        }
        
        for i in 0 ..< ingamePlayers.count {
            if loserOption[i][3] == true {//고박 수정완료
                var cost = totalCost[i]//고박의 총 내야할 금액
                //광팔기가 있을때와 없을때를 나눠줘야함
                if sellerIndex != -1 {
                    cost -= eachCostList[i][sellerIndex]
                }
                totalCost[i] = 0//0으로 초기화
                for j in 0 ..< ingamePlayers.count {
                    
                    if j != sellerIndex && j != i && j != winnerIndex {
                        // 승자가 금액이 음수가 될 수 있나?
                        if sellerIndex != -1 {
                            cost = (totalCost[j]-eachCostList[i][sellerIndex])*2 + cost
                        } else {
                            cost = totalCost[j]*2 + cost
                        }
                        totalCost[j] = 0
                        for k in 0 ..< ingamePlayers.count {
                            if k != sellerIndex {
                                eachCostList[j][k] = 0
                                eachCostList[k][j] = 0
                                eachCostList[winnerIndex][k] = 0
                            }
                        }
                        if sellerIndex != -1 {
                            totalCost[j] = eachCostList[j][sellerIndex]
                        }
                    }
                    
                    
                }
                if sellerIndex == -1 {
                    totalCost[i] = cost
                } else {
                    totalCost[i] = cost + eachCostList[i][sellerIndex]
                }
                
                eachCostList[i][winnerIndex] = cost
                eachCostList[winnerIndex][i] = abs(cost)
                
                
                if sellerIndex == -1 {
                    totalCost[winnerIndex] = abs(cost)
                } else {
                    totalCost[winnerIndex] = abs(cost)+eachCostList[winnerIndex][sellerIndex]
                }
            }//고박이 존재한다면
        }
    }
}
