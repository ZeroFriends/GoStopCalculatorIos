//
//  Game.swift
//  GoStop
//
//  Created by 이태현 on 2022/02/15.
//

import Foundation

struct Game: Codable, Identifiable{
    var id = UUID()
    var mainPageHistory: [MainPageHistory] //진행내역
}
