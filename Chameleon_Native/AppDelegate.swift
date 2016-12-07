//
//  AppDelegate.swift
//  Chameleon_Native
//
//  Created by HamasN on 3/8/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().tintColor = UIColor.white
        
        loadData()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func loadData() {
        if let path = Bundle.main.path(forResource: "meeting", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
                    if let dictionary = jsonResult as? [String:AnyObject] {
                        var devices = [Device]()
                        for key in dictionary.keys {
                            if let subDict = dictionary[key] as? [String:AnyObject]{
                                print("---RIGHT----")
                                let deviceID = key
                                guard let meetingID = subDict["meetingroomID"]as? String,
                                    let meetingRoomAddress = subDict["address"]as?String,
                                    let desc = subDict["description"]as?String,
                                    let roomName = subDict["roomName"]as?String,
                                    let meetings = subDict["meetings"]as? [[String: AnyObject]]
                                    else{return}
                                var mList = [Meeting]()
                                for meeting in meetings {
                                    let m = Meeting()
                                    guard let mTitle = meeting["meetingTitle"]as?String,
                                        let mID = meeting["meetingID"]as?NSNumber,
                                        let startTime = meeting["startTime"]as?String,
                                        let endTime = meeting["endTime"]as?String,
                                        let bookBy = meeting["bookBy"]as?String,
                                        let meetingDes = meeting["meetingDes"]as?String,
                                        let meetingEmail = meeting["meetingEmail"]as?String
                                        else{
                                            print("GUARD ERROR")
                                            return}
                                    m.meetingTitle = mTitle
                                    m.meetingID = mID.intValue
                                    m.startTime = startTime
                                    m.endTime = endTime
                                    m.bookBy = bookBy
                                    m.meetingDes = meetingDes
                                    m.meetingEmail = meetingEmail
                                    mList.append(m)
                                }
                                let d = Device()
                                d.meetingroomAddress = meetingRoomAddress
                                d.meetingroomID = meetingID
                                d.desc = desc
                                d.roomName = roomName
                                d.deviceID = deviceID
                                d.meetings = mList
                                
                                devices.append(d)//Add device to array
                            }
                        }
                        let dm = DeviceManager.sharedInstance
                        dm.devices = devices
                        print(dm.devices.count)
                    }
                } catch {}
            } catch {}
        }
    }
}

