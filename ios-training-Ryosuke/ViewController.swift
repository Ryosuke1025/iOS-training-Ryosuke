//
//  ViewController.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/12.
//

import UIKit
import YumemiWeather
class ViewController: UIViewController {
    
    var weather: String = ""
    @IBOutlet weak var weatherImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func reload(_ sender: Any) {
        weather = YumemiWeather.fetchWeatherCondition()
        weatherImage.image = UIImage(named: weather)
        if(weather == "sunny") {
            weatherImage.tintColor = .red
        } else if(weather == "cloudy") {
            weatherImage.tintColor = .gray
        } else {
            weatherImage.tintColor = .blue
        }
    }
}
