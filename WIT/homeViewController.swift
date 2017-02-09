//
//  homeViewController.swift
//  WIT
//
//  Created by Shay Kremer on 1/9/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import UIKit
import Foundation


class homeViewController: UIViewController {
    
    var pop:Int = 0
    var period:Int = 0
    var country:String = ""
    var city:String = ""
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var lction: UILabel!
    @IBOutlet weak var yesNO: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getCalculations()
    }
    
    func yesORno(answer: Bool){
        if answer{
            yesNO.image = #imageLiteral(resourceName: "yes-rain")
        }
        else{
            yesNO.image = #imageLiteral(resourceName: "No")
        }
    }
    
    private func getCalculations(){
        let wit = Weather()
        ModelSettings.instance?.getSettings(){ (settings) in
            self.pop = settings.pop
            self.period = settings.period
            self.country = settings.country
            self.city = settings.city
        }
        
        lction.text = "\(self.country),  \(self.city)"
        let res = wit.getWeather(country: self.country,city: self.city, startTime: Int(NSDate().timeIntervalSince1970), period: self.period , pop: self.pop)
        yesORno(answer: res)
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        yesNO.image = nil
        lction.text = ""
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
