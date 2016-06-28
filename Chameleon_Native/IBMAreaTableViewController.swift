//
//  IBMAreaTableViewController.swift
//  Chameleon_Native
//
//  Created by Vincent Zhou on 6/21/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit
import CoreLocation

class IBMAreaTableViewController: UITableViewController {
    
    var deviceList = [CLBeacon]()
    var deviceInfo:NSArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let path = NSBundle.mainBundle().pathForResource("beaconDevices", ofType: "plist") {
            self.deviceInfo = NSArray(contentsOfFile: path)
        }
        
        self.tableView.registerNib(UINib(nibName: "AreaTableViewCell",bundle: nil), forCellReuseIdentifier: "areaCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor(hexString: "#f0f1f3")
        self.title = "IBM Areas"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString:"#a71428")
        
        let lftBtn = UIButton(frame: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 40, height: 40)))
        lftBtn.contentHorizontalAlignment = .Left
        lftBtn.setImage(UIImage(named: "mymeeting"), forState: .Normal)
        lftBtn.addTarget(self, action: #selector(showMyMeeting), forControlEvents: .TouchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: lftBtn)
        let replyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        replyBtn.setImage(UIImage(named: "radar"), forState: UIControlState.Normal)
        replyBtn.addTarget(self, action: #selector(backToHome), forControlEvents:  UIControlEvents.TouchUpInside)
        let item = UIBarButtonItem(customView: replyBtn)
        self.navigationItem.rightBarButtonItem = item

    }
    
    func backToHome() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func showMyMeeting(){
        print("Show My Meetings")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("areaCell", forIndexPath: indexPath) as! AreaTableViewCell
        let beacon = deviceList[indexPath.row]
        
        let minor = beacon.minor.integerValue
        
        for d in DeviceManager.sharedInstance.devices {
            print(d.deviceID)
            if Int(d.deviceID) == minor {
                print("ddddddddddd+\(d.meetingroomID)")
                cell.nameLabel.text = d.roomName
                cell.deslabel.text = d.desc
                cell.iconImageView.image = UIImage(named: "meetingroom")
                break
            }else{
                continue
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let beacon = deviceList[indexPath.row]
        let minor = beacon.minor.integerValue
        for d in DeviceManager.sharedInstance.devices {
            if Int(d.deviceID) == minor {
                self.performSegueWithIdentifier("showMeeting", sender: d)
                break
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMeeting"{
            if let vc = segue.destinationViewController as? MeetingRoomTableViewController {
                if let obj = sender as? Device {
                    vc.device = obj
                }
            }
        }
    }
    
}
