//
//  LoginController.swift
//  Chameleon_Native
//
//  Created by Vincent Zhou on 6/14/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class LoginController: UITableViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailField: JiroTextField!
    @IBOutlet weak var pwdField: JiroTextField!
    //192+70+70
    @IBOutlet weak var footView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        pwdField.delegate = self
        emailField.placeholderColor = .darkGrayColor();
        pwdField.placeholderColor = .darkGrayColor();
//        self.tableView.scrollEnabled = false
        let screenHight = UIScreen.mainScreen().bounds.size.height-192-140
        self.footView.frame = CGRectMake(0, 0, self.tableView.frame.size.width,screenHight)
        
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        login()
    }
    func login(){
        self.view.endEditing(true)
        let email = emailField.text
        if let e = email as String? {
            if e.characters.count > 0 && isValidEmail(e){
                //Email is valid
                //Check password
                let password = pwdField.text
                if let p = password as String? {
                    if p.characters.count > 5 {
                        self.pleaseWait()
                        self.performSelector(#selector(gotoHome), withObject: nil, afterDelay: 3)
                    }else{
                        showAlert("Warning",msg:"Please input a valid password")
                    }
                }else{
                    showAlert("Warning", msg: "Please input a pasword.")
                }
                
            }else{
                showAlert("Warning", msg: "Please input a valid username.")
            }
        }else{
            showAlert("Warning", msg: "Please input a valid username.")
        }
    }
    func isValidEmail(testStr:String?) -> Bool {
        if let s = testStr as String? {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluateWithObject(s)
        }
        return false

    }
    func gotoHome() {
        self.clearAllNotice()
        let homePage = self.storyboard?.instantiateViewControllerWithIdentifier("homeNavi")
//        UIApplication.sharedApplication().keyWindow?.rootViewController = homePage
        self.presentViewController(homePage!, animated: true, completion: nil);
        NSUserDefaults.standardUserDefaults().setValue(emailField.text, forKey: "userEmail")
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField==emailField {
            self.pwdField.becomeFirstResponder()
        }else{
            login()
        }
        return true
    }
    //MARK -POPUP Alert
    func showAlert(title:String,msg:String) {
        let alertController = UIAlertController(title: title, message:
            msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
