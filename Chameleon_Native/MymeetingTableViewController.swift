//
//  MymeetingTableViewController.swift
//  Chameleon_Native
//
//  Created by Vincent Zhou on 7/1/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class MymeetingTableViewController: UITableViewController {

    var myMeetings = [Meeting]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "AreaTableViewCell",bundle: nil), forCellReuseIdentifier: "areaCell")
        self.title = "My Meetings";
        self.tableView.tableFooterView = UIView()
        
        let lftBtn = UIButton(frame: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 40, height: 40)))
        lftBtn.contentHorizontalAlignment = .left
        lftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 0)
        lftBtn.setImage(UIImage(named: "back"), for: UIControlState())
        lftBtn.addTarget(self, action: #selector(backtoHome), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: lftBtn)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString:"#a71428")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
    }
    
    func backtoHome(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupData(){
        guard let value = UserDefaults.standard.value(forKey: "userEmail") as? String
            else{
                print("Email is not a string!")
                return
        }
        for device in DeviceManager.sharedInstance.devices {
            for meeting in device.meetings {
                //Get meeting which match user email.
                if meeting.meetingEmail == value {
                    meeting.meetingTitle = device.roomName
                    self.myMeetings.append(meeting)
                }else{
                    continue
                }
            }
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.myMeetings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "areaCell", for: indexPath) as! AreaTableViewCell
        let m = myMeetings[indexPath.row]
        cell.iconImageView.image = UIImage(named: "meetingroom")
        cell.nameLabel.text = m.meetingTitle
        cell.deslabel.text = m.meetingDes
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
