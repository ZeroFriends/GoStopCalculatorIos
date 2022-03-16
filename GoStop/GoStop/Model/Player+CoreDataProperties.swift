//
//  Player+CoreDataProperties.swift
//  GoStop
//
//  Created by 이태현 on 2022/03/17.
//
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var name: String?
    @NSManaged public var origin: MainPageHistory?

}

extension Player : Identifiable {

}
