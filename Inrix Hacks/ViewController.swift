//
//  ViewController.swift
//  Inrix Hacks
//
//  Created by Gavin Ryder on 11/13/21.
//

import UIKit
import MapKit

// MARK: - RiskMap
struct RiskMap: Codable {
    let routes: [Route]
}

// MARK: - Route
struct Route: Codable {
    let boundingBox: BoundingBox
    let id: String
    let points: [[Double]]
    let risk: Risk
}

// MARK: - BoundingBox
struct BoundingBox: Codable {
    let center: [Double]
    let radius: Double
}

// MARK: - Risk
struct Risk: Codable {
    let incidents, slowdown, speed, time, weather: Double
    let total: Int
}

func fetchRisk(completion: @escaping (_ riskMap: RiskMap?, _ error: Error?)->()) {
    let url = URL(string: "http://127.0.0.1:5000/" + "risk")!
    let request = URLRequest(url: url)
    let t = URLSession.shared.dataTask(with: request)
    { data, response, error in
        guard let data = data,
                  error == nil else
        {
            completion(nil, error)
            return
        }
        let riskMap = try? JSONDecoder().decode(RiskMap.self, from: data)
        completion(riskMap, error)
    }
    t.resume()
}

class ViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: Oulets
    @IBOutlet weak var mapView: MKMapView! //mapKit view
    @IBOutlet var superView: UIView!
    
    @IBOutlet weak var whereToLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var button1: UIButtonWithRoutedMap!
    @IBOutlet weak var button2: UIButtonWithRoutedMap!
    @IBOutlet weak var button3: UIButtonWithRoutedMap!
    
    var testRegion = MKCoordinateRegion()
    let geocoder = CLGeocoder()
    
    var riskScores = Risk(incidents: 0, slowdown: 0, speed: 0, time: 0, weather: 0, total: 0)
    
    var locations = [
        [
            CLLocation(latitude: 37.78073, longitude: -122.47236),
            CLLocation(latitude: 37.78697, longitude: -122.41154)
        ],
        [
            CLLocation(latitude: 37.80073, longitude: -122.47236),
            CLLocation(latitude: 37.80697, longitude: -122.41154)
        ],
        [
            CLLocation(latitude: 37.75073, longitude: -122.47236),
            CLLocation(latitude: 37.75069, longitude: -122.41154)
        ]
    
    ]
    
    
    
    func setupButtons() {
//        testRegion = mapView.region
//
//        let rMap = RoutedMap(region: testRegion, riskScores: riskScores, routePoints: locations[0])
//
        
        
        
//        button1.mapRoute = rMap
//        button2.mapRoute = rMap
//        button3.mapRoute = rMap
        
//        button1.addTarget(self, action: #selector(pressedButton(sender:)), for: .touchUpInside)
//        button2.addTarget(self, action: #selector(pressedButton(sender:)), for: .touchUpInside)
//        button3.addTarget(self, action: #selector(pressedButton(sender:)), for: .touchUpInside)
    }
    
    @objc func pressedButton(sender: Any) {
        let group = DispatchGroup()
            group.enter()
            
            fetchRisk()
            { riskMap, error in
                    //print(self.convertRawRiskMapToRouted(riskMap!).routePoints)
                    self.button1.setMapRoutes(self.convertRawRiskMapToRouted(riskMap!))
                    group.leave()
            }
        
            group.wait()
    }
    
    func convertRawRiskMapToRouted(_ riskMap: RiskMap) -> [RoutedMap] {
        var routedMaps: [RoutedMap] = []
        
        for route in riskMap.routes {
            let boundingBox: BoundingBox = route.boundingBox
            let center = CLLocationCoordinate2DMake(boundingBox.center[1], boundingBox.center[0])
            print(boundingBox.radius)
            let mapRegion = MKCoordinateRegion(center: center, latitudinalMeters: boundingBox.radius*2, longitudinalMeters: boundingBox.radius*2)
            
            var coords:[CLLocation] = []
            for point in route.points {
                coords.append(CLLocation(latitude: point[1], longitude: point[0]))
            }
            print(coords)
            
            let risk = route.risk
            
            routedMaps.append(RoutedMap(region: mapRegion, riskScores: risk, routePoints: coords))
        }
        
        return routedMaps
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "button1") {
            pressedButton(sender: button1)
            (segue.destination as! SelectedView).mapWithRoutes = button1.mapRoutes
        } else if (segue.identifier == "button2") {
            (segue.destination as! SelectedView).mapWithRoutes = button2.mapRoutes
        } else if (segue.identifier == "button3") {
            (segue.destination as! SelectedView).mapWithRoutes = button3.mapRoutes
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupMap()
        setupButtons()
        whereToLabel.layer.masksToBounds = true
        whereToLabel.layer.cornerRadius = 10
        
    
        
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomView.layer.cornerRadius = 25
        //DispatchQueue.main.async {
        //}
    }
    
    func setupMap() {
        let centerCoord:CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.778, -122.441)
        let region = MKCoordinateRegion.init(center: centerCoord, latitudinalMeters: 9200, longitudinalMeters: 9200)
        mapView.setRegion(region, animated: true)
    }
    
}

class UIButtonWithRoutedMap: UIButton {
    var mapRoutes: [RoutedMap] = []
    
    func setMapRoutes(_ routedMaps: [RoutedMap]) {
        mapRoutes = routedMaps
        print("set!")
    }
}


