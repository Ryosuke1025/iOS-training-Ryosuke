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
        let weatherModel = WeatherModel()
        let weatherViewModel = WeatherViewModel(weatherModel: weatherModel)
        guard let weatherViewController = WeatherViewController.getInstance(weatherViewModel: weatherViewModel) else { return}
        weatherViewController.modalPresentationStyle = .fullScreen
        present(weatherViewController, animated: true, completion: nil)
    }
}
