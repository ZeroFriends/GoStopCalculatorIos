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
}
