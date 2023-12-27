//
//  WeatherViewModel.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/07/24.
//
import Combine
import UIKit

final class WeatherViewModel {
    
    private var weatherModel: WeatherModelProtocol
    @Published var weatherCondition: WeatherCondition?
    @Published var maxTemperature: Int?
    @Published var minTemperature: Int?
    @Published var isError = false

    init(weatherModel: WeatherModelProtocol) {
        self.weatherModel = weatherModel
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
