//
//  Name+CoreDataProperties.swift
//  
//
//  Created by Lizan Pradhanang on 5/11/17.
//
//

import Foundation
import CoreData


extension Name {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Name> {
        return NSFetchRequest<Name>(entityName: "Name");
    }

    @NSManaged public var name: String?

}
