//
//  WeatherViewControllerUnitTest.swift
//  ios-training-RyosukeTests
//
//  Created by 須崎 良祐 on 2023/12/27.
//

import XCTest
@testable import ios_training_Ryosuke
import UIKit
import Combine

@MainActor
final class WeatherViewControllerUnitTest: XCTestCase {
    var weatherViewController: WeatherViewController!
    let mock = WeatherViewModelMock()

    override func setUpWithError() throws {
        weatherViewController = WeatherViewController.getInstance(weatherViewModel: mock)
        weatherViewController.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        weatherViewController = nil
    }

    func testReload() async throws {
        let expectedWeather: [(condition: WeatherCondition, maxTemperature: Int, minTemperature: Int, isError: Bool)] = [
            (.sunny, 7, 25, false),
            (.cloudy, -8, -1, false),
            (.rainy, -5, 15, false)
        ]

        for weather in expectedWeather {
            var cancellables = Set<AnyCancellable>()

            mock.weatherCondition = weather.condition
            mock.maxTemperature = weather.maxTemperature
            mock.minTemperature = weather.minTemperature
            mock.isError = weather.isError

            weatherViewController.reload(UIButton())

            mock.$weatherCondition
                .dropFirst()
                .sink { receivedCondition in
                    XCTAssertEqual(self.weatherViewController.weatherImage.image, UIImage(named: weather.condition.rawValue))
                }
                .store(in: &cancellables)

            mock.$maxTemperature
                .dropFirst()
                .sink { receivedTemperature in
                    XCTAssertEqual(self.weatherViewController.maxTemperatureLabel.text, String(weather.maxTemperature))
                }
                .store(in: &cancellables)

            mock.$minTemperature
                .dropFirst()
                .sink { receivedTemperature in
                    XCTAssertEqual(self.weatherViewController.minTemperatureLabel.text, String(weather.minTemperature))
                }
                .store(in: &cancellables)
        }
    }
}

final class WeatherViewModelMock: WeatherViewModelProtocol {

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

    func fetchWeatherCondition() async {}
}
