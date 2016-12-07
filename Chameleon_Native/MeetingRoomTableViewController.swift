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
        //Regist cel
        self.tableView.register(UINib(nibName: "TodayCell",bundle: nil), forCellReuseIdentifier: "todayCell")
        self.tableView.register(UINib(nibName:"MeetingTimeCell",bundle:nil), forCellReuseIdentifier: "mtCell")
        self.tableView.backgroundColor = UIColor(hexString: "#f0f1f3")

        self.title = device.roomName
        let replyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        replyBtn.setImage(UIImage(named: "radar"), for: UIControlState())
        replyBtn.addTarget(self, action: #selector(backToHome), for:  UIControlEvents.touchUpInside)
        let item = UIBarButtonItem(customView: replyBtn)
        self.navigationItem.rightBarButtonItem = item
        self.meetings = device.meetings
        self.bookButton.layer.cornerRadius = 25
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
    }
    func backToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func bookMeetingAction(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "showBookPage", sender: device)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return meetings.count
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "mtCell", for: indexPath) as! MeetingTimeCell
            let meeting = meetings[nRow]
            cell.timeLabel.text = "\(meeting.startTime) - \(meeting.endTime)"
            cell.decLabel.text = meeting.bookBy
            
            return cell
        }

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
        }else{
            let v = UIView()
            v.backgroundColor = UIColor(hexString: "#f0f1f3")
            v.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20)
            return v
        }

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        }else{
            return 60
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BookMeetingTableViewController {
            vc.device = self.device
        }
    }
}
