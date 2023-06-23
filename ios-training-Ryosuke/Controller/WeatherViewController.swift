//
//  ViewController.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/12.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet private weak var weatherImage: UIImageView!
    
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
        weatherImage.image = UIImage(named: response.weather_condition)?.withRenderingMode(.alwaysTemplate)
        if response.weather_condition == "sunny" {
            weatherImage.tintColor = .red
        } else if response.weather_condition == "cloudy" {
            weatherImage.tintColor = .gray
        } else if response.weather_condition == "rainy" {
            weatherImage.tintColor = .blue
        }
    }
    
    func failedFetchWeatherCondition() {
        let alertController = makeAlertController()
        present(alertController, animated: true, completion: nil)
    }
}
