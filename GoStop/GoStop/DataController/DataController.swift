//
//  GoStopViewModel.swift
//  GoStop
//
//  Created by 이태현 on 2022/02/16.
//

import Foundation

class DataController: ObservableObject {
    @Published var mainPageHistories: [MainPageHistory] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("mainPageHistories.data")
    }
    
    static func load(completion: @escaping (Result<[MainPageHistory], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileUrl = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileUrl) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                
                let mainPageHistories = try JSONDecoder().decode([MainPageHistory].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(mainPageHistories))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(mainPageHistorys: [MainPageHistory], completion: @escaping (Result<Int,Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(mainPageHistorys)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(mainPageHistorys.count))
                }
            } catch {
                completion(.failure(error))
            }
            
        }
    }
    
}
