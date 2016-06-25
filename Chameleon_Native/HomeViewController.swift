//
//  ViewController.swift
//  Chameleon_Native
//
//  Created by HamasN on 3/8/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit
import QuartzCore
import CoreBluetooth
import CoreLocation

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIGestureRecognizerDelegate {
    let kGeLoProfileUUID = "11E44F09-4EC4-407E-9203-CF57A50FBCE0"
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var searchBtn: UIButton!
    
    var _animationGroup:CAAnimationGroup = CAAnimationGroup()
    var _disPlayLink:CADisplayLink?
    var isAnimating:Bool = false
    
    var deviceList = [CLBeacon]()
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.registerNib(UINib(nibName: "beaconTableViewCell", bundle: nil), forCellReuseIdentifier: "beaconCell")
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(startSearchingBeacon))
        gesture.delegate = self
        self.searchBtn.addGestureRecognizer(gesture)
        
        setupUIAppearance()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(logout))
        let lftBtn = UIButton(frame: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 160, height: 40)))
        lftBtn.contentHorizontalAlignment = .Left
        lftBtn.setImage(UIImage(named: "mymeeting"), forState: .Normal)
        lftBtn.setTitle("My Meetings", forState: .Normal)
        lftBtn.addTarget(self, action: #selector(showMyMeeting), forControlEvents: .TouchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: lftBtn)
        
        //Request authorization 
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
    }
    func setupUIAppearance(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true;
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        //Table View
        myTable.backgroundColor = UIColor.clearColor()
        myTable.tableFooterView = UIView()
        myTable.separatorStyle = UITableViewCellSeparatorStyle.None

    }

    func startSearchingBeacon(sender: UILongPressGestureRecognizer){
        if sender.state == .Ended {
            print("UIGestureRecognizerStateEnded")
            self.stopSearching()
        }
        else if sender.state == .Began {
            print("UIGestureRecognizerStateBegan.")
            self.startSearching()
        }else if sender.state == .Cancelled {
            self.stopSearching()
        }
    }
    func startSearching(){
        _disPlayLink = CADisplayLink(target: self, selector: #selector(HomeViewController.setupAnimationLayer))
        _disPlayLink?.frameInterval = 40
        _disPlayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        //Start searching beacon
        startScanning()
    }
    func stopSearching(){
        if self.isAnimating {
            //Stop Animating
            self.view.layer.removeAllAnimations()
            _disPlayLink?.invalidate()
            _disPlayLink = nil;
        }
        stopScanning()
        if self.deviceList.count > 0 {
            let areaPage = self.storyboard?.instantiateViewControllerWithIdentifier("ibmAreaVC") as! IBMAreaTableViewController
            areaPage.deviceList = self.deviceList
            self.navigationController?.pushViewController(areaPage, animated: true)
        }else{
            
        }
    }
    
    func logout() {
        print("Logout")
        
    }
    func showMyMeeting(){
        print("Show My Meetings")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//MARK -PRIVATE Method
    func startAnimation(){
        let layer = CALayer()
        layer.cornerRadius = UIScreen.mainScreen().bounds.size.width/2
        layer.frame = CGRectMake(0, 0, layer.cornerRadius*2, layer.cornerRadius*2)
        layer.position = self.view.layer.position
        let color = UIColor(red: CGFloat.random, green: CGFloat.random, blue:  CGFloat.random, alpha: 1)
        layer.backgroundColor = color.CGColor
        self.view.layer.addSublayer(layer)
        
        
        let defaultCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault);
        _animationGroup.delegate = self
        _animationGroup.duration = 2.0
        _animationGroup.removedOnCompletion = true
        _animationGroup.timingFunction = defaultCurve
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue  = 1.0
        scaleAnimation.duration = 2
        
        let opencityAnimation = CAKeyframeAnimation(keyPath: "opacity");
        opencityAnimation.duration = 2
        opencityAnimation.values = [0.8,0.4,0]
        opencityAnimation.removedOnCompletion = true
        
        let animations = [scaleAnimation,opencityAnimation]
        _animationGroup.animations = animations
        
        layer.addAnimation(_animationGroup, forKey: nil)
        self.performSelector(#selector(HomeViewController.removeLayer(_:)), withObject: layer, afterDelay: 1.5)
        self.isAnimating = true
    }
    
    func removeLayer(layer:CALayer){
        layer.removeFromSuperlayer();
    }
    func setupAnimationLayer(){
        self.startAnimation()
    }
    func stopAnimation(){
        self.view.layer.removeAllAnimations()
        _disPlayLink?.invalidate()
        _disPlayLink = nil;
        self.isAnimating = false
    }

    //MARK -Tableview Delegate and DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceList.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("beaconCell", forIndexPath: indexPath) as! beaconTableViewCell
        let nRow = indexPath.row
        let beacon = deviceList[nRow] as CLBeacon
        let minor = beacon.minor.integerValue
        for d in DeviceManager.sharedInstance.devices {
            if Int(d.deviceID) == minor {
                cell.nameLabel.text = d.roomName
                break
            }else{
                continue
            }
        }
        
        cell.distanceLabel.text = "\(Double(round(100*calculateDistance(-59, rssi: Double(beacon.rssi)))/100)) m"
        return cell
    }
    
    //MARK -CLLocationManager Delegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    //is available
                    print("it is available---CLBEACON")
                }
            }
        }
    }
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        if beacons.count > 0 {
            print("++++++\(region.identifier) ====== \(beacons.count)")
            self.deviceList = beacons
        } else {
            
        }
        self.myTable.reloadData()
    }

    //MARK - Scanning Method
    func startScanning(){
        let uuid = NSUUID(UUIDString: kGeLoProfileUUID)
        let beaconRegion = CLBeaconRegion(proximityUUID:uuid!, identifier: "com.gelosite")
        
        locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.startRangingBeaconsInRegion(beaconRegion)
    }
    
    func stopScanning(){
        let uuid = NSUUID(UUIDString: kGeLoProfileUUID)
        let beaconRegion = CLBeaconRegion(proximityUUID:uuid!, identifier: "com.gelosite")
        locationManager.stopMonitoringForRegion(beaconRegion)
        locationManager.stopRangingBeaconsInRegion(beaconRegion)
    }
    
    func calculateDistance(txPower:Int, rssi:Double)->Double {
        if (rssi == 0) {
            return -1.0; // if we cannot determine distance, return -1.
        }
        let ratio = rssi*1.0/Double(txPower) ;
        if (ratio < 1.0) {
            return pow(ratio,Double(10))
        }
        else {
            let accuracy =  (0.89976)*pow(ratio,7.7095) + 0.111;
            return accuracy;
        }
    }
    
    //MARK -prepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let s = segue.identifier as String? {
            if s == "showIBMArea" {
                if let vc = segue.destinationViewController as? IBMAreaTableViewController {
                    if let p = sender as? [CLBeacon] {
                        vc.deviceList = p
                    }
                }
            }
        }
    }
}

