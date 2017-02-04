//
//  Weather.swift
//  WIT
//
//  Created by Shay Kremer on 1/24/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import Foundation

class Weather {
    private let openWeatherMapBaseURL = "https://api.wunderground.com/api/59c65dea745e9573/hourly10day/q/"
    private var popIndex = 0
    private var epoIndex = 0

    func getWeather(country: String, city: String, startTime: Int, period: Int, pop: Int) -> Bool {
        
        print("epoch: \(startTime) period \(period)")
        // This is a pretty simple networking task, so the shared session will do.
        let session = URLSession.shared
        var res:Bool? = nil
        var cnt = period
        
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
              //  let dataString = String(data: data!, encoding: String.Encoding.utf8)
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any] {
                    if let array = json["hourly_forecast"] as? [Any] {
                        var temp = "\(array[0])".components(separatedBy: ";")
                        for _ in temp {
                            let temp2 = temp[self.popIndex].components(separatedBy: "=")
                            if (temp2[0].lowercased().range(of: "pop") != nil) {
                                
                                break
                            }
                            self.popIndex += 1
                        }
                        for _ in temp {
                            let temp2 = temp[self.epoIndex].components(separatedBy: "=")
                            if (temp2[0].lowercased().range(of: "epoch") != nil) {
                                break
                            }
                            self.epoIndex += 1
                        }

                        for obj in array {
                            if (cnt == 0) {
                                break
                            }
                            temp = "\(obj)".components(separatedBy: ";")
                            let tempEpo = temp[self.epoIndex].components(separatedBy: "=")
                            if let intVersion = Int(tempEpo[1].trimmingCharacters(in: .whitespacesAndNewlines)){
                                if (intVersion >= startTime) {
                                    let tempPop = temp[self.popIndex].components(separatedBy: "=")
                                    cnt -= 1
                                    if (tempPop[0].lowercased().range(of: "pop") != nil) {
                                        if let intPop = Int(tempPop[1].trimmingCharacters(in: .whitespacesAndNewlines)){
                                            if intPop >= pop {
                                                res = true
                                                print("pop \(intPop) index \(cnt)")
                                                break
                                                
                                            }
                                        }

                                    }

                                }
                            }
                            
                        }
                        
                    }
                    
                }
            }
            if (res == nil){
                res = false
            }
        }
        // The data task is set up...launch it!
        dataTask.resume()
        while (res == nil){}
        print ("\(res)")
        return res!
    }
    
}
