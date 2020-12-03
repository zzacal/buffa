//
//  Identity+CoreDataProperties.swift
//  buffa
//
//  Created by Zac Zacal on 11/25/20.
//
//

import Foundation
import CoreData


extension Identity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Identity> {
        return NSFetchRequest<Identity>(entityName: "Identity")
    }

    @NSManaged public var email: String?
    @NSManaged public var key: String?
    @NSManaged public var token: String?
    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?

}

extension Identity : Identifiable {

}
