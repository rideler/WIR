//
//  addPostViewController.swift
//  WIT
//
//  Created by Shay Kremer on 1/9/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import UIKit

class addPostViewController: UIViewController, UINavigationControllerDelegate,UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var postBtn: UIBarButtonItem!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var gps: UITextField!
    
    var postImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
        desc.delegate = self
        gps.delegate = self
        // Do any additional setup after loading the view.
        gps.addTarget(self, action: #selector(addPostViewController.textFieldDidChangeText(_:)), for: UIControlEvents.editingChanged)
        
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
    
    @objc func postsListDidUpdate(notification:NSNotification){
        _ = notification.userInfo?["posts"] as! [Post]
    }
    
    @IBAction func addPost(_ sender: UIBarButtonItem) {
        let pid = String(Int(NSDate().timeIntervalSince1970))
            Model.instance.saveImage(image: img.image!, name: pid){(url) in
                let ps = Post(id: pid, user: Model.instance.getUserName(), imageUrl: url!, dsc: self.desc.text, locate: self.gps.text!, lastUpdate: nil)
                Model.instance.addPost(ps: ps)
                _ = self.navigationController?.popToRootViewController(animated: false)
                self.tabBarController?.selectedIndex = 3
                
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        //   saveButton.isEnabled = false
        updateSaveButtonState()
    }
    
    private func updateSaveButtonState(){
        let loc = gps.text ?? ""
        postBtn.isEnabled = (loc != "" )
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeText(_ textField: UITextField){
        updateSaveButtonState()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
            textView.resignFirstResponder()
        }
        return true
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
