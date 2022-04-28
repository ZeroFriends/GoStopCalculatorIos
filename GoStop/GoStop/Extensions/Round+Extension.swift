//
//  Round+Extension.swift
//  GoStop
//
//  Created by 이태현 on 2022/04/24.
//

import Foundation

extension Round {
    public var ingamePlayerList: [IngamePlayer] {
        let set = ingamePlayer as? Set<IngamePlayer> ?? []
        
        return Array(set.sorted {
            $0.name! < $1.name!
        })
    }
}
