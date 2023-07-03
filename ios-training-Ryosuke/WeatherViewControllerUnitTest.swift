//
//  WeatherViewControllerUnitTest.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/07/03.
//

/*import XCTest
@testable import ios_training_Ryosuke

final class WeatherViewControllerUnitTest: XCTestCase {
    
    var weatherViewController: WeatherViewController!
    let mock = WeatherModelMock()
    
    override func setUpWithError() throws {
        weatherViewController = WeatherViewController.getInstance(weatherModel: mock)
        
    }

    override func tearDownWithError() throws {
        weatherViewController  = nil
    }
    
    func testSunny() {
        compareWithImage(weatherCondition: "sunny")
    }
    
    func testCloudy() {
        compareWithImage(weatherCondition: "cloudy")
    }
    
    func testRainy() {
        compareWithImage(weatherCondition: "rainy")
    }
    
    private func compareWithImage(weatherCondition: String) {
        mock.weatherCondition = weatherCondition
        mock.fetchWeather()
        XCTAssertEqual(weatherViewController.weatherImage.image, UIImage(named: weatherCondition)?.withRenderingMode(.alwaysTemplate))
    }
    
    func testMaxTemperature() throws {
        
    }

    func testMinTemperature() throws {
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class WeatherModelMock: WeatherModel {
    weak var delegate: WeatherModelDelegate?
    var weatherCondition: String = ""
    
    func fetchWeather() {
        delegate?.weatherModel(self, didFetchWeather: .init(maxTemperature: 25, date:"2020-04-01T12:00:00+09:00" , minTemperature: 7, weatherCondition: weatherCondition))
    }
}*/
