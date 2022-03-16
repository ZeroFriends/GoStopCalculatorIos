//
//  IngameHistory+CoreDataProperties.swift
//  GoStop
//
//  Created by 이태현 on 2022/03/17.
//
//

import Foundation
import CoreData


extension IngameHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IngameHistory> {
        return NSFetchRequest<IngameHistory>(entityName: "IngameHistory")
    }

    @NSManaged public var money: Int32
    @NSManaged public var origin: MainPageHistory?

}

extension IngameHistory : Identifiable {

}
