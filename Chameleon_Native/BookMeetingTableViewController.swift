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
    let formatter = DateFormatter()

    @IBOutlet weak var bookButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "TodayCell",bundle: nil), forCellReuseIdentifier: "todayCell")
        self.tableView.register(UINib(nibName: "InputCell",bundle: nil), forCellReuseIdentifier: "inputCell")
        self.tableView.register(UINib(nibName: "TimeCell",bundle: nil), forCellReuseIdentifier: "timeCell")
        self.tableView.backgroundColor = UIColor(hexString: "#f0f1f3")
        self.bookButton.layer.cornerRadius = 25
        meeting = Meeting()
        meeting?.bookBy = "Vincent"
        formatter.dateFormat = "HH:mm"
//        formatter.locale = Locale.system
        meeting?.startTime = formatter.string(from: Date())
        meeting?.endTime = formatter.string(from: Date().addingTimeInterval(3600))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func bookAction(_ sender: AnyObject) {
        //
        let s = self.meeting?.startTime
        guard let startDate = formatter.date(from: s!)
            else{
                return
        }
        let e = self.meeting?.endTime
        guard let endDate = formatter.date(from: e!)
            else{
                return
        }
        guard let value = UserDefaults.standard.value(forKey: "userEmail") as? String
            else{
                print("Email is not a string!")
                return
        }
        meeting?.meetingEmail = value
        if startDate.compare(endDate) == .orderedAscending{
            if let vc = self.navigationController?.viewControllers[2] as? MeetingRoomTableViewController {
                vc.meetings.append(self.meeting!)
                for d in DeviceManager.sharedInstance.devices {
                    if d.deviceID == device.deviceID {
                        d.meetings = vc.meetings
                        break
                    }
                }
                let alert = UIAlertController(title: "Success", message: "The meeting room has been booked successfully,", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (alert) in
                    self.navigationController?.popToViewController(vc, animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
                showAlert("Warning", msg: "Not found of Meeting Controller")
            }
        }else{
            showAlert("Warning", msg: "Please input a valid date!")
        }
        
    }
    
    func showAlert(_ title:String,msg:String) {
        let alertController = UIAlertController(title: title, message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return 3
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nSection = indexPath.section
        let nRow = indexPath.row
        if nSection == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as! TodayCell
            let todayFormatter = DateFormatter()
            todayFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            cell.todayLabel.text = todayFormatter.string(from: Date())

            return cell
        }else{
            if nRow == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! InputCell
                cell.meetingTitle.delegate = self
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) as! TimeCell
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
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }else{
            return 20
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let v = UIView()
        v.backgroundColor = UIColor(hexString: "#f0f1f3")
        v.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20)
        return v
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row != 2{
            let cell = tableView.cellForRow(at: indexPath) as! TimeCell
            self.view.endEditing(true)
            if indexPath.row == 0 {
                //Start Date:
                DatePickerDialog().show("Start Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
                    (date) -> Void in
                    let text = self.formatter.string(from: date)

                    cell.timeContent.text = text
                    self.meeting?.startTime = text
                }
            }else{
                //End Date:
                DatePickerDialog().show("End Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
                    (date) -> Void in
                    let text = self.formatter.string(from: date)
                    cell.timeContent.text = text
                    self.meeting?.endTime = text
                }
            }

        }

    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.meeting?.meetingDes = textView.text
        return true
    }
    
}
