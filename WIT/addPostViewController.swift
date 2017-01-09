//
//  addPostViewController.swift
//  WIT
//
//  Created by Shay Kremer on 1/9/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import UIKit

class addPostViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var gps: UITextField!
    
    var postImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
        img.image = postImg
        // Do any additional setup after loading the view.
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        _ = self.navigationController?.popToRootViewController(animated: false)
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
