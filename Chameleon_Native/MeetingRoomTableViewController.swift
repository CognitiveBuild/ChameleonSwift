//
//  MeetingRoomTableViewController.swift
//  Chameleon_Native
//
//  Created by Vincent Zhou on 6/24/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class MeetingRoomTableViewController: UITableViewController {

    @IBOutlet weak var bookButton: UIButton!
    var device = Device()
    var meetings = [Meeting]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Regist cell
        self.tableView.registerNib(UINib(nibName: "TodayCell",bundle: nil), forCellReuseIdentifier: "todayCell")
        self.tableView.registerNib(UINib(nibName:"MeetingTimeCell",bundle:nil), forCellReuseIdentifier: "mtCell")
        self.tableView.backgroundColor = UIColor(hexString: "#f0f1f3")

        self.title = device.roomName
        let replyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        replyBtn.setImage(UIImage(named: "radar"), forState: UIControlState.Normal)
        replyBtn.addTarget(self, action: #selector(backToHome), forControlEvents:  UIControlEvents.TouchUpInside)
        let item = UIBarButtonItem(customView: replyBtn)
        self.navigationItem.rightBarButtonItem = item
        self.meetings = device.meetings
        self.bookButton.layer.cornerRadius = 25
    }
    
    func backToHome() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    @IBAction func bookMeetingAction(sender: AnyObject) {
        self.performSegueWithIdentifier("showBookPage", sender: device)
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
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }else{
            let v = UIView()
            v.backgroundColor = UIColor(hexString: "#f0f1f3")
            v.frame = CGRectMake(0, 0, tableView.frame.size.width, 20)
            return v
        }

    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        }else{
            return 60
        }
    }
}
