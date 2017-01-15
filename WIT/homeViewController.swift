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
    
    private let openWeatherMapBaseURL = "http://api.wunderground.com/api/59c65dea745e9573/hourly10day/q/"
    
    @IBOutlet weak var lction: UILabel!
    @IBOutlet weak var yesNO: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yesORno(answer: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWeather(country: String, city: String) {
        
        // This is a pretty simple networking task, so the shared session will do.
        let session = URLSession.shared
        
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)\(country)/\(city).json")!
        
        // The data task retrieves the data.
        let dataTask = session.dataTask(with: weatherRequestURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                // Case 1: Error
                // We got some kind of error while trying to get data from the server.
                print("Error:\n\(error)")
            }
            else {
                // Case 2: Success
                // We got a response from the server!
                print("Raw data:\n\(data!)\n")
                let dataString = String(data: data!, encoding: String.Encoding.utf8)
                print("Human-readable data:\n\(dataString!)")
            }
        }
        
        // The data task is set up...launch it!
        dataTask.resume()
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
