//
//  ios_training_RyosukeTests.swift
//  ios-training-RyosukeTests
//
//  Created by 須崎 良祐 on 2023/07/03.
//

import XCTest
@testable import ios_training_Ryosuke

final class WeatherViewControllerUnitTest: XCTestCase {
    
    var weatherViewController: WeatherViewController!
    let mock = WeatherModelMock()
    
    override func setUpWithError() throws {
        let mock = WeatherModelMock()
        let weatherViewModel = WeatherViewModel(weatherModel: mock)
        weatherViewController = WeatherViewController.getInstance(weatherViewModel: weatherViewModel)
        weatherViewController.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        weatherViewController  = nil
    }
    
    func testReload() {
        let expectedWeather: [(condition: WeatherCondition, maxTemp: Int, minTemp: Int)] = [
            (.sunny, 7, 25),
            (.cloudy, 5, 20),
            (.rainy, 0, 15)
        ]
        
        for weather in expectedWeather {
            mock.weatherCondition = weather.condition
            mock.maxTemp = weather.maxTemp
            mock.minTemp = weather.minTemp
            weatherViewController.reload(UIButton())
            DispatchQueue.main.async {
                XCTAssertEqual(self.weatherViewController.weatherImage.image, UIImage(named: weather.condition.rawValue)?.withRenderingMode(.alwaysTemplate))
                XCTAssertEqual(self.weatherViewController.maxTemperatureLabel.text, String(weather.maxTemp))
                XCTAssertEqual(self.weatherViewController.minTemperatureLabel.text, String(weather.minTemp))
            }
            
        }
    }
}

class WeatherModelMock: WeatherModelProtocol {
    var weatherCondition: WeatherCondition!
    var maxTemp: Int!
    var minTemp: Int!
    
    func fetchWeatherCondition(completionHandler: @escaping (Result<FetchWeatherResponse, Error>) -> Void){
        completionHandler(.success(.init(maxTemperature: maxTemp, date:"2020-04-01T12:00:00+09:00" , minTemperature: minTemp, weatherCondition: weatherCondition)))
    }
    
    func encode(request: FetchWeatherRequest) -> String? {
        return nil
    }
    
    func decode(responseString: String) -> FetchWeatherResponse? {
        return nil
    }
}
