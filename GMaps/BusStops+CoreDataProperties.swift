//
//  BusStops+CoreDataProperties.swift
//  
//
//  Created by Lizan Pradhanang on 6/5/17.
//
//

import Foundation
import CoreData


extension BusStops {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusStops> {
        return NSFetchRequest<BusStops>(entityName: "BusStops");
    }

    @NSManaged public var name: String?
    @NSManaged public var lat: String?
    @NSManaged public var lon: String?

}
