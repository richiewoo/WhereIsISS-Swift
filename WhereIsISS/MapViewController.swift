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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationData.addObserver(self, forKeyPath: "location", options: .New, context: &observeContext)
        locationData.startGetLocation()
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if context == &observeContext {
            // add the annotation
            cityAnnotation.setCoordinate(locationData.location)
            self.mapView.addAnnotation(cityAnnotation)
            
            //make map move and the the annotation be in center may be better
            self.mapView.setCenterCoordinate(locationData.location, animated: true);
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!{
        // create the annotation view
        let annotationView = CityAnnotation.createViewAnnotationView(mapView, annotation: annotation);
        annotationView.image = UIImage(named: "icon_iss_img.png");
        
        return annotationView
    }
    
    deinit {
        locationData.removeObserver(self, forKeyPath: "location", context: &observeContext)
    }
}

