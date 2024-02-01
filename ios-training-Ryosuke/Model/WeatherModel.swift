//
//  WeatherViewModel.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/19.
//
import YumemiWeather
import Foundation

protocol WeatherModelProtocol {
    func fetchWeatherCondition() async throws -> FetchWeatherResponse
    func encode(request: FetchWeatherRequest) -> String?
    func decode(responseString: String) -> FetchWeatherResponse?
}

enum FetchWeatherConditionError: Error {
    case decoding
    case encoding
    case unknown
}

final class WeatherModel: WeatherModelProtocol {
    func fetchWeatherCondition() async throws -> FetchWeatherResponse {
        let request = FetchWeatherRequest(area: "tokyo", date: "2020-04-01T12:00:00+09:00")
        guard let requestString = self.encode(request: request) else {
            throw FetchWeatherConditionError.encoding
        }
        do {
            let responseString = try await YumemiWeather.asyncFetchWeather(requestString)
            guard let response = self.decode(responseString: responseString) else {
                throw FetchWeatherConditionError.decoding
            }
            return response
        } catch {
            throw FetchWeatherConditionError.unknown
        }
    }
    
    func encode(request: FetchWeatherRequest) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        guard let requestData = try? encoder.encode(request),
              let requestString = String(data: requestData, encoding: .utf8) else {
            return nil
        }
        return requestString
    }
    
    func decode(responseString: String) -> FetchWeatherResponse? {
        guard let responseData = responseString.data(using: .utf8),
              let response = try? JSONDecoder().decode(FetchWeatherResponse.self, from: responseData) else {
            return nil
        }
        return response
    }
}
