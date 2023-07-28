//
//  WeatherViewModel.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/07/24.
//
import UIKit
final class WeatherViewModel {
    
    private var weatherModel: WeatherModelProtocol
    var weatherCondition: WeatherCondition
    var maxTemperature: Int
    var minTemperature: Int
    var isError: Bool
    
    init(weatherModel: WeatherModelProtocol) {
        self.weatherModel = weatherModel
        self.weatherCondition = .sunny
        self.maxTemperature = 0
        self.minTemperature = 0
        self.isError = false
    }
    
    func fetchWeatherCondition() async {
        do {
            let response = try await weatherModel.fetchWeatherCondition()
            weatherCondition = response.weatherCondition
            maxTemperature = response.maxTemperature
            minTemperature = response.minTemperature
            isError = false
        } catch {
            isError = true
        }
    }
}
