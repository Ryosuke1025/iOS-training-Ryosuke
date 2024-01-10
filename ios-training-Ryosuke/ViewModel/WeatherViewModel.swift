//
//  WeatherViewModel.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/07/24.
//
import Combine
import UIKit

protocol WeatherViewModelProtocol {
    var weatherModel: WeatherModelProtocol {get}
    
    var weatherCondition: WeatherCondition? {get}
    var maxTemperature: Int? {get}
    var minTemperature: Int? {get}
    var isError: Bool {get}

    var weatherConditionPublisher: Published<WeatherCondition?>.Publisher { get }
    var maxTemperaturePublisher: Published<Int?>.Publisher { get }
    var minTemperaturePublisher: Published<Int?>.Publisher { get }
    var isErrorPublisher: Published<Bool>.Publisher { get }

    func fetchWeatherCondition() async
}

final class WeatherViewModel: WeatherViewModelProtocol {

    var weatherModel: WeatherModelProtocol

    @Published var weatherCondition: WeatherCondition?
    @Published var maxTemperature: Int?
    @Published var minTemperature: Int?
    @Published var isError = false

    var weatherConditionPublisher: Published<WeatherCondition?>.Publisher { $weatherCondition }
    var maxTemperaturePublisher: Published<Int?>.Publisher { $maxTemperature }
    var minTemperaturePublisher: Published<Int?>.Publisher { $minTemperature }
    var isErrorPublisher: Published<Bool>.Publisher { $isError }

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
