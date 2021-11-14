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

func fetchRisk(_ wp1: String, _ wp2: String, completion: @escaping (_ riskMap: RiskMap?, _ error: Error?)->()) {
    let url = URL(string: "http://127.0.0.1:5000/" + "risk?wp1=" + wp1 + "&wp2=" + wp2)!
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
    
    var riskScores = Risk(incidents: 0, slowdown: 0, speed: 0, time: 0, weather: 0, total: 0) //init
    
    var locations = [ //TESTING
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
    
    
    
    @objc func pressedButton(sender: Any) {
        let group = DispatchGroup()
            group.enter()
            
        var button = UIButtonWithRoutedMap()
        
        if(sender is UIButtonWithRoutedMap){
            button = sender as! UIButtonWithRoutedMap
        }
        
        let buttonID = button.restorationIdentifier
        var wp1:String
        var wp2:String
        
        if (buttonID == "button1") {
            wp1 = "37.761982,-122.435150" //Castro Theatre
            wp2 = "37.808418,-122.415836" //Fisherman's Wharf
        } else if (buttonID == "button2") {
            wp1 = "37.802728,-122.405810" //Coit Tower
            wp2 = "37.777105,-122.450536" //USF
        } else {
            wp1 = "37.779119,-122.390310" //Oracle Park
            wp2 = "37.804459,-122.4487209" //Palace of Fine Arts
        }
            fetchRisk(wp1, wp2)
            { riskMap, error in
                    //print(self.convertRawRiskMapToRouted(riskMap!).routePoints)
                    button.setMapRoutes(self.convertRawRiskMapToRouted(riskMap!))
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
            let mapRegion = MKCoordinateRegion(center: center, latitudinalMeters: boundingBox.radius*1.9 + abs(route.points[0][1] - route.points[route.points.count - 1][1]) * 111111 * 0.5, longitudinalMeters: boundingBox.radius*1.9 + abs(route.points[0][0] - route.points[route.points.count - 1][0]) * 111111 * 0.5)
            
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
            pressedButton(sender: button1!)
            (segue.destination as! SelectedView).mapWithRoutes = button1.mapRoutes
        } else if (segue.identifier == "button2") {
            pressedButton(sender: button2!)
            (segue.destination as! SelectedView).mapWithRoutes = button2.mapRoutes
        } else if (segue.identifier == "button3") {
            pressedButton(sender: button3!)
            (segue.destination as! SelectedView).mapWithRoutes = button3.mapRoutes
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupMap()
        
        whereToLabel.layer.masksToBounds = true
        whereToLabel.layer.cornerRadius = 10
        
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomView.layer.cornerRadius = 25

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


