//
//  settingsViewController.swift
//  WIT
//
//  Created by Shay Kremer on 1/15/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{

    var list = ["1", "2", "3", "4", "5"]
    
    @IBOutlet weak var dataPicker: UIPickerView!
    @IBOutlet weak var pick: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataPicker.delegate = self
        self.pick.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pick.text = self.list[row]
        self.dataPicker.isHidden = true
        self.pick.isHidden = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.pick {
            self.pick.isHidden = true
            self.dataPicker.isHidden = false
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
