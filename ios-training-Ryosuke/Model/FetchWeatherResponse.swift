//
//  ResponseModel.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/23.
//
import UIKit

struct FetchWeatherResponse: Decodable {
    let area: String
    let info: WeatherInfo
}

struct WeatherInfo: Decodable {
    let maxTemperature: Int
    let date: String
    let minTemperature: Int
    let weatherCondition: WeatherCondition
    
    enum CodingKeys: String, CodingKey {
        case maxTemperature = "max_temperature"
        case minTemperature = "min_temperature"
        case weatherCondition = "weather_condition"
        case date
    }
}

enum WeatherCondition: String, Decodable {
    case sunny
    case cloudy
    case rainy
}

extension WeatherCondition {
    var color: UIColor {
        switch self {
        case .sunny:
            return .red
        case .cloudy:
            return .gray
        case .rainy: 
            return .blue
        }
    }
}
