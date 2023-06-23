//
//  ViewController.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/12.
//

import UIKit



final class WeatherViewController: UIViewController {
    
    @IBOutlet private weak var weatherImage: UIImageView!
    @IBOutlet private weak var maxTemperature: UILabel!
    @IBOutlet private weak var minTemperature: UILabel!
    
    private let weatherModel = WeatherModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherModel.delegate = self
    }
    
    @IBAction private func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func reload(_ sender: Any) {
        weatherModel.fetchWeatherCondition()
    }
    
    func makeAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: "予期せぬエラー", message: "OKボタンを押して下さい", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        return alertController
    }
}

extension WeatherViewController: WeatherModelDelegate {
    func didFetchWeatherCondition(response: ResponnseModel) {
        weatherImage.image = UIImage(named: response.weather_condition.rawValue)?.withRenderingMode(.alwaysTemplate)
        switch response.weather_condition {
        case .sunny:
                weatherImage.tintColor = .red
        case .cloudy:
                weatherImage.tintColor = .gray
        case .rainy:
                weatherImage.tintColor = .blue
        }
        maxTemperature.text = String(response.maxTemperature)
        minTemperature.text = String(response.minTemperature)
    }
    
    func failedFetchWeatherCondition() {
        let alertController = makeAlertController()
        present(alertController, animated: true, completion: nil)
    }
}
