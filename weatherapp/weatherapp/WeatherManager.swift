//
//  WeatherManager.swift
//  weatherapp
//
//  Created by Aditya on 17/08/21.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager,weather: WeatherModel)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=d5e480a200bed4068980714d5fb4be03&units=metric"
    
    var delegate:WeatherManagerDelegate?
    
    func fetchWeather(cityName:String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees,longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String){
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response,error ) in
                if error != nil{
                    print(error!)
                }
                if let safeData = data{
//                    let dataString = String(data: safeData, encoding: .utf8)
//                    print(dataString!)
                    let weather = self.ParseJSON(weatherData: safeData)
                    self.delegate?.didUpdateWeather(self,weather: weather!)
                }
            }
            
            task.resume()
        }
    }
    func ParseJSON(weatherData: Data)-> WeatherModel?{
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.weather[0].id)
            let name = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
       
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather

        }
        catch{
            print(error)
            return nil
        }
    }
    
    
}
