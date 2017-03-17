//
//  addPostViewController.swift
//  WIT
//
//  Created by Shay Kremer on 1/9/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import UIKit
//this view is responsible for the page for adding post after choosing picture from camera or gallery
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
        gps.addTarget(self, action: #selector(addPostViewController.ChangeText(_:)), for: UIControlEvents.editingChanged)
        
        img.image = postImg
        // Do any additional setup after loading the view.
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //after this page dissapear, the social tab will return to the list and not to add post
    open override func viewDidDisappear(_ animated: Bool) {
        _ = self.navigationController?.popToRootViewController(animated: false)
    }
    //notifying about post added
    @objc func postsListDidUpdate(notification:NSNotification){
        _ = notification.userInfo?["posts"] as! [Post]
    }
    //after clicking on post button, this function is played
    @IBAction func addPost(_ sender: UIBarButtonItem) {
        //getting current time as epoch time for setting post ID
        let pid = String(Int(NSDate().timeIntervalSince1970))
        //saving the post image using model
        Model.instance.saveImage(image: img.image!, name: pid){(url) in
            let ps = Post(id: pid, user: Model.instance.getUserName(), imageUrl: url!, dsc: self.desc.text, locate: self.gps.text!, lastUpdate: nil)
            //adding the post we built in ps
            Model.instance.addPost(ps: ps)
            //returing the navigation of social back to the list of posts
            _ = self.navigationController?.popToRootViewController(animated: false)
            self.tabBarController?.selectedIndex = 3
        }
    }
    //while location is empty, the post button is disabled,this function tracks when text is written
    func textFieldDidBeginEditing(_ textField: UITextField){
        //   saveButton.isEnabled = false
        updateSaveButtonState()
    }
    //while location is empty, the post button is disabled
    private func updateSaveButtonState(){
        let loc = gps.text ?? ""
        postBtn.isEnabled = (loc != "" )
    }
    //enabling return key in keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    //while location is empty, the post button is disabled
    func ChangeText(_ textField: UITextField){
        updateSaveButtonState()
    }
    //restrict the amount of charecters to be written in the description text view
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
            textView.resignFirstResponder()
        }
        return (textView.text.characters.count+(text.characters.count-range.length) <= 100)
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
