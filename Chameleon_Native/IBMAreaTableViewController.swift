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
        if let path = Bundle.main.path(forResource: "beaconDevices", ofType: "plist") {
            self.deviceInfo = NSArray(contentsOfFile: path)
        }
        
        self.tableView.register(UINib(nibName: "AreaTableViewCell",bundle: nil), forCellReuseIdentifier: "areaCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor(hexString: "#f0f1f3")
        self.title = "IBM Areas"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString:"#a71428")
        
        let lftBtn = UIButton(frame: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 40, height: 40)))
        lftBtn.contentHorizontalAlignment = .left
        lftBtn.setImage(UIImage(named: "mymeeting"), for: UIControlState())
        lftBtn.addTarget(self, action: #selector(showMyMeeting), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: lftBtn)
        let replyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        replyBtn.setImage(UIImage(named: "radar"), for: UIControlState())
        replyBtn.addTarget(self, action: #selector(backToHome), for:  UIControlEvents.touchUpInside)
        let item = UIBarButtonItem(customView: replyBtn)
        self.navigationItem.rightBarButtonItem = item

    }
    
    func backToHome() {
        self.navigationController?.popViewController(animated: true)
    }
    func showMyMeeting(){
        guard let destVC = self.storyboard!.instantiateViewController(withIdentifier: "myMeetingTable") as? MymeetingTableViewController
            else{
                return
        }
        let naviC = UINavigationController(rootViewController: destVC)
        self.present(naviC, animated: true, completion: nil)
        print("Show My Meetings")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "areaCell", for: indexPath) as! AreaTableViewCell
        let beacon = deviceList[indexPath.row]
        
        let minor = beacon.minor.intValue
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

        let beacon = deviceList[indexPath.row]
        let minor = beacon.minor.intValue
        for d in DeviceManager.sharedInstance.devices {
            if Int(d.deviceID) == minor {
                self.performSegue(withIdentifier: "showMeeting", sender: d)
                break
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMeeting"{
            if let vc = segue.destination as? MeetingRoomTableViewController {
                if let obj = sender as? Device {
                    vc.device = obj
                }
            }
        }
    }
    
}
