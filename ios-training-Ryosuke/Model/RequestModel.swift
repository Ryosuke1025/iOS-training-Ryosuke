//
//  RequestModel.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/23.
//

struct FetchWeatherRequest: Codable, Equatable {
    let area: String
    let date: String
}
