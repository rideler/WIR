//
//  homeViewController.swift
//  WIT
//
//  Created by Shay Kremer on 1/9/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import UIKit
import Foundation

//the first page the logged user sees
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
    //getting answer from Model using settings parameters, and changing answer picture after apperaing
    override func viewDidAppear(_ animated: Bool) {
        getCalculations()
    }
    //setting pic according to answer if it's going to rain
    func yesORno(answer: Bool){
        if answer{
            yesNO.image = #imageLiteral(resourceName: "yes-rain")
        }
        else{
            yesNO.image = #imageLiteral(resourceName: "No")
        }
    }
    //getting answer from Model using settings parameters, and changing answer picture
    private func getCalculations(){
        Model.instance.getSettings(){ (settings) in
            self.pop = settings.pop
            self.period = settings.period
            self.country = settings.country
            self.city = settings.city
        }
        
        lction.text = "\(self.country),  \(self.city)"
        let res = Model.instance.getWeather(country: self.country,city: self.city, startTime: Int(NSDate().timeIntervalSince1970), period: self.period , pop: self.pop)
        yesORno(answer: res)
        //stoping spinner when work is done
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
    }
    //deleting values for parameters and running spinner
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
