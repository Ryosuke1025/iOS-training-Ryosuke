//
//  ResponseModel.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/23.
//

struct ResponnseModel: Codable {
    var max_temperature: Int
    var date: String
    var min_temperature: Int
    var weather_condition: String
}
