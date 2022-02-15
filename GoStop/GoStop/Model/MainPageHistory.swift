//
//  MainPageHistory.swift
//  GoStop
//
//  Created by 이태현 on 2022/02/15.
//

import Foundation

struct MainPageHistory: Codable {
    let date: String //생성일자
    var historyName: String //모임이름
    var player: [String] //플레이어
    var totalEarn: [Int] //총 수익현황
    var rule: CostRule //금액설정
    var ingameHistory: [IngameHistory] // Ingame내에서의 라운드
}
