//
//  BlackViewController.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/19.
//

import Foundation
import UIKit

final class BlackViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let storyboard = UIStoryboard(name: "WeatherView", bundle: nil)
        if let weatherViewController = storyboard.instantiateViewController(withIdentifier: "WeatherView") as? WeatherViewController {
            weatherViewController.setWeatherModel(WeatherModelImpl())
            weatherViewController.modalPresentationStyle = .fullScreen
            present(weatherViewController, animated: true, completion: nil)
        }
    }
}
