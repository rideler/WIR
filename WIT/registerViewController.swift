//
//  registerViewController.swift
//  WIT
//
//  Created by Shay Kremer on 1/18/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import UIKit
//view for registering new user
class registerViewController: UIViewController {
    
    @IBOutlet weak var errorMsg2: UILabel!
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var usrIN: UITextField!
    @IBOutlet weak var passIN: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //checking if the string given is email
    func isValidEmail(testStr:String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if (testStr == nil){
            return false
        }
        else{
            return emailTest.evaluate(with: testStr)
        }
    }
    //when clicking on the register button, it will
    @IBAction func regBTN(_ sender: UIButton) {
        //dissapearing earlier errors
        self.errorMsg2.isHidden = true
        self.errorMsg.isHidden = true
        //show error for password too short
        if ((self.passIN.text?.characters.count)! < 6){
            self.errorMsg2.text = "Password must be at least 6 characters"
            self.errorMsg2.isHidden = false
        }
        //show error for user name not being email
        if (!(self.isValidEmail(testStr: self.usrIN.text))){
            self.errorMsg.text = "User Name must be email"
            self.errorMsg.isHidden = false
        }
        //showing error if user name already exists
        if ((self.errorMsg2.isHidden) && (self.errorMsg2.isHidden)){
            Model.instance.register(email: usrIN.text!, pwd: passIN.text!){(pass) in
                if (pass){
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.afterLogin()
                    self.errorMsg2.isHidden = true
                }
                else
                {
                    self.errorMsg2.text = "User Name already exists"
                    self.errorMsg2.isHidden = false
                }
            }
        }
    }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
