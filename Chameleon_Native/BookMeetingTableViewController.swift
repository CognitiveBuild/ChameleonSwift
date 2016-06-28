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
    @IBOutlet weak var bookButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "TodayCell",bundle: nil), forCellReuseIdentifier: "todayCell")
        self.tableView.registerNib(UINib(nibName: "InputCell",bundle: nil), forCellReuseIdentifier: "inputCell")
        self.tableView.registerNib(UINib(nibName: "TimeCell",bundle: nil), forCellReuseIdentifier: "timeCell")
        self.tableView.backgroundColor = UIColor(hexString: "#f0f1f3")
        self.bookButton.layer.cornerRadius = 25
        meeting = Meeting()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func bookAction(sender: AnyObject) {
        //
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
            cell.todayLabel.text = NSDate().description
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
                    
                }else{
                    cell.timeTitle.text = "End Time:"
                    
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
            let formatter = NSDateFormatter()
            formatter.dateFormat = "hh:mm a"
            formatter.locale = NSLocale.systemLocale()
            
            if indexPath.row == 1 {
                //Start Date:

                DatePickerDialog().show("Start Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .DateAndTime) {
                    (date) -> Void in
                    let text = formatter.stringFromDate(date)

                    cell.timeContent.text = text
                    self.meeting?.startTime = text
                }
            }else{
                //End Date:
                DatePickerDialog().show("End Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .DateAndTime) {
                    (date) -> Void in
                    let text = formatter.stringFromDate(date)
                    cell.timeContent.text = text
                    self.meeting?.endTime = text
                }
            }

        }

    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        self.meeting?.meetingTitle = textView.text
        return true
    }
    
}
