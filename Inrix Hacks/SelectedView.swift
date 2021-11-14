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
    @IBOutlet var superView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    public var mapWithRoute: RoutedMap = RoutedMap() //starts as empty!
    
    
    func addCloseButton() {
        let closeBtn = UIButton(type: .close)
        closeBtn.isEnabled = true
        closeBtn.tintColor = .blue
        closeBtn.frame = CGRect(x: 30, y: 40, width: 35, height: 35)
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
        
        if(mapWithRoute.routePoints != RoutedMap().routePoints) {
            mapView.setRegion(mapWithRoute.region, animated: true)
            createPolyLine(locations: mapWithRoute.routePoints)
            
        }

        // Do any additional setup after loading the view.
    }
    
    func createPolyLine(locations: [CLLocation]){
        addPolyLineToMap(locations: locations)
    }
    
    func addPolyLineToMap(locations: [CLLocation]) {
            var coordinates = locations.map({ (location: CLLocation!) -> CLLocationCoordinate2D in
                return location.coordinate
            })

            let polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
            mapView.addOverlay(polyline)
    }
    
    private func mapView(mapView: MKMapView!, viewForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {

            if (overlay is MKPolyline) {
                let polylineRenderer = MKPolylineRenderer(overlay: overlay);
                polylineRenderer.strokeColor = UIColor.red.withAlphaComponent(0.5);
                polylineRenderer.lineWidth = 5;
                return polylineRenderer;
            }

            return nil
        }

}
