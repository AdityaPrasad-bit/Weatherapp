//
//  WeatherData.swift
//  weatherapp
//
//  Created by Aditya on 17/08/21.
//

import Foundation

struct WeatherData:Codable {
    let name:String
    var weather = [Weather]()
    let main:Main
}

struct Weather: Codable {
    let id:Int
}
struct Main:Codable{
    let temp:Double
}
