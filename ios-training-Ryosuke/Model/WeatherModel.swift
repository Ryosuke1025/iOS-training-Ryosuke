//
//  WeatherViewModel.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/19.
//
import YumemiWeather
import Foundation

protocol WeatherModelDelegate: AnyObject {
    func didFetchWeatherCondition(response: FetchWeatherResponse)
    func failedFetchWeatherCondition()
}

final class WeatherModel {
    weak var delegate: WeatherModelDelegate?
    
    func fetchWeatherCondition() {
        do {
            let request = FetchWeatherRequest(area: "tokyo", date: "2020-04-01T12:00:00+09:00")
            guard let requestString = encode(request: request) else {
                assertionFailure("Encode Failed")
                return
            }
            let responseString = try YumemiWeather.fetchWeather(requestString)
            guard let response = decode(responseString: responseString) else {
                assertionFailure("Decode Failed")
                return
            }
            delegate?.didFetchWeatherCondition(response: response)
        } catch {
            delegate?.failedFetchWeatherCondition()
        }
    }
    
    private func encode(request: FetchWeatherRequest) -> String? {
        guard let requestData = try? JSONEncoder().encode(request),
              let requestString = String(data: requestData, encoding: .utf8) else {
            return nil
        }
        return requestString
    }
    
    private func decode(responseString: String) -> FetchWeatherResponse? {
        guard let responseData = responseString.data(using: .utf8) else {
            return nil
        }
        let response = try? JSONDecoder().decode(FetchWeatherResponse.self, from: responseData)
        return response
    }
}
