//
//  CostRule.swift
//  GoStop
//
//  Created by 이태현 on 2022/02/15.
//

import Foundation

struct CostRule: Codable {
    var jumDant: Int
    var ppuck: Int
    var tatack: Int
    var sell: Int
    
    init() {
        self.jumDant = 0
        self.ppuck = 0
        self.tatack = 0
        self.sell = 0
    }
}//금액 설정 구조체
