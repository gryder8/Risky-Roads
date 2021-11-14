//
//  SelectedView.swift
//  Inrix Hacks
//
//  Created by Gavin Ryder on 11/13/21.
//

import UIKit
import Foundation
import MapKit

class SelectedView: UIViewController, MKMapViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mainRiskLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var previousRouteButton: UIButton!
    @IBOutlet weak var nextRouteButton: UIButton!
    
    public var mapWithRoutes: [RoutedMap] = [] //starts as empty!
    public var routeIndex = 0
    
    func addCloseButton() {
        let closeBtn = UIButton(type: .close)
        closeBtn.isEnabled = true
        closeBtn.tintColor = .blue
        closeBtn.frame = CGRect(x: 10, y: 20, width: 35, height: 35)
        closeBtn.addTarget(self, action: #selector(self.closeView), for: .touchUpInside)
        closeBtn.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        closeBtn.translatesAutoresizingMaskIntoConstraints = true
        mapView.addSubview(closeBtn)
    }
    
    @objc func closeView() {
        //print("***CALLED***")
        self.dismiss(animated: true, completion: nil) //this deallocates the VC so we need to set the delegate for the mapView to nil to avoid crashes on re-appearing
        //mapView.isHidden = true
    }
    
    deinit {
        self.mapView.delegate = nil
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addCloseButton()
        
        if(mapWithRoutes[routeIndex].routePoints != RoutedMap().routePoints) {
            print(mapWithRoutes[routeIndex].region)
            mapView.setRegion(mapView.regionThatFits(mapWithRoutes[routeIndex].region), animated: true)
            print("region set!")
            mapView.isScrollEnabled = false
            createPolyLine(locations: mapWithRoutes[routeIndex].routePoints)
            mainRiskLabel.layer.masksToBounds = true
            mainRiskLabel.layer.cornerRadius = 10
            mainRiskLabel.text = String(mapWithRoutes[routeIndex].riskScores.total)
            bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            bottomView.layer.cornerRadius = 25
            setupButtons()
        }

        // Do any additional setup after loading the view.
    }
    
    func createPolyLine(locations: [CLLocation]){
        //print(locations)
        addPolyLineToMap(locations: locations)
    }
    
    func addPolyLineToMap(locations: [CLLocation]) {
            var coordinates = locations.map({ (location: CLLocation!) -> CLLocationCoordinate2D in
                return location.coordinate
            })

            let polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
            mapView.addOverlay(polyline)
            print("drawn!")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.blue.withAlphaComponent(0.8)
            renderer.lineWidth = 5
            return renderer
        }

        return MKOverlayRenderer()
    }
    
    func setupButtons() {
        nextRouteButton.addTarget(self, action: #selector(nextRoute), for: .touchUpInside)
        previousRouteButton.addTarget(self, action: #selector(prevRoute), for: .touchUpInside)
        previousRouteButton.isEnabled = false
    }
    
    @objc func nextRoute() {
        clearOverlay()
        previousRouteButton.isEnabled = true
        routeIndex += 1
        mainRiskLabel.text = String(mapWithRoutes[routeIndex].riskScores.total)
        mapView.setRegion(mapView.regionThatFits(mapWithRoutes[routeIndex].region), animated: true)
        createPolyLine(locations: mapWithRoutes[routeIndex].routePoints)
        if routeIndex == mapWithRoutes.count - 1 {
            nextRouteButton.isEnabled = false
        }
    }
    
    @objc func prevRoute() {
        clearOverlay()
        nextRouteButton.isEnabled = true
        routeIndex -= 1
        mainRiskLabel.text = String(mapWithRoutes[routeIndex].riskScores.total)
        mapView.setRegion(mapView.regionThatFits(mapWithRoutes[routeIndex].region), animated: true)
        createPolyLine(locations: mapWithRoutes[routeIndex].routePoints)
        if routeIndex == 0 {
            previousRouteButton.isEnabled = false
        }
    }
    
    func clearOverlay() {
        self.mapView.overlays.forEach {
                if ($0 is MKPolyline) {
                    self.mapView.removeOverlay($0)
                }
            }
    }

}

//extension ViewController {
//
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolylineRenderer(overlay: overlay)
//        renderer.strokeColor = .systemIndigo
//        renderer.lineCap = .round
//        renderer.lineWidth = 10.0
//
//        return renderer
//    }
//
//}
