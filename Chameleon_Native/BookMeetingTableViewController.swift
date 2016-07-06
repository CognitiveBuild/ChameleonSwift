//
//  BookMeetingTableViewController.swift
//  Chameleon_Native
//
//  Created by Vincent Zhou on 6/25/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class BookMeetingTableViewController: UITableViewController,UITextViewDelegate {
    var device = Device()
    var meeting:Meeting?
    let formatter = NSDateFormatter()

    @IBOutlet weak var bookButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "TodayCell",bundle: nil), forCellReuseIdentifier: "todayCell")
        self.tableView.registerNib(UINib(nibName: "InputCell",bundle: nil), forCellReuseIdentifier: "inputCell")
        self.tableView.registerNib(UINib(nibName: "TimeCell",bundle: nil), forCellReuseIdentifier: "timeCell")
        self.tableView.backgroundColor = UIColor(hexString: "#f0f1f3")
        self.bookButton.layer.cornerRadius = 25
        meeting = Meeting()
        meeting?.bookBy = "Vincent"
        formatter.dateFormat = "HH:mm"
        formatter.locale = NSLocale.systemLocale()
        meeting?.startTime = formatter.stringFromDate(NSDate())
        meeting?.endTime = formatter.stringFromDate(NSDate().dateByAddingTimeInterval(3600))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func bookAction(sender: AnyObject) {
        //
        let s = self.meeting?.startTime
        guard let startDate = formatter.dateFromString(s!)
            else{
                return
        }
        let e = self.meeting?.endTime
        guard let endDate = formatter.dateFromString(e!)
            else{
                return
        }
        guard let value = NSUserDefaults.standardUserDefaults().valueForKey("userEmail") as? String
            else{
                print("Email is not a string!")
                return
        }
        meeting?.meetingEmail = value
        if startDate.compare(endDate) == .OrderedAscending{
            if let vc = self.navigationController?.viewControllers[2] as? MeetingRoomTableViewController {
                vc.meetings.append(self.meeting!)
                for d in DeviceManager.sharedInstance.devices {
                    if d.deviceID == device.deviceID {
                        d.meetings = vc.meetings
                        break
                    }
                }
                let alert = UIAlertController(title: "Success", message: "The meeting room has been booked successfully,", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: { (let alert) in
                    self.navigationController?.popToViewController(vc, animated: true)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                showAlert("Warning", msg: "Not found of Meeting Controller")
            }
        }else{
            showAlert("Warning", msg: "Please input a valid date!")
        }
        
    }
    
    func showAlert(title:String,msg:String) {
        let alertController = UIAlertController(title: title, message:
            msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return 3
        }
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let nSection = indexPath.section
        let nRow = indexPath.row
        if nSection == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("todayCell", forIndexPath: indexPath) as! TodayCell
            let todayFormatter = NSDateFormatter()
            todayFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            cell.todayLabel.text = todayFormatter.stringFromDate(NSDate())

            return cell
        }else{
            if nRow == 2{
                let cell = tableView.dequeueReusableCellWithIdentifier("inputCell", forIndexPath: indexPath) as! InputCell
                cell.meetingTitle.delegate = self
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("timeCell", forIndexPath: indexPath) as! TimeCell
                if nRow == 0 {
                    cell.timeTitle.text = "Start Time:"
                    cell.timeContent.text = meeting?.startTime
                }else{
                    cell.timeTitle.text = "End Time:"
                    cell.timeContent.text = meeting?.endTime
                }
                return cell
            }
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        }else if indexPath.section == 1 {
            if indexPath.row == 2 {
                return 120
            }else{
                return 60
            }
        }
        return 60
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }else{
            return 20
        }
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let v = UIView()
        v.backgroundColor = UIColor(hexString: "#f0f1f3")
        v.frame = CGRectMake(0, 0, tableView.frame.size.width, 20)
        return v
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row != 2{
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! TimeCell
            self.view.endEditing(true)
            if indexPath.row == 0 {
                //Start Date:
                DatePickerDialog().show("Start Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Time) {
                    (date) -> Void in
                    let text = self.formatter.stringFromDate(date)

                    cell.timeContent.text = text
                    self.meeting?.startTime = text
                }
            }else{
                //End Date:
                DatePickerDialog().show("End Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Time) {
                    (date) -> Void in
                    let text = self.formatter.stringFromDate(date)
                    cell.timeContent.text = text
                    self.meeting?.endTime = text
                }
            }

        }

    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        self.meeting?.meetingDes = textView.text
        return true
    }
    
}
