//
//  WeatherViewModel.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/19.
//
import YumemiWeather
import Foundation

protocol WeatherModelDelegate: AnyObject {
    func didFetchWeatherCondition(_ weather: String)
    func failedFetchWeatherCondition()
}

class WeatherModel {
    weak var delegate: WeatherModelDelegate?
    
    func fetchWeatherCondition() {
        let request = RequestModel(area: "tokyo", date: "2020-04-01T12:00:00+09:00")
        do {
            let requestData = try JSONEncoder().encode(request)
            guard let requestString = String(data: requestData, encoding: .utf8) else {
                assertionFailure("リクエストデータの文字列変換に失敗しました")
                return
            }
            do {
                let responseString = try YumemiWeather.fetchWeather(requestString)
                guard let responseData = responseString.data(using: .utf8) else {
                    assertionFailure("レスポンス文字列のデータ変換に失敗しました")
                    return
                }
                do {
                    let response = try JSONDecoder().decode(ResponnseModel.self, from: responseData)
                    delegate?.didFetchWeatherCondition(response: response)
                } catch {
                    print("レスポンスデータのデコードに失敗しました")
                }
            } catch {
                delegate?.didFetchWeatherCondition(error: CustomError.unknown)
            }
        } catch {
            delegate?.failedFetchWeatherCondition()
        }
    }
}
