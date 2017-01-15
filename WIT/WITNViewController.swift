//
//  WITNViewController.swift
//  WIT
//
//  Created by Shay Kremer on 1/9/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import UIKit

class WITNViewController: UIViewController {

    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderValue: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calender: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: NSDate = NSDate()
        let components: NSDateComponents = NSDateComponents()
        
        let minDate: NSDate = calender.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
                
        components.day = 10
        let maxDate: NSDate = calender.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        self.startDate.date = currentDate as Date
        self.endDate.date = currentDate as Date
        
       // let hour = calender.component(NSCalendar.Unit.hour, from: startDate.date)
        
        self.startDate.minimumDate = minDate as Date
        self.startDate.maximumDate = maxDate as Date
        
        self.endDate.minimumDate = minDate as Date
        self.endDate.maximumDate = maxDate as Date
        
        let currentValue = Int(slider.value)
        sliderValue.text = "\(currentValue)%"
        sliderValue.frame = CGRect(x: Int(139 + 1.7*slider.value), y: 91, width: 197, height: 31)
        // Do any additional setup after loading the view.
    }

    @IBAction func DateChanged(_ sender: UIDatePicker) {
     
        let calender: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        self.endDate.minimumDate = self.startDate.date
        
        let hoursBetween = calender.components(NSCalendar.Unit.hour, from: self.startDate.date, to: self.endDate.date, options: NSCalendar.Options.matchStrictly)
        if hoursBetween.hour! < 0 {
            self.endDate.date = self.endDate.minimumDate!
        }

 //       let hour = calender.component(NSCalendar.Unit.hour, from: startDate.date)
        
    }
    
    
    
    @IBAction func valueChanged(_ sender: UISlider) {
        let currentValue = Int(slider.value)
        sliderValue.text = "\(currentValue)%"
        sliderValue.frame = CGRect(x: Int(139 + 1.7*slider.value), y: 91, width: 197, height: 31)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func check(_ sender: UIButton) {
   //     let calender: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        //calculate the number of hours
    //    let hoursBetween = calender.components(NSCalendar.Unit.hour, from: self.startDate.date, to: self.endDate.date, options: NSCalendar.Options.matchStrictly)
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
