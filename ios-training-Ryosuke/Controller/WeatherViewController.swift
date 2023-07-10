//
//  ViewController.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/12.
//

import UIKit
import Combine

final class WeatherViewController: UIViewController {

    private var cancellables: Set<AnyCancellable> = []
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    private var weatherModel: WeatherModelProtocol
    
    init?(coder: NSCoder, weatherModel: WeatherModelProtocol) {
        self.weatherModel = weatherModel
        super.init(coder: coder)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func getInstance(weatherModel: WeatherModelProtocol) -> WeatherViewController? {
        let storyboard = UIStoryboard(name: "WeatherView", bundle: nil)
        let weatherViewController = storyboard.instantiateInitialViewController { coder in
            WeatherViewController(coder: coder, weatherModel: weatherModel)
        }
        return weatherViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherModel.delegate = self
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .filter { [weak self] _ in self?.presentedViewController == nil }
            .sink { [weak self] _ in
                self?.weatherModel.fetchWeatherCondition()
            }
            .store(in: &cancellables)
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
