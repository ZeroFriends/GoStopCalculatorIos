//
//  IngameHistory.swift
//  GoStop
//
//  Created by 이태현 on 2022/02/15.
//

import Foundation

struct IngameHistory: Codable {
    var round: Int //라운드 수
    let earn: [Int] //수익현황
    // player는 mainPageHistory에 존재하는 플레이어 사용
    // costRule도 마찬가지
}
