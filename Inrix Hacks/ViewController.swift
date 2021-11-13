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
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet var superView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupMap()
    }
    
    func setupMap() {
        let centerCoord:CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.778, -122.441)
        let region = MKCoordinateRegion.init(center: centerCoord, latitudinalMeters: 9200, longitudinalMeters: 9200)
        mapView.setRegion(region, animated: true)
        mapView
    }
    



}

