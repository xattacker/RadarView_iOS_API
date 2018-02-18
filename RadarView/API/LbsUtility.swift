//
//  LbsUtility.swift
//  UtilToolKit
//
//  Created by xattacker on 2015/12/9.
//  Copyright © 2015年 xattacker. All rights reserved.
//

import UIKit
import CoreLocation


let RC = Double(6378137)
let RJ = Double(6356725)

// radius of earth
let EARTH_RADIUS = 6378.137


public class LbsUtility
{
    public class func getDistance(_ lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double
    {
        let radLat1 = rad(lat1)
        let radLat2 = rad(lat2)
        let a = radLat1 - radLat2
        let b = rad(lng1) - rad(lng2)
        let a1 = sin(a / 2) * sin(a / 2)
        let a2 = cos(radLat1) * cos(radLat2)
        let b1 = sin(b / 2) * sin(b / 2)
        
        var distance = 2 * asin(sqrt(a1 + a2 * b1))
        distance = distance * EARTH_RADIUS * 1000
        
        let temp = Int(distance * 100)
        distance = Double(temp) / 100.0
        
        return distance
    }

    public class func getDistance(
    _ coord1: CLLocationCoordinate2D,
    coord2: CLLocationCoordinate2D) -> Double
    {
        return self.getDistance(
               coord1.latitude,
               lng1: coord1.longitude,
               lat2: coord2.latitude,
               lng2: coord2.longitude)
    }
    
    private class func rad(_ d: Double) -> Double
    {
        return (d * Double.pi) / 180
    }
}
