//
//  GoStopViewModel.swift
//  GoStop
//
//  Created by 이태현 on 2022/02/16.
//

import Foundation

class GoStopViewModel: ObservableObject {
    @Published var mainPageHistory: [MainPageHistory] = [] {
        didSet {
            
        }
    }
    
    init() {
        
    }
}
