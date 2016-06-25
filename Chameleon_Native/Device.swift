//
//  Device.swift
//  Chameleon_Native
//
//  Created by Vincent Zhou on 6/22/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class Device: NSObject {
    var deviceID:String = ""
    var meetingroomID = ""
    var meetingroomAddress = ""
    var meetings = [Meeting]()
    var roomName = ""
    var desc = ""

}

class DeviceManager: NSObject {
    var devices:[Device] = [Device]()
    
    class var sharedInstance: DeviceManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: DeviceManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = DeviceManager()
        }
        return Static.instance!
    }

}