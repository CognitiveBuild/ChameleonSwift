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

class HomeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIGestureRecognizerDelegate {
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
        myTable.register(UINib(nibName: "beaconTableViewCell", bundle: nil), forCellReuseIdentifier: "beaconCell")
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(startSearchingBeacon))
        gesture.delegate = self
        self.searchBtn.addGestureRecognizer(gesture)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        let lftBtn = UIButton(frame: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 160, height: 40)))
        lftBtn.contentHorizontalAlignment = .left
        lftBtn.setImage(UIImage(named: "menu"), for: UIControlState())
        lftBtn.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: lftBtn)
        
        //Request authorization 
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUIAppearance()
        myTable.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.deviceList.removeAll()
    }
    func setupUIAppearance(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true;
        self.navigationController?.view.backgroundColor = UIColor.clear
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        //Table View
        myTable.backgroundColor = UIColor.clear
        myTable.tableFooterView = UIView()
        myTable.separatorStyle = UITableViewCellSeparatorStyle.none

    }

    func startSearchingBeacon(_ sender: UILongPressGestureRecognizer){
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            self.stopSearching()
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            self.startSearching()
        }else if sender.state == .cancelled {
            self.stopSearching()
        }
    }
    func startSearching(){
        _disPlayLink = CADisplayLink(target: self, selector: #selector(HomeViewController.setupAnimationLayer))
        _disPlayLink?.frameInterval = 40
        _disPlayLink?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
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
            let areaPage = self.storyboard?.instantiateViewController(withIdentifier: "ibmAreaVC") as! IBMAreaTableViewController
            areaPage.deviceList = self.deviceList
            self.navigationController?.pushViewController(areaPage, animated: true)
        }else{
            
        }
    }
    
    func logout() {
        print("Logout")
        self.pleaseWait()
        UserDefaults.standard.removeObject(forKey: "userPassword");
        self.perform(#selector(ShowLogin), with: nil, afterDelay: 3)
        
    }
    func ShowLogin() {
        self.clearAllNotice()
        self.dismiss(animated: true, completion: nil)
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
        layer.cornerRadius = UIScreen.main.bounds.size.width/2
        layer.frame = CGRect(x: 0, y: 0, width: layer.cornerRadius*2, height: layer.cornerRadius*2)
        layer.position = self.view.layer.position
        let color = UIColor(red: CGFloat.random, green: CGFloat.random, blue:  CGFloat.random, alpha: 1)
        layer.backgroundColor = color.cgColor
        self.view.layer.addSublayer(layer)
        
        
        let defaultCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault);
//        _animationGroup.delegate = self
        _animationGroup.duration = 2.0
        _animationGroup.isRemovedOnCompletion = true
        _animationGroup.timingFunction = defaultCurve
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue  = 1.0
        scaleAnimation.duration = 2
        
        let opencityAnimation = CAKeyframeAnimation(keyPath: "opacity");
        opencityAnimation.duration = 2
        opencityAnimation.values = [0.8,0.4,0]
        opencityAnimation.isRemovedOnCompletion = true
        
        let animations = [scaleAnimation,opencityAnimation]
        _animationGroup.animations = animations
        
        layer.add(_animationGroup, forKey: nil)
        self.perform(#selector(HomeViewController.removeLayer(_:)), with: layer, afterDelay: 1.5)
        self.isAnimating = true
    }
    
    func removeLayer(_ layer:CALayer){
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beaconCell", for: indexPath) as! beaconTableViewCell
        let nRow = indexPath.row
        let beacon = deviceList[nRow] as CLBeacon
        let minor = beacon.minor.intValue
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
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    //is available
                    print("it is available---CLBEACON")
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            print("++++++\(region.identifier) ====== \(beacons.count)")
            self.deviceList = beacons
        } else {
            
        }
        self.myTable.reloadData()
    }

    //MARK - Scanning Method
    func startScanning(){
        let uuid = UUID(uuidString: kGeLoProfileUUID)
        let beaconRegion = CLBeaconRegion(proximityUUID:uuid!, identifier: "com.gelosite")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func stopScanning(){
        let uuid = UUID(uuidString: kGeLoProfileUUID)
        let beaconRegion = CLBeaconRegion(proximityUUID:uuid!, identifier: "com.gelosite")
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(in: beaconRegion)
    }
    
    func calculateDistance(_ txPower:Int, rssi:Double)->Double {
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let s = segue.identifier as String? {
            if s == "showIBMArea" {
                if let vc = segue.destination as? IBMAreaTableViewController {
                    if let p = sender as? [CLBeacon] {
                        vc.deviceList = p
                    }
                }
            }
        }
    }
}

