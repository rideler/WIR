//
//  settingsViewController.swift
//  WIT
//
//  Created by Shay Kremer on 1/15/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource{

    var pop:Int = 0
    var period:Int = 0
    var country:String = ""
    var city:String = ""
    
    var list = [String]()
    
    @IBOutlet weak var rainSlider: UISlider!
    @IBOutlet weak var periodSlider: UISlider!
    @IBOutlet weak var periodValue: UILabel!
    @IBOutlet weak var rainValue: UILabel!
    @IBOutlet weak var dataPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lctn = Location()
        self.list = lctn.getStringLocations()
        self.dataPicker.delegate = self
        
        ModelSettings.instance?.getSettings(){ (settings) in
            self.pop = settings.pop
            self.period = settings.period
            self.country = settings.country
            self.city = settings.city
        }
        
        self.dataPicker.selectRow(lctn.searchRow(city: self.city, country: self.country)!, inComponent: 0, animated: false)

        rainSlider.value = Float(self.pop)
        periodSlider.value = Float(self.period)
        var currentValue = Int(rainSlider.value)
        rainValue.text = "\(currentValue)%"
        currentValue = Int(periodSlider.value)
        periodValue.text = "\(currentValue)"
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
        print("\(list[row])")
        self.country = Location().getCountry(row: row)
        self.city = Location().getCity(row: row)
        //save location to db
        ModelSettings.instance?.changeSettings(stings: Settings(pop: self.pop, period: self.period, city: self.city, country: self.country))
    }
    
    
    @IBAction func rainChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        rainValue.text = "\(currentValue)%"
        self.pop = currentValue
        
        ModelSettings.instance?.changeSettings(stings: Settings(pop: self.pop, period: self.period, city: self.city, country: self.country))
    }
    
    @IBAction func periodChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        periodValue.text = "\(currentValue)"
        self.period = currentValue
        
        ModelSettings.instance?.changeSettings(stings: Settings(pop: self.pop, period: self.period, city: self.city, country: self.country))
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
