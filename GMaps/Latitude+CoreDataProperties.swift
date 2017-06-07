//
//  Latitude+CoreDataProperties.swift
//  
//
//  Created by Lizan Pradhanang on 5/9/17.
//
//

import Foundation
import CoreData


extension Latitude {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Latitude> {
        return NSFetchRequest<Latitude>(entityName: "Latitude");
    }

    @NSManaged public var lat: String?

}
