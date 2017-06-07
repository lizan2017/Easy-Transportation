//
//  BusStops.swift
//  GMaps
//
//  Created by Lizan Pradhanang on 6/5/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import Foundation

class busStops{
    var name:String
    var lat:String
    var lon:String
    
    init(stopName:String,stopLatitude:String,stopLongitude:String) {
        name = stopName
        lat = stopLatitude
        lon = stopLongitude
        
    }
}
