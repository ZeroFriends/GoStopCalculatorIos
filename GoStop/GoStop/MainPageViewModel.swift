//
//  MainPageViewModel.swift
//  GoStop
//
//  Created by 이태현 on 2022/01/19.
//

import Foundation

class MainPageViewModel: ObservableObject {
    @Published var model = MainPageModel()
    
    var NavigationGo: Bool {
        model.isNavigationViewReady
    }
    
    var startViewGo: Bool {
        model.readyForStart
    }
    
    func chooseNavigationButton() {
        model.navigationViewChoosen()
    }
    
    func chooseStartbtn() {
        model.choosestartBtn()
    }
}
