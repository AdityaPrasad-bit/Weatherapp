//
//  ViewController.swift

import UIKit
import CoreLocation

class WeatherViewController: UIViewController,UITextFieldDelegate,WeatherManagerDelegate,CLLocationManagerDelegate {
    
    var cName:String = ""
    @IBOutlet weak var back: UIImageView!
    
    @IBOutlet weak var C: UILabel!
    @IBOutlet weak var degree: UILabel!
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var searchButton: UIButton!
    let locationManager = CLLocationManager()
    
    var weatherManager = WeatherManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        }

    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        
    }
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder="Type here"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let emailRegEx = "[a-zA-Z\\_]{1,18}$"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           
        if emailPred.evaluate(with:searchTextField.text!) {
            if let city = searchTextField.text{
                cName = city
                weatherManager.fetchWeather(cityName: city)
            }
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Please fill correct", preferredStyle: .alert)
            let defaultButton = UIAlertAction(title: "Okay", style: .default)
            alert.addAction(defaultButton)
            self.present(alert,animated: true,completion: nil)
        }
     
        searchTextField.text = ""
    }
    
    func didUpdateWeather(_ weatherManager:WeatherManager,weather: WeatherModel){
        DispatchQueue.main.async{
            print(weather.cityName,"cityName")
            print(self.cName,"Cname")

            if self.cName != weather.cityName{
                let alert = UIAlertController(title: "Error", message: "Please fill correct", preferredStyle: .alert)
                let defaultButton = UIAlertAction(title: "Okay", style: .default)
                alert.addAction(defaultButton)
                self.present(alert,animated: true, completion: nil)
            }
            
            else{
                self.temperatureLabel.text = weather.temperatureString
                self.conditionImageView.image = UIImage(systemName: weather.condtionName)
                self.cityLabel.text = weather.cityName
                self.back.image = UIImage(named: weather.b)
                if (weather.b == "bolt")||(weather.b == "sun"){
                    self.temperatureLabel.textColor = .white
                    self.conditionImageView.tintColor = .white
                    self.cityLabel.textColor = .white
                    self.C.textColor = .white
                    self.degree.textColor = .white
                    self.searchTextField.textColor = .white
                    self.locationButton.tintColor = .white
                    self.searchButton.tintColor = .white
                }
                else{
                    self.temperatureLabel.textColor = .black
                    self.conditionImageView.tintColor = .black
                    self.cityLabel.textColor = .black
                    self.C.textColor = .black
                    self.degree.textColor = .black
                    self.searchTextField.textColor = .black
                    self.locationButton.tintColor = .black
                    self.searchButton.tintColor = .black
                }
            }
            
            
            
           
        }
       
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
           print(lat,long)
            weatherManager.fetchWeather(latitude: lat,longitude: long)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

