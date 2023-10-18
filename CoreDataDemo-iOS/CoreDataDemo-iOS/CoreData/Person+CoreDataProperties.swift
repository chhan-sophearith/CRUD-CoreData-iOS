//
//  Person+CoreDataProperties.swift
//  CoreDataDemo-iOS
//
//  Created by Chhan Sophearith on 18/10/23.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var age: Int16
    @NSManaged public var name: String?
    @NSManaged public var createAt: Date?

}

extension Person : Identifiable {

}
