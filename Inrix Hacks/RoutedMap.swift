//
//  RoutedMap.swift
//  Inrix Hacks
//
//  Created by Gavin Ryder on 11/13/21.
//

import Foundation
import MapKit

class RoutedMap {
    var region: MKCoordinateRegion
    var riskScores: [Int]
    var routePoints: [CLLocation]
    
    init(region: MKCoordinateRegion, riskScores: [Int], routePoints: [CLLocation]) {
        self.region = region
        self.riskScores = riskScores
        self.routePoints = routePoints
    }
    
    init() { //default, should never be using data from here
        self.region = MKCoordinateRegion()
        self.riskScores = [0]
        self.routePoints = [CLLocation()]
    }
}
