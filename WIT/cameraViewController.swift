//
//  cameraViewController.swift
//  WIT
//
//  Created by Shay Kremer on 1/9/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import UIKit

class cameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let imagePicker = UIImagePickerController()
    var img: UIImage?
    var cncl:Bool?
    
        override func viewDidLoad() {
            super.viewDidLoad()
            imagePicker.delegate = self
            
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.camera) {
                
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                
                self.present(imagePicker, animated: false, completion: nil)
            }
            cncl = true
        }
    
        open override func viewDidAppear(_ animated: Bool) {
            if cncl == true {
                cncl = false
                tabBarController?.selectedIndex = 0
            }
            else {
                 if UIImagePickerController.isSourceTypeAvailable(
                    UIImagePickerControllerSourceType.camera) {
                    
                    imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                    imagePicker.allowsEditing = false
                    
                    self.present(imagePicker, animated: false, completion: nil)
                    cncl = true
                }
            }
        }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }


        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            self.img = info[UIImagePickerControllerOriginalImage] as? UIImage
            self.dismiss(animated: false, completion: nil)
            self.performSegue(withIdentifier: "cameraPost", sender: self)
        }
        
        
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destinationViewController.
            // Pass the selected object to the new view controller.
            if segue.identifier == "cameraPost" {
               if let destinationVC = segue.destination as? addPostViewController {
                    cncl = false
                    destinationVC.postImg = self.img
                }
                
            }
        }
        
        
}
