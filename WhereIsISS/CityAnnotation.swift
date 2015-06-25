//
//  CityAnnotation.swift
//  WhereIsISS
//
//  Created by Xinbo Wu on 6/11/15.
//  Copyright (c) 2015 Xinbo Wu. All rights reserved.
//

import Foundation
import MapKit

class CityAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D{
        get{
            return self.theCoordinate
        }
    }
    var title: String = ""
    
    var theCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var clLoc: CLLocation?
    var clRGeo: CLGeocoder?
    
    func setCoordinate(newCoordinate: CLLocationCoordinate2D){
        self.theCoordinate = newCoordinate
        self.geocodeLocation()
    }
    
    private func geocodeLocation() {
        if nil == clLoc {
            clLoc = CLLocation(coordinate: self.theCoordinate, altitude: kCLDistanceFilterNone, horizontalAccuracy: kCLLocationAccuracyBest, verticalAccuracy: kCLLocationAccuracyBest, timestamp: NSDate())
        }
        if nil == clRGeo {
            clRGeo = CLGeocoder()
        }
        
        clRGeo?.reverseGeocodeLocation(clLoc){
            (placemarks, error) in
            if placemarks.count > 0 {
                let pmk : CLPlacemark = placemarks[0] as! CLPlacemark
                if((pmk.locality) != nil){
                    self.title = pmk.locality;   // city, eg. Cupertino
                }else if((pmk.administrativeArea) != nil){
                    self.title = pmk.administrativeArea; // state, eg. CA
                }else if((pmk.country) != nil){
                    self.title = pmk.country;    // eg. United States
                }else if((pmk.ocean) != nil){
                    self.title = pmk.ocean;  // eg. Pacific Ocean
                }else if((pmk.name) != nil){
                    self.title = pmk.name;   // eg. Apple Inc.
                }else{
                    self.title = "Maybe I am lost";
                }
            }
        }
    }
    
    class func createViewAnnotationView(mapView:MKMapView, annotation: AnyObject) -> MKAnnotationView{
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("CityAnnotation")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation as! MKAnnotation, reuseIdentifier: "CityAnnotation")
            annotationView.canShowCallout = true
            //annotationView.centerOffset = CGPointMake(annotationView.centerOffset.x + annotationView.image.size.width/2, annotationView.centerOffset.y - annotationView.image.size.height/2)
        }
        else
        {
            annotationView.annotation = annotation as! MKAnnotation
        }
        return annotationView
        
    }
}