//
//  WeatherDetailViewController.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/07/18.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    
    private var response: FetchWeatherResponse
    
    init?(coder: NSCoder, response: FetchWeatherResponse) {
        self.response = response
        super.init(coder: coder)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherImage.image = UIImage(named: response.info.weatherCondition.rawValue)?.withRenderingMode(.alwaysTemplate)
        weatherImage.tintColor = response.info.weatherCondition.color
        maxTemperatureLabel.text = String(response.info.maxTemperature)
        minTemperatureLabel.text = String(response.info.minTemperature)
    }
}
