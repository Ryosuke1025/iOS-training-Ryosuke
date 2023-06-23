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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func reload(_ sender: Any) {
        var weather: String = ""
        weather = YumemiWeather.fetchWeatherCondition()
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
