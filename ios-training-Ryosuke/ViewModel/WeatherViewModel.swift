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

    var weatherConditionPublisher: AnyPublisher<WeatherCondition?, Never> { get }
    var maxTemperaturePublisher: AnyPublisher<Int?, Never> { get }
    var minTemperaturePublisher: AnyPublisher<Int?, Never> { get }
    var isErrorPublisher: AnyPublisher<Bool, Never> { get }

    func fetchWeatherCondition() async
}

final class WeatherViewModel: WeatherViewModelProtocol {

    var weatherModel: WeatherModelProtocol

    @Published var weatherCondition: WeatherCondition?
    @Published var maxTemperature: Int?
    @Published var minTemperature: Int?
    @Published var isError = false

    var weatherConditionPublisher: AnyPublisher<WeatherCondition?, Never> {
        $weatherCondition.eraseToAnyPublisher()
    }
    var maxTemperaturePublisher: AnyPublisher<Int?, Never> {
        $maxTemperature.eraseToAnyPublisher()
    }
    var minTemperaturePublisher: AnyPublisher<Int?, Never> {
        $minTemperature.eraseToAnyPublisher()
    }
    var isErrorPublisher: AnyPublisher<Bool, Never> {
        $isError.eraseToAnyPublisher()
    }

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
