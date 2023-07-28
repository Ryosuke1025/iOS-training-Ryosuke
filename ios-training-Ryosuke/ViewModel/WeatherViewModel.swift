//
//  WeatherViewModel.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/07/24.
//
final class WeatherViewModel {
    
    private var weatherModel: WeatherModelProtocol
    var weatherCondition: WeatherCondition
    var maxTemperature: Int
    var minTemperature: Int
    
    init(weatherModel: WeatherModelProtocol) {
        self.weatherModel = weatherModel
        self.weatherCondition = .sunny
        self.maxTemperature = 0
        self.minTemperature = 0
    }
    
    func fetchWeatherCondition(completion: @escaping (Result<Void, Error>) -> Void) {
        weatherModel.fetchWeatherCondition { [weak self] result in
            switch result {
            case .success(let response):
                self?.weatherCondition = response.weatherCondition
                self?.maxTemperature = response.maxTemperature
                self?.minTemperature = response.minTemperature
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
