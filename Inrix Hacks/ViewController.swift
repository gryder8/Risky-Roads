//
//  ViewController.swift
//  Inrix Hacks
//
//  Created by Gavin Ryder on 11/13/21.
//

import UIKit
import MapKit



class ViewController: UIViewController, MKMapViewDelegate {
    


    
    //MARK: Oulets
    @IBOutlet weak var mapView: MKMapView! //mapKit view
    @IBOutlet var superView: UIView!
    
    @IBOutlet weak var button1: UIButtonWithRoutedMap!
    @IBOutlet weak var button2: UIButtonWithRoutedMap!
    @IBOutlet weak var button3: UIButtonWithRoutedMap!
    
    var testRegion = MKCoordinateRegion()
    
    var riskScores = [10, 20, 30]
    
    var locations = [
        CLLocation(latitude: 37.78073, longitude: -122.47236),
        CLLocation(latitude: 37.78697, longitude: -122.41154),
        CLLocation(latitude: 37.78758, longitude: -122.42360)         
            ]
    
    
    
    
    func setupButtons() {
        testRegion = mapView.region
        
        let rMap = RoutedMap(region: testRegion, riskScores: riskScores, routePoints: locations)
        
        button1.mapRoute = rMap
        button2.mapRoute = rMap
        button3.mapRoute = rMap
        
//        button1.addTarget(self, action: #selector(pressedButton(sender:)), for: .touchUpInside)
//        button2.addTarget(self, action: #selector(pressedButton(sender:)), for: .touchUpInside)
//        button3.addTarget(self, action: #selector(pressedButton(sender:)), for: .touchUpInside)
    }
    
//    @objc func pressedButton(sender: Any) { //present the VC from here!
//        if sender is UIButtonWithRoutedMap {
//            let buttonSender = sender as! UIButtonWithRoutedMap //know this is safe since we check for type
////            let newSelectedView = SelectedView()
////            newSelectedView.mapWithRoute = buttonSender.mapRoute //button must have a map route!
////            newSelectedView.modalPresentationStyle = .overFullScreen //set the presentation type
////            self.present(newSelectedView, animated: true, completion: nil) //present the new VC
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "button1") {
            (segue.destination as! SelectedView).mapWithRoute = button1.mapRoute
        } else if (segue.identifier == "button2") {
            (segue.destination as! SelectedView).mapWithRoute = button2.mapRoute
        } else if (segue.identifier == "button3") {
            (segue.destination as! SelectedView).mapWithRoute = button3.mapRoute
        }
     }
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupMap()
        setupButtons()
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
    var mapRoute: RoutedMap = RoutedMap()
}


