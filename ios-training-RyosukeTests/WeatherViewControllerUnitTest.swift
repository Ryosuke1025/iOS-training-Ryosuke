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
        weatherViewController = WeatherViewController.getInstance(weatherModel: mock)
        weatherViewController.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        weatherViewController  = nil
    }
    
    func testSunny() {
        compareWithImage(weatherCondition: WeatherCondition.sunny)
    }
    
    func testCloudy() {
        compareWithImage(weatherCondition: WeatherCondition.cloudy)
    }
    
    func testRainy() {
        compareWithImage(weatherCondition: WeatherCondition.rainy)
    }
    
    private func compareWithImage(weatherCondition: WeatherCondition) {
        mock.weatherCondition = weatherCondition
        mock.fetchWeatherCondition()
        XCTAssertEqual(weatherViewController.weatherImage.image, UIImage(named: weatherCondition.rawValue)?.withRenderingMode(.alwaysTemplate))
    }
    
    func testMaxTemperature() throws {
        mock.weatherCondition = .sunny
        mock.fetchWeatherCondition()
        let maxTemperatureText = try XCTUnwrap(weatherViewController.maxTemperatureLabel.text)
        XCTAssertEqual(maxTemperatureText, "25")
    }
    
    func testMinTemperature() throws {
        mock.weatherCondition = .sunny
        mock.fetchWeatherCondition()
        let minTemperatureText = try XCTUnwrap(weatherViewController.minTemperatureLabel.text)
        XCTAssertEqual(minTemperatureText, "7")
    }
}

class WeatherModelMock: WeatherModel {
    weak var delegate: WeatherModelDelegate?
    var weatherCondition: WeatherCondition!
    
    func fetchWeatherCondition() {
        delegate?.didFetchWeatherCondition(response: .init(maxTemperature: 25, date:"2020-04-01T12:00:00+09:00" , minTemperature: 7, weatherCondition: weatherCondition))
    }
    
    func encode(request: FetchWeatherRequest) -> String? {
        return nil
    }
    
    func decode(responseString: String) -> FetchWeatherResponse? {
        return nil
    }
}
