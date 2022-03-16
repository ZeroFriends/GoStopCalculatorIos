//
//  Rule+CoreDataProperties.swift
//  GoStop
//
//  Created by 이태현 on 2022/03/17.
//
//

import Foundation
import CoreData


extension Rule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rule> {
        return NSFetchRequest<Rule>(entityName: "Rule")
    }

    @NSManaged public var jumDang: Int32
    @NSManaged public var ppuck: Int32
    @NSManaged public var firstTadack: Int32
    @NSManaged public var sell: Int32
    @NSManaged public var origin: MainPageHistory?

}

extension Rule : Identifiable {

}
