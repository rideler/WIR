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
        
    @IBOutlet weak var lction: UILabel!
    @IBOutlet weak var yesNO: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let wit = Weather()
        let res = wit.getWeather(country: "israel",city: "Jerusalem", startTime: 1485277200, period: 200 , pop: 99)
        yesORno(answer: res)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func yesORno(answer: Bool){
        if answer{
            yesNO.image = #imageLiteral(resourceName: "yes-rain")
        }
        else{
            yesNO.image = #imageLiteral(resourceName: "No")
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
