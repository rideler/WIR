//
//  ViewController.swift
//  WIT
//
//  Created by Shay Kremer on 1/7/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {
    
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var userIN: UITextField!
    @IBOutlet weak var passIN: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logBTN(_ sender: UIButton) {
        Model.instance.login(email: userIN.text!, pwd: passIN.text!){(pass) in
            if (pass){
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.afterLogin()
                self.errorMsg.isHidden = true
            }
            else
            {
                self.errorMsg.isHidden = false
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

