//
//  location.swift
//  WIT
//
//  Created by Shay Kremer on 2/4/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import Foundation
class Location{
    private var locations = [[String]]()
    
    init() {
        locations.append(["israel"])
        locations[0].append("Jerusalem")
        
        locations.append(["Germany"])
        locations[1].append( "Berlin")
        
        locations.append(["USA"])
        locations[2].append("New-York")
        
        locations.append(["UK"])
        locations[3].append("London")
        
        locations.append(["France"])
        locations[4].append("Paris")
        
        locations.append(["Australia"])
        locations[5].append("Melbourne")
        
        locations.append(["Nigeria"])
        locations[6].append("Lagos")
        
        locations.append(["China"])
        locations[7].append("Beijing")
        
        locations.append(["Japan"])
        locations[8].append("Tokyo")
        
        locations.append(["Brazil"])
        locations[9].append("Brasilia")
    }
    
    func getLocations() -> [[String]] {
        return locations
    }
    
    func getStringLocations() -> [String] {
        var list = [String]()
        let numColumns = locations.count-1
        for row in 0...numColumns {
            list.append(locations[row][0]+", "+locations[row][1])
        }
        return list
    }
    
    func getCity(row:Int) -> String{
        print("city \(locations[row][1])")
        return locations[row][1]
    }
    
    func getCountry(row:Int) -> String{
        print("Country \(locations[row][0])")
        return locations[row][0]
    }
}
