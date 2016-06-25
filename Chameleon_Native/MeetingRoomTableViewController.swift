//
//  MeetingRoomTableViewController.swift
//  Chameleon_Native
//
//  Created by Vincent Zhou on 6/24/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class MeetingRoomTableViewController: UITableViewController {

    var device = Device()
    var meetings = [Meeting]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Regist cell
        self.tableView.registerNib(UINib(nibName: "TodayCell",bundle: nil), forCellReuseIdentifier: "todayCell")
        self.tableView.registerNib(UINib(nibName:"MeetingTimeCell",bundle:nil), forCellReuseIdentifier: "mtCell")
        self.title = device.roomName
        let replyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        replyBtn.setImage(UIImage(named: "radar"), forState: UIControlState.Normal)
        replyBtn.addTarget(self, action: #selector(backToHome), forControlEvents:  UIControlEvents.TouchUpInside)
        let item = UIBarButtonItem(customView: replyBtn)
        self.navigationItem.rightBarButtonItem = item
    }
    
    func backToHome() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return meetings.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let nSection = indexPath.section
        let nRow = indexPath.row
        if nSection == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("todayCell", forIndexPath: indexPath) as! TodayCell
            cell.todayLabel.text = NSDate().description
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("mtCell", forIndexPath: indexPath) as! MeetingTimeCell
            let meeting = meetings[nRow]
            cell.timeLabel.text = "\(meeting.startTime) - \(meeting.endTime)"
            cell.decLabel.text = meeting.bookBy
            
            return cell
        }

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
