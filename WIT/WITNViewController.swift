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
    
    @IBAction func valueChanged(_ sender: UISlider) {
        let currentValue = Int(slider.value)
        sliderValue.text = "\(currentValue)%"
        sliderValue.frame = CGRect(x: Int(141 + 1.7*slider.value), y: 108, width: 49, height: 25)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calender: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: NSDate = NSDate()
        let components: NSDateComponents = NSDateComponents()
        
        let minDate: NSDate = calender.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        components.day = 26
        let maxDate: NSDate = calender.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        self.startDate.minimumDate = minDate as Date
        self.startDate.maximumDate = maxDate as Date
        
        self.endDate.minimumDate = minDate as Date
        self.endDate.maximumDate = maxDate as Date
        
        let currentValue = Int(slider.value)
        sliderValue.text = "\(currentValue)%"
        sliderValue.frame = CGRect(x: Int(141 + 1.7*slider.value), y: 108, width: 49, height: 25)
        // Do any additional setup after loading the view.
    }

    @IBAction func startDateChanged(_ sender: UIDatePicker) {
        let calender: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let components: NSDateComponents = NSDateComponents()
        
        let minDate: NSDate = calender.date(byAdding: components as DateComponents, to: startDate.date as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        self.endDate.minimumDate = minDate as Date
        
        //calculate the number of days
        /*let daysBetween = calender.components(NSCalendar.Unit.day, from: self.startDate.date, to: self.endDate.date, options: NSCalendar.Options.matchStrictly)
        let daysINhours = (daysBetween).day!*24 */

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
