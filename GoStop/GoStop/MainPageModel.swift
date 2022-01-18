//
//  MainPageModel.swift
//  GoStop
//
//  Created by 이태현 on 2022/01/19.
//

import Foundation

struct MainPageModel {
    private(set) var isNavigationViewReady: Bool
    
    init() {
        isNavigationViewReady = false
    }
    
    mutating func navigationViewChoosen() {
        isNavigationViewReady.toggle()
    }
}
