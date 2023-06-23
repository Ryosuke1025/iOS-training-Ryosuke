//
//  ResponseModel.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/23.
//

struct ResponnseModel: Codable {
    var maxTemperature: Int
    var date: String
    var minTemperature: Int
    var weather_condition: String
    
    enum CodingKeys: String, CodingKey {
        case maxTemperature = "max_temperature"
        case date
        case minTemperature = "min_temperature"
        case weather_condition
    }
}
