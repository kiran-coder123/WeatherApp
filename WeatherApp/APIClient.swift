//
//  APIClient.swift
//  WeatherApp
//
//  Created by Kiran Sonne on 10/10/22.
//

import Foundation
class APIClient {
    
    static let shared: APIClient = APIClient()
    
      let baseUrl: String = "https://api.openweathermap.org/data/2.5/weather"
    
      let apiKey = "ef2b67292374e79e3ec96f6710e2f54f"
    
    func getWeatherDataUrl(latitude: String, longitude: String) -> String {
    return "\(baseUrl)?lat=\(latitude)&lon=\(longitude)&APPID=\(apiKey)"
    }
}

