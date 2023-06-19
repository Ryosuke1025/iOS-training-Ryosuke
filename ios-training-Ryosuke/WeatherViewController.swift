//
//  ViewController.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/12.
//

import UIKit
import YumemiWeather
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
}

extension WeatherViewController: WeatherModelDelegate {
    func didFetchWeatherCondition(_ weather: String) {
        weatherImage.image = UIImage(named: weather)?.withRenderingMode(.alwaysTemplate)
        if weather == "sunny" {
            weatherImage.tintColor = .red
        } else if weather == "cloudy" {
            weatherImage.tintColor = .gray
        } else if weather == "rainy" {
            weatherImage.tintColor = .blue
        }
    }
}
