//
//  IngamePlayer+Extension.swift
//  GoStop
//
//  Created by 이태현 on 2022/04/24.
//

import Foundation

extension IngamePlayer {
    
    public var innerArray: [IngamePlayerPlayList] {
        let set = playList as? Set<IngamePlayerPlayList> ?? []
        
        return Array(set.sorted {
            $0.sequence < $1.sequence
        })
    }
    
}
