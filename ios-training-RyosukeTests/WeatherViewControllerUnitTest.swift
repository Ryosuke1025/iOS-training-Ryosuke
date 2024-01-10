//
//  WeatherViewControllerUnitTest.swift
//  ios-training-RyosukeTests
//
//  Created by 須崎 良祐 on 2023/12/27.
//

import XCTest
@testable import ios_training_Ryosuke

final class WeatherViewControllerUnitTest: XCTestCase {
    
    var weatherViewController: WeatherViewController!
    let mock = WeatherViewModelMock(weatherModel: WeatherModelMock())
    
    override func setUpWithError() throws {
        weatherViewController = WeatherViewController.getInstance(weatherViewModel: mock)
    }

    override func tearDownWithError() throws {
        weatherViewController = nil
    }

    func testReload() async throws {
        let expectedWeather: [(condition: WeatherCondition, maxTemperature: Int, minTemperature: Int)] = [
            (.sunny, 7, 25),
            (.cloudy, 5, 20),
            (.rainy, 0, 15)
        ]

        for weather in expectedWeather {
            mock.weatherCondition = weather.condition
            mock.maxTemperature = weather.maxTemperature
            mock.minTemperature = weather.minTemperature

            await weatherViewController.reload(UIButton())

        }
    }
}

class WeatherViewModelMock: WeatherViewModelProtocol {

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
