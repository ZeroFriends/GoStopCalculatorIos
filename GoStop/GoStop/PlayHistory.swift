//
//  PlayHistory.swift
//  GoStop
//
//  Created by 이태현 on 2022/02/06.
//

import Foundation

struct PlayHistory: Codable, Identifiable {
    
    struct Players: Codable {
        let sequence: Int
        let name: String
    }//진행 내역 안에 PlayerModel도 존재해야 함
    
    var id = UUID()
    let date: Date// 생성일자
    let gameName: String// 모임이름
    
}
