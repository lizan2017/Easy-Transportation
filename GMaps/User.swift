//
//  User.swift
//  GMaps
//
//  Created by Lizan Pradhanang on 7/5/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable{
    var email:String?
    var fullName:String?
    var imageUrl:String?
    var id:String?
    required init?(map: Map) {
    }
    
   func mapping(map: Map) {
        email <- map["Email"]
        fullName <- map["Full Name"]
        imageUrl <- map["ImageUrl"]
        id <- map["Id"]
    }
}
