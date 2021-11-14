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
    var riskScores: Risk
    var routePoints: [CLLocation]
    
    init(region: MKCoordinateRegion, riskScores: Risk, routePoints: [CLLocation]) {
        self.region = region
        self.riskScores = riskScores
        self.routePoints = routePoints
    }
    
    init() { //default, should never be using data from here
        self.region = MKCoordinateRegion()
        self.riskScores = Risk(incidents: 0, slowdown: 0, speed: 0, time: 0, weather: 0, total: 0)
        self.routePoints = [CLLocation()]
    }
}
