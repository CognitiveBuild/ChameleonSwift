//
//  LoginController.swift
//  Chameleon_Native
//
//  Created by Vincent Zhou on 6/14/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginController: UITableViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailField: JiroTextField!
    @IBOutlet weak var pwdField: JiroTextField!
    //192+70+70
    @IBOutlet weak var footView: UIView!
    @IBOutlet weak var headerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        pwdField.delegate = self
        emailField.placeholderColor = .darkGray;
        pwdField.placeholderColor = .darkGray;
        let screenHight = UIScreen.main.bounds.size.height-192-140
        self.footView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width,height: screenHight)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginController.hideKeyboard));
        self.headerView.addGestureRecognizer(tapGesture);
    }
    func hideKeyboard(){
        self.view.endEditing(true);
    }
    @IBAction func loginAction(_ sender: AnyObject) {
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
                        UserDefaults.standard.setValue(p, forKey: "userPassword");
                        self.perform(#selector(gotoHome), with: nil, afterDelay: 3)
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
    func isValidEmail(_ testStr:String?) -> Bool {
        if let s = testStr as String? {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: s)
        }
        return false

    }
    func gotoHome() {
        self.clearAllNotice()
        let homePage = self.storyboard?.instantiateViewController(withIdentifier: "homeNavi")
        self.present(homePage!, animated: true, completion: nil);
        UserDefaults.standard.setValue(emailField.text, forKey: "userEmail")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let email = UserDefaults.standard.string(forKey: "userEmail")
        if let e = email as String? {
            emailField.text = e
            let pwd = UserDefaults.standard.string(forKey: "userPassword")
            pwdField.text = pwd;
            if let p = pwd as String?{
                if p.characters.count > 0 {
                    self.touchidAuth();
                }
            }
        }
    }
    func touchidAuth() {
        let authContext:LAContext = LAContext()
        var error:NSError?
        
        //Is Touch ID hardware available & configured?
        if(authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error:&error)) {
            //Perform Touch ID auth
            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                                       localizedReason: "Authenticate User Touch ID",
                                       reply: { (wasSuccessful, error) in
                                        
                                        if(wasSuccessful) {
                                            //User authenticated
                                            self.writeOutAuthResult(error as NSError?)
                                        }
                                        else {
                                            //There are a few reasons why it can fail, we'll write them out to the user in the label
                                            self.writeOutAuthResult(error as NSError?)
                                        }
            }
            )
        }
        else {
            //Missing the hardware or Touch ID isn't configured
            self.writeOutAuthResult(error)
        }
    }
    func writeOutAuthResult(_ authError:NSError?)
    {
        DispatchQueue.main.async(execute: {() in
            if let possibleError = authError
            {
                print(possibleError);
            }
            else
            {
                print("Authentication Successful!!!")
                self.login()
            }
        })
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        return 2
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField==emailField {
            self.pwdField.becomeFirstResponder()
        }else{
            login()
        }
        return true
    }
    //MARK -POPUP Alert
    func showAlert(_ title:String,msg:String) {
        let alertController = UIAlertController(title: title, message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
