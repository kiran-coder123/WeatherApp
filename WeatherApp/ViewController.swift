//
//  ViewController.swift
//  WeatherApp
//
//  Created by Kiran Sonne on 10/10/22.
//

import UIKit
import Alamofire
import CoreLocation
import SwiftyJSON


class ViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempteratureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }
    
    //MARK: get Weather data  using Codeble
    
    func parseJSONWithCodable(data: Data) {
    
        do {
          
            let weatherObject = try JSONDecoder().decode(WeatherModel.self, from: data)
            humidityLabel.text = "\(weatherObject.humidity)"
            cityNameLabel.text = weatherObject.name
            tempteratureLabel.text = "\(Int(weatherObject.temp))"
            windSpeedLabel.text = "\(weatherObject.windSpeed)"
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
    }
    
    //MARK: get Weather data  using SwiftyJSON
    
    
    func parseJSONWithSwifty(data: [String:Any]) {
        
        let jsonData = JSON(data)
        if let humidity = jsonData["main"]["humidity"].int {
            humidityLabel.text = "\(humidity)"
        }
        if let temperature = jsonData["main"]["temp"].double {
            tempteratureLabel.text = "\(Int(temperature))"
        }
        if let windSpeed = jsonData["wind"]["speed"].double {
            windSpeedLabel.text = "\(windSpeed)"
        }
        if let name = jsonData["name"].string {
            cityNameLabel.text = name
        }
        
        
    }
    
    //MARK: get Weather data  using Alamofire
    
    func getWeatherDataWithAlamofire(latitude: String, longitude: String){
        
        guard let url = URL(string: APIClient.shared.getWeatherDataUrl(latitude: latitude, longitude: longitude)) else {
            print("could not form url")
            return
        }
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let value):
                print(String(data: value, encoding: .utf8)!)
                let jsonData = JSON(value)
                
                guard let data = response.data else { return }
                DispatchQueue.main.async {
                   // call codable method
                    self.parseJSONWithCodable(data: data)
                
                    // call swiftyjson method
                    self.parseJSONWithSwifty(data: jsonData.rawValue as! [String : Any])
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    //MARK: get Weather data  using JSONSerialization
    func getWeatherData(latitude: String, longitude: String){
        guard let weatherUrl = URL(string: APIClient.shared.getWeatherDataUrl(latitude: latitude, longitude: longitude)) else { return }
        URLSession.shared.dataTask(with: weatherUrl) { data, response, error in
            
            //handle protential error
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            
            // make a data nil optional
            guard let data = data else { return }
            
            
            do {
                
                guard let weatherData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                    print("there was an error converting data into JSON")
                    return
                }
                print(weatherData)
            } catch   {
                print("error converting data into JSON")
            }
            
        }.resume()
    }
    
    
    
}
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            print(latitude)
            print(longitude)
            // getWeatherData(latitude: latitude, longitude: longitude)
            getWeatherDataWithAlamofire(latitude: latitude, longitude: longitude)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways,.authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Access Disabled", message: "Weather app need to you location to give a weather forecast. open your setting to chaneg authorization.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (Action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open", style: .default) { (action) in
                if let url = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                }
            }
            alert.addAction(openAction)
            present(alert, animated: true, completion: nil)
            break
            
        }
        
    }
}
