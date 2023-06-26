//
//  WeatherViewModel.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/19.
//
import YumemiWeather
import Foundation

protocol WeatherModelDelegate: AnyObject {
    func didFetchWeatherCondition(response: ResponseModel)
    func failedFetchWeatherCondition()
}

final class WeatherModel {
    weak var delegate: WeatherModelDelegate?
    
    func fetchWeatherCondition() {
        do {
            let request = RequestModel(area: "tokyo", date: "2020-04-01T12:00:00+09:00")
            let requestString = try encode(request: request)
            let responseString = try YumemiWeather.fetchWeather(requestString)
            let response = try decode(responseString: responseString)
            delegate?.didFetchWeatherCondition(response: response)
        } catch {
            delegate?.failedFetchWeatherCondition()
        }
    }
    
    private func encode(request: RequestModel) throws -> String {
        let requestData = try JSONEncoder().encode(request)
        guard let requestString = String(data: requestData, encoding: .utf8) else {
            throw EncodingError.invalidValue(request, EncodingError.Context(codingPath: [], debugDescription: "Request data could not be converted to a string."))
        }
        return requestString
    }
    
    private func decode(responseString: String) throws -> ResponseModel {
        guard let responseData = responseString.data(using: .utf8) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Response string could not be converted to Data."))
        }
        let response = try JSONDecoder().decode(ResponseModel.self, from: responseData)
        return response
    }
}
