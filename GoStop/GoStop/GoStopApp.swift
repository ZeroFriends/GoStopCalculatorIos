//
//  GoStopApp.swift
//  GoStop
//
//  Created by 이태현 on 2022/01/12.
//

import SwiftUI

@main
struct GoStopApp: App {
    @StateObject var dataStore = HistoryDataSource()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                FirstScreen(mainPageHistories: $dataStore.mainPageHistories) { // saveAction()
                    HistoryDataSource.save(mainPageHistorys: dataStore.mainPageHistories) { result in
                        if case .failure(let error) = result {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
                
            }
            .onAppear {
                HistoryDataSource.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let mainPageHistories):
                        dataStore.mainPageHistories = mainPageHistories
                    }
                }
            }
        }
    }
}
