//
//  Chameleon.swift
//  Chameleon
//
//  Created by Vincent Zhou on 7/4/16.
//  Copyright © 2016 GBS Innovation Center. All rights reserved.
//

import UIKit
import CoreLocation

@objc public protocol ChameleonDelegate{
    
}

public class Chameleon: NSObject,CLLocationManagerDelegate {

    /// Initialize location manager
    internal let locationManager = CLLocationManager()
    
    public var delegate:ChameleonDelegate?
    internal var uuid:NSUUID?
    internal var bRegion:CLRegion?
    internal var beaconId:String?
    
    /**
     Initialises the Chameleon class and request the authorization from user.
     
     - returns: void
     */
    public override init() {
        NSLog("Chameleon has been initialised successfully")
        locationManager.requestAlwaysAuthorization()
    }
    
    public convenience init(uuid:String,identifier:String,delegate:ChameleonDelegate?) {
        self.init()
        self.setupBeacon(uuid, identifier: identifier)
    }
    public func setupBeacon(uuid:String,identifier:String){
        self.uuid = NSUUID(UUIDString: uuid)
        let beaconRegion = CLBeaconRegion(proximityUUID:self.uuid!, identifier: identifier)
        self.startMonitor(beaconRegion)
    }
    public func startMonitor(region:CLBeaconRegion){
        
        locationManager.startMonitoringForRegion(region)
        locationManager.startRangingBeaconsInRegion(region)
    }
    public func getUserAuthorization()->Bool{
        NSLog("Get User Autorization")
        return true
    }
}
