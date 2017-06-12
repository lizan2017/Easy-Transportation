//
//  LoginData+CoreDataProperties.swift
//  
//
//  Created by Lizan Pradhanang on 6/10/17.
//
//

import Foundation
import CoreData


extension LoginData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoginData> {
        return NSFetchRequest<LoginData>(entityName: "LoginData");
    }

    @NSManaged public var email: String?

}
