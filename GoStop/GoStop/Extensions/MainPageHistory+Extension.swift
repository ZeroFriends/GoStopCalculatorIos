//
//  MainPageHistory+Extension.swift
//  GoStop
//
//  Created by 이태현 on 2022/04/10.
//

import Foundation

extension MainPageHistory {
    public var playerlist: [Player] {
        let set = player as? Set<Player> ?? []
        
        return Array(set)
    }
}
