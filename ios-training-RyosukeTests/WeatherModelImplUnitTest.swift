//
//  WeatherModelImplUnitTest.swift
//  ios-training-RyosukeTests
//
//  Created by 須崎 良祐 on 2023/07/03.
//

import XCTest
@testable import ios_training_Ryosuke

final class WeatherModelImplUnitTest: XCTestCase {
    
    var weatherModelImpl: WeatherModelImpl!
    
    override func setUpWithError() throws {
        weatherModelImpl = WeatherModelImpl()
    }

    override func tearDownWithError() throws {
        weatherModelImpl = nil
    }
    
    func testEncodeSuccess() throws {
        let area = "tokyo"
        let date = "2020-04-01T12:00:00+09:00"
        let request = FetchWeatherRequest(area: area, date: date)
        let encoded = try XCTUnwrap(weatherModelImpl.encode(request: request))
        let expected = """
                {
                  "area" : "\(area)",
                  "date" : "\(date)"
                }
                """
        XCTAssertEqual(encoded, expected)
    }
    
    func testDecodeSuccess() throws {
        let responseString = """
                {
                  "max_temperature" : 25,
                  "date": "2020-04-01T12:00:00+09:00",
                  "min_temperature" : 7,
                  "weather_condition" : "sunny"
                }
                """
        let decoded = try XCTUnwrap(weatherModelImpl.decode(responseString: responseString))
        let expected = FetchWeatherResponse(maxTemperature: 25, date: "2020-04-01T12:00:00+09:00", minTemperature: 7, weatherCondition: .sunny)
        XCTAssertEqual(decoded.maxTemperature, expected.maxTemperature)
        XCTAssertEqual(decoded.date, expected.date)
        XCTAssertEqual(decoded.minTemperature, expected.minTemperature)
        XCTAssertEqual(decoded.weatherCondition, expected.weatherCondition)
    }
    
    func testDecodeFailure() throws {
        let responseString = """
                {
                  "max_temperature" : ,
                  "date": "2020-04-01T12:00:00+09:00",
                  "min_temperature" : 7,
                  "weather_condition" : "sunny"
                }
                """
        let result = weatherModelImpl.decode(responseString: responseString)
        XCTAssertNil(result, "Decode should fail for invalid request.")
    }
}
