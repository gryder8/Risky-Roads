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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupMap()
    }
    
    func setupMap() {
        setupMapConstraints(mapView);
        let centerCoord:CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.778, -122.441)
        let region = MKCoordinateRegion.init(center: centerCoord, latitudinalMeters: 9200, longitudinalMeters: 9200)
        mapView.setRegion(region, animated: true)
    }
    
    func setupMapConstraints(_ mapView: MKMapView) {
//        let bounds:UILayoutGuide = superView.safeAreaLayoutGuide
//        mapView.leadingAnchor.constraint(equalTo: bounds.leadingAnchor).isActive = true
//        mapView.bottomAnchor.constraint(equalTo: bounds.bottomAnchor).isActive = true
//        mapView.topAnchor.constraint(equalTo: bounds.topAnchor).isActive = true
//        mapView.trailingAnchor.constraint(equalTo: bounds.trailingAnchor).isActive = true
        mapView.bounds = superView.bounds
    }
    



}

