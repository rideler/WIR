//
//  location.swift
//  WIT
//
//  Created by Shay Kremer on 2/4/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import Foundation

//holds list of workable locations
class Location{
    private var locations = [[String]]()
    //the list of locations that the api can work with
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
    
    //getting the list of locations in 2D array form
    func getLocations() -> [[String]] {
        return locations
    }
    
    //getting the list of locations in array form, when city and country are in the same cell
    func getStringLocations() -> [String] {
        var list = [String]()
        let numColumns = locations.count-1
        for row in 0...numColumns {
            list.append(locations[row][0]+","+locations[row][1])
        }
        return list
    }
    
    //returning the number of row in the list where the specific locations is
    func searchRow(city:String,country:String) -> Int? {
        for i in (0..<self.locations.count)
        {
            if ((self.locations[i][0] == country) && (self.locations[i][1] == city))
            {
                return i
            }
        }
        return nil
    }
    
    //get the city name by it's row number
    func getCity(row:Int) -> String{
        return locations[row][1]
    }
    
    //get the country name by it's row number
    func getCountry(row:Int) -> String{
        return locations[row][0]
    }
}
