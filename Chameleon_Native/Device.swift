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

//dispatch_once is deprecated in Swift 3

class DeviceManager {
    static let sharedInstance = DeviceManager()
    var devices:[Device] = [Device]()
}
