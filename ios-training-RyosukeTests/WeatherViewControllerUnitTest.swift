//
//  ios_training_RyosukeTests.swift
//  ios-training-RyosukeTests
//
//  Created by 須崎 良祐 on 2023/07/03.
//

import XCTest
@testable import ios_training_Ryosuke
import Combine

@MainActor
final class WeatherViewControllerUnitTest: XCTestCase {
    
    var weatherViewController: WeatherViewController!
    var weatherViewModel: WeatherViewModel!
    let mock = WeatherModelMock()

    override func setUpWithError() throws {
        weatherViewModel = WeatherViewModel(weatherModel: mock)
        weatherViewController = WeatherViewController.getInstance(weatherViewModel: weatherViewModel)
        weatherViewController.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        weatherViewController  = nil
    }
    
    func testReload() async throws {
        let expectedWeather: [(condition: WeatherCondition, maxTemp: Int, minTemp: Int)] = [
            (.sunny, 7, 25),
            (.cloudy, 5, 20),
            (.rainy, 0, 15)
        ]
        
        for weather in expectedWeather {
            mock.weatherCondition = weather.condition
            mock.maxTemp = weather.maxTemp
            mock.minTemp = weather.minTemp
            
            let expectation = XCTestExpectation(description: "Weather data updated for \(weather.condition)")

            var cancellables = Set<AnyCancellable>()

            await weatherViewModel.fetchWeatherCondition()

            weatherViewModel.$weatherCondition
                .sink { receivedCondition in
                    XCTAssertEqual(receivedCondition, weather.condition)
                    expectation.fulfill()
                }
                .store(in: &cancellables)

            weatherViewModel.$maxTemperature
                .sink { receivedTemp in
                    XCTAssertEqual(receivedTemp, weather.maxTemp)
                    expectation.fulfill()
                }
                .store(in: &cancellables)

            weatherViewModel.$minTemperature
                .sink { receivedTemp in
                    XCTAssertEqual(receivedTemp, weather.minTemp)
                    expectation.fulfill()
                }
                .store(in: &cancellables)

        }
    }
}

class WeatherModelMock: WeatherModelProtocol {
    var weatherCondition: WeatherCondition!
    var maxTemp: Int!
    var minTemp: Int!
    
    func fetchWeatherCondition() async throws -> FetchWeatherResponse {
        return .init(maxTemperature: maxTemp, date:"2020-04-01T12:00:00+09:00" , minTemperature: minTemp, weatherCondition: weatherCondition)
    }
    
    func encode(request: FetchWeatherRequest) -> String? {
        return nil
    }
    
    func decode(responseString: String) -> FetchWeatherResponse? {
        return nil
    }
}
