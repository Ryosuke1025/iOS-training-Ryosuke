//
//  ViewController.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/12.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    @IBOutlet private weak var weatherImage: UIImageView!
    @IBOutlet private weak var maxTemperatureLabel: UILabel!
    @IBOutlet private weak var minTemperatureLabel: UILabel!
    
    private let weatherModel = WeatherModel()
    
    @objc func appWillEnterForeground() {
        weatherModel.fetchWeatherCondition()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherModel.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
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
    func didFetchWeatherCondition(response: FetchWeatherResponse) {
        weatherImage.image = UIImage(named: response.weatherCondition.rawValue)?.withRenderingMode(.alwaysTemplate)
        switch response.weatherCondition {
        case .sunny:
            weatherImage.tintColor = .red
        case .cloudy:
            weatherImage.tintColor = .gray
        case .rainy:
            weatherImage.tintColor = .blue
        }
        maxTemperatureLabel.text = String(response.maxTemperature)
        minTemperatureLabel.text = String(response.minTemperature)
    }
    
    func failedFetchWeatherCondition() {
        let alertController = makeAlertController()
        present(alertController, animated: true, completion: nil)
    }
}
