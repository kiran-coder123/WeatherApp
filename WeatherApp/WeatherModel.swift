//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Kiran Sonne on 11/10/22.
//

import Foundation

class WeatherModel: NSObject, Codable {
    
    var name: String = ""
    var temp: Double = 0.0
    var humidity: Int = 0
    var windSpeed: Double = 0.0
    
    
    enum codingKeys: String, CodingKey {
        case name
        case main
        case wind
        case humidity
        case temp
        case speed
    }
   
    func encode(to encoder: Encoder) throws {
         
    }
    override init() {
         
    }
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: codingKeys.self)
        
        let main = try container.nestedContainer(keyedBy: codingKeys.self, forKey: .main)
        let wind = try container.nestedContainer(keyedBy: codingKeys.self, forKey: .wind)
        
        name = try container.decode(String.self, forKey: .name)
        temp = try container.decode(Double.self, forKey: .temp)
        humidity = try main.decode(Int.self, forKey: .humidity)
        windSpeed = try wind.decode(Double.self, forKey: .speed)
    }
}
