//
//  Longitude+CoreDataProperties.swift
//  
//
//  Created by Lizan Pradhanang on 5/9/17.
//
//

import Foundation
import CoreData


extension Longitude {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Longitude> {
        return NSFetchRequest<Longitude>(entityName: "Longitude");
    }

    @NSManaged public var lon: String?

}
