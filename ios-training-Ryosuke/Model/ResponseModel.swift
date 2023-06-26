//
//  ResponseModel.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/23.
//

struct ResponseModel: Codable {
    var maxTemperature: Int
    var date: String
    var minTemperature: Int
    var weather_condition: WeatherCondition
    
    enum CodingKeys: String, CodingKey {
        case maxTemperature = "max_temperature"
        case date
        case minTemperature = "min_temperature"
        case weather_condition
    }
}

enum WeatherCondition: String, Codable {
    case sunny
    case cloudy
    case rainy
}
