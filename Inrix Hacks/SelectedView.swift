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
    
    @IBOutlet weak var incidentRiskLabel: UILabel!
    @IBOutlet weak var slowdownsRiskLabel: UILabel!
    @IBOutlet weak var speedRiskLabel: UILabel!
    @IBOutlet weak var timeRiskLabel: UILabel!
    @IBOutlet weak var weatherRiskLabel: UILabel!
    
    
    
    public var mapWithRoute: RoutedMap = RoutedMap() //starts as empty!
    
    
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
        
        if(mapWithRoute.routePoints != RoutedMap().routePoints) {
            print(mapWithRoute.region)
            mapView.setRegion(mapView.regionThatFits(mapWithRoute.region), animated: true)
            print("region set!")
            mapView.isScrollEnabled = false
            createPolyLine(locations: mapWithRoute.routePoints)
            mainRiskLabel.layer.masksToBounds = true
            mainRiskLabel.layer.cornerRadius = 10
            
            let riskScore = mapWithRoute.riskScores.total
            
            updateRiskLabel(riskScore: riskScore)
            updateRiskSubLabels(riskScores: mapWithRoute.riskScores)
            
            bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            bottomView.layer.cornerRadius = 25
        }

        // Do any additional setup after loading the view.
    }
    
    func updateRiskLabel(riskScore: Int) {
        mainRiskLabel.text = String(riskScore)
        
        if (riskScore <= 40) {
            mainRiskLabel.backgroundColor = .green
        } else if (riskScore <= 70) {
            mainRiskLabel.backgroundColor = .yellow
        } else {
            mainRiskLabel.backgroundColor = .red
        }
    }
    
    func updateRiskSubLabels(riskScores: Risk) {
        incidentRiskLabel.text = String(riskScores.incidents)
        slowdownsRiskLabel.text = String(riskScores.slowdown)
        speedRiskLabel.text = String(riskScores.speed)
        timeRiskLabel.text = String(riskScores.time)
        weatherRiskLabel.text = String(riskScores.weather)
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
