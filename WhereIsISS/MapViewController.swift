//
//  ViewController.swift
//  WhereIsISS
//
//  Created by Xinbo Wu on 6/11/15.
//  Copyright (c) 2015 Xinbo Wu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private var observeContext = 0
    private let locationData = ISSLocationData()
    private let cityAnnotation = CityAnnotation()
    private var isFirstUpdate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationData.addObserver(self, forKeyPath: "location", options: .New, context: &observeContext)
        locationData.startGetLocation()
        self.mapView.addAnnotation(cityAnnotation)
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if context == &observeContext {
            // add the annotation
            cityAnnotation.setCoordinate(locationData.location)
            self.mapView.
            
            if isFirstUpdate {
                //make map move and the the annotation be in center may be better
                self.mapView.setCenterCoordinate(locationData.location, animated: true);
                isFirstUpdate = false
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!{
        // create the annotation view
        let annotationView = CityAnnotation.createViewAnnotationView(mapView, annotation: annotation);
        annotationView.image = UIImage(named: "icon_iss_img");
        
        return annotationView
    }
    
    @IBAction func changMap(sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            self.mapView.mapType = .Satellite
            sender.setImage(UIImage(named: "map_setting_view_btn_normal"), forState: .Normal)
        }else{
            sender.tag = 0
            self.mapView.mapType = .Standard
            sender.setImage(UIImage(named: "map_setting_view_btn_satellite"), forState: .Normal)
        }
    }
    
    @IBAction func location() {
        self.mapView.setCenterCoordinate(locationData.location, animated: true);
    }
    
    deinit {
        locationData.removeObserver(self, forKeyPath: "location", context: &observeContext)
    }
}

