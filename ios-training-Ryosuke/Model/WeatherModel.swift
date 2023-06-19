//
//  WeatherViewModel.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/19.
//
import YumemiWeather

protocol WeatherModelDelegate: AnyObject {
    func didFetchWeatherCondition(_ weather: String)
}

class WeatherModel {
    weak var delegate: WeatherModelDelegate?
    
    func fetchWeatherCondition() {
        let weather = YumemiWeather.fetchWeatherCondition()
        delegate?.didFetchWeatherCondition(weather)
    }
}
