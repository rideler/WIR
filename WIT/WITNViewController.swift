//
//  WITNViewController.swift
//  WIT
//
//  Created by Shay Kremer on 1/9/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import UIKit
//view for checking if it's going to rain with specific parmaters
class WITNViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {

    var list = [String]()
    var lctionRow:Int = 0
    
    @IBOutlet weak var lctions: UIPickerView!
    @IBOutlet weak var periodSlider: UISlider!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderValue: UILabel!
    @IBOutlet weak var switchEnable: UISwitch!
    @IBOutlet weak var wirPic: UIImageView!
    @IBOutlet weak var periodValue: UILabel!
    
    //when loading, getting list of locations to show and enabling the default buttons
    //also setting the dates to default
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.list = Model.instance.getStringLocations()
        self.lctions.delegate = self
        
        periodSlider.isEnabled = true
        startDate.isEnabled = false
        endDate.isEnabled = false
        switchEnable.isOn = false
        
        let calender: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: NSDate = NSDate()
        let components: NSDateComponents = NSDateComponents()
        
        let minDate: NSDate = calender.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
                
        components.day = 10
        let maxDate: NSDate = calender.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        self.startDate.date = currentDate as Date
        self.endDate.date = currentDate as Date
        
        self.startDate.minimumDate = minDate as Date
        self.startDate.maximumDate = maxDate as Date
        
        self.endDate.minimumDate = minDate as Date
        self.endDate.maximumDate = maxDate as Date
        
        var currentValue = Int(slider.value)
        sliderValue.text = "\(currentValue)%"
        
        currentValue = Int(periodSlider.value)
        periodValue.text = "\(currentValue)"
        // Do any additional setup after loading the view.
    }
    //updating the dates for upper and lower limit
    @IBAction func DateChanged(_ sender: UIDatePicker) {
        wirPic.image = nil
     
        let calender: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        self.endDate.minimumDate = self.startDate.date
        
        let hoursBetween = calender.components(NSCalendar.Unit.hour, from: self.startDate.date, to: self.endDate.date, options: NSCalendar.Options.matchStrictly)
        if hoursBetween.hour! < 0 {
            self.endDate.date = self.endDate.minimumDate!
        }
    }
    //showing the current value of the period slider
    @IBAction func periodChanged(_ sender: UISlider) {
        wirPic.image = nil
        let currentValue = Int(periodSlider.value)
        periodValue.text = "\(currentValue)"
    }
    
    //showing the current value of the pop slider
    @IBAction func valueChanged(_ sender: UISlider) {
        wirPic.image = nil
        let currentValue = Int(slider.value)
        sliderValue.text = "\(currentValue)%"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //sending the parameters to Model to check if it's going to rain
    @IBAction func check(_ sender: UIButton) {
        
        let calender = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let pop = slider.value
        
        if (self.switchEnable.isOn){
            var startDay = calender.components([.year, .month, .day, .hour], from: self.startDate.date)
            startDay.hour = 0
            let startEpoch = Int(calender.date(from: startDay)!.timeIntervalSince1970)
            
            let hoursBetween = calender.components(NSCalendar.Unit.hour, from: self.startDate.date, to: self.endDate.date, options: NSCalendar.Options.matchStrictly)
            let res = Model.instance.getWeather(country: Model.instance.getCountry(row: lctionRow),city: Model.instance.getCity(row: lctionRow), startTime: startEpoch, period: Int((hoursBetween.hour?.toIntMax())! + 24), pop: Int(pop))
            yesORno(answer: res)
            
        }
        else{
            let res = Model.instance.getWeather(country: Model.instance.getCountry(row: lctionRow),city: Model.instance.getCity(row: lctionRow), startTime: Int(NSDate().timeIntervalSince1970), period: Int(self.periodSlider.value) , pop: Int(pop))
            yesORno(answer: res)
        }
    }
    //enabling the dates or the period slider
    @IBAction func switchChange(_ sender: UISwitch) {
        if (sender.isOn){
            self.periodSlider.isEnabled = false
            self.startDate.isEnabled = true
            self.endDate.isEnabled = true
        }
        else{
            self.periodSlider.isEnabled = true
            self.startDate.isEnabled = false
            self.endDate.isEnabled = false
        }
    }
    //showing the answer in picture if it's going to rain
    func yesORno(answer: Bool){
        if answer{
            wirPic.image = #imageLiteral(resourceName: "yes-rain")
        }
        else{
            wirPic.image = #imageLiteral(resourceName: "No")
        }
    }
    
    //returning number of components in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //returning number of items in picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    //returing the chosen item
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return list[row]
    }
    //changing the row number selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        wirPic.image = nil
        self.lctionRow = row
        //save location to db
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
