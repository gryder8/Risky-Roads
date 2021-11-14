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
    @IBOutlet weak var weatherRiskLabel: UILabel!
    @IBOutlet weak var speedRiskLabel: UILabel!
    @IBOutlet weak var timeRiskLabel: UILabel!
    
    @IBOutlet weak var incidentSlider: CustomSlider!
    @IBOutlet weak var slowdownsSlider: CustomSlider!
    @IBOutlet weak var weatherSlider: CustomSlider!
    @IBOutlet weak var speedSlider: CustomSlider!
    @IBOutlet weak var timeSlider: CustomSlider!
    
    @IBOutlet weak var mainRiskSlider: CustomSlider!
    
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
        
        updateRiskLabel(riskScore: mapWithRoutes[routeIndex].riskScores.total)
        
        updateRiskSubLabels( mapWithRoutes[routeIndex].riskScores)
        
        updateRiskSliders( mapWithRoutes[routeIndex].riskScores)
            
        // Do any additional setup after loading the view.
    }
    
    func updateRiskLabel(riskScore: Int) {
        mainRiskLabel.text = String(riskScore)
        mainRiskSlider.value = Float(riskScore)
        if (riskScore <= 40) {
            //mainRiskLabel.backgroundColor = #colorLiteral(red: 0.368627451, green: 0.9647058824, blue: 0.5294117647, alpha: 1)
            //mainRiskLabel.textColor = #colorLiteral(red: 0, green: 0.5647058824, blue: 0.1529411765, alpha: 1)
        } else if (riskScore <= 70) {
            mainRiskLabel.backgroundColor = .yellow
        } else {
            mainRiskLabel.backgroundColor = .red
        }
    }
    
    func updateRiskSliders(_ riskScores: Risk) {
        let dilation: Float = 3.0
        
        incidentSlider.minimumTrackTintColor = UIColor.blue.withAlphaComponent(0.8)
        slowdownsSlider.minimumTrackTintColor = UIColor.blue.withAlphaComponent(0.8)
        speedSlider.minimumTrackTintColor = UIColor.blue.withAlphaComponent(0.8)
        timeSlider.minimumTrackTintColor = UIColor.blue.withAlphaComponent(0.8)
        weatherSlider.minimumTrackTintColor = UIColor.blue.withAlphaComponent(0.8)
        
        incidentSlider.value = Float(riskScores.incidents) * dilation
        slowdownsSlider.value = Float(riskScores.slowdown) * dilation
        speedSlider.value = Float(riskScores.speed) * dilation
        timeSlider.value = Float(riskScores.time) * dilation
        weatherSlider.value = Float(riskScores.weather) * dilation
    }
    
    func updateRiskSubLabels(_ riskScores: Risk) {
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
    
    func setupButtons() {
        nextRouteButton.addTarget(self, action: #selector(nextRoute), for: .touchUpInside)
        previousRouteButton.addTarget(self, action: #selector(prevRoute), for: .touchUpInside)
        previousRouteButton.isEnabled = false
        if mapWithRoutes.count == 1 {
            nextRouteButton.isEnabled = false
        }
    }
    
    @objc func nextRoute() {
        clearOverlay()
        previousRouteButton.isEnabled = true
        routeIndex += 1
        updateRiskLabel(riskScore: mapWithRoutes[routeIndex].riskScores.total)
        updateRiskSubLabels(mapWithRoutes[routeIndex].riskScores)
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
        updateRiskLabel(riskScore: mapWithRoutes[routeIndex].riskScores.total)
        updateRiskSubLabels(mapWithRoutes[routeIndex].riskScores)
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
