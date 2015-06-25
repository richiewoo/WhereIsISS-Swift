//
//  ISSLocationData.swift
//  WhereIsISS
//
//  Created by Xinbo Wu on 6/11/15.
//  Copyright (c) 2015 Xinbo Wu. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

class ISSLocationData:NSObject {
    let iss_location_url = "http://api.open-notify.org/iss-now.json"
    dynamic var location = CLLocationCoordinate2DMake(37.786996, -122.440100);//I'm in San Francisco now
    var fetchFlag = false
    
    override init(){
        super.init()
        self.startLocationReq()
    }
    
    private func startLocationReq(){
        weak var selfWeak = self;
        Alamofire.request(.GET, iss_location_url).responseJSON { (_, _, JSON, _) in
            
            if  let jsonRes = JSON as? NSDictionary{
                let latitude = jsonRes.valueForKeyPath("iss_position.latitude") as! NSNumber
                let longitude = jsonRes.valueForKeyPath("iss_position.longitude") as! NSNumber
                selfWeak!.location = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue)
            }
        }
    }
    
    func startGetLocation() {
        fetchFlag = true;
        let timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(timer){
            if self.fetchFlag == true {
                self.startLocationReq()
            }else{
                dispatch_source_cancel(timer)
            }
            
        }
        dispatch_resume(timer);
    }
    
    func stopGetLocation() {
        fetchFlag = false
    }
}