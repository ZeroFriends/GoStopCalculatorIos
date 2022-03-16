//
//  MainPageHistory+CoreDataProperties.swift
//  GoStop
//
//  Created by 이태현 on 2022/03/17.
//
//

import Foundation
import CoreData


extension MainPageHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainPageHistory> {
        return NSFetchRequest<MainPageHistory>(entityName: "MainPageHistory")
    }

    @NSManaged public var historyName: String?
    @NSManaged public var date: Date?
    @NSManaged public var player: NSSet?
    @NSManaged public var rule: Rule?
    @NSManaged public var ingameHistory: NSSet?

}

// MARK: Generated accessors for player
extension MainPageHistory {

    @objc(addPlayerObject:)
    @NSManaged public func addToPlayer(_ value: Player)

    @objc(removePlayerObject:)
    @NSManaged public func removeFromPlayer(_ value: Player)

    @objc(addPlayer:)
    @NSManaged public func addToPlayer(_ values: NSSet)

    @objc(removePlayer:)
    @NSManaged public func removeFromPlayer(_ values: NSSet)

}

// MARK: Generated accessors for ingameHistory
extension MainPageHistory {

    @objc(addIngameHistoryObject:)
    @NSManaged public func addToIngameHistory(_ value: IngameHistory)

    @objc(removeIngameHistoryObject:)
    @NSManaged public func removeFromIngameHistory(_ value: IngameHistory)

    @objc(addIngameHistory:)
    @NSManaged public func addToIngameHistory(_ values: NSSet)

    @objc(removeIngameHistory:)
    @NSManaged public func removeFromIngameHistory(_ values: NSSet)

}

extension MainPageHistory : Identifiable {

}
