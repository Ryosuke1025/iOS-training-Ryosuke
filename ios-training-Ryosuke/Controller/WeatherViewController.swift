//
//  ViewController.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/12.
//

import UIKit
import Combine

final class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var weatherViewModel: WeatherViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    init?(coder: NSCoder, weatherViewModel: WeatherViewModel) {
        self.weatherViewModel = weatherViewModel
        super.init(coder: coder)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("WeatherViewController is deinit")
    }
    
    static func getInstance(weatherViewModel: WeatherViewModel) -> WeatherViewController? {
        let storyboard = UIStoryboard(name: "WeatherView", bundle: nil)
        let weatherViewController = storyboard.instantiateInitialViewController { coder in
            WeatherViewController(coder: coder, weatherViewModel: weatherViewModel)
        }
        return weatherViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .filter { [weak self] _ in self?.presentedViewController == nil }
            .sink { [weak self] _ in
                Task {
                    await self?.updateWeatherCondition()
                }
            }
            .store(in: &cancellables)
    }
    
    @IBAction private func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // swiftlint:disable private_action
    @IBAction func reload(_ sender: Any) {
        indicator.startAnimating()
        Task {
            await self.updateWeatherCondition()
        }
>>>>>>> a3a9f69 ([Fix] コールバックからconcurrencyに書き換え)
    }
    // swiftlint:enable private_action
    
    func makeAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: "予期せぬエラー", message: "OKボタンを押して下さい", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        return alertController
    }
}

extension WeatherViewController {
    func updateWeatherCondition() async {
        do {
            let response = try await weatherModel.fetchWeatherCondition()
            self.weatherImage.image = UIImage(named: response.weatherCondition.rawValue)?.withRenderingMode(.alwaysTemplate)
            switch response.weatherCondition {
            case .sunny:
                self.weatherImage.tintColor = .red
            case .cloudy:
                self.weatherImage.tintColor = .gray
            case .rainy:
                self.weatherImage.tintColor = .blue
            }
            self.maxTemperatureLabel.text = String(response.maxTemperature)
            self.minTemperatureLabel.text = String(response.minTemperature)
            self.indicator.stopAnimating()
        } catch {
            let alertController = self.makeAlertController()
            self.present(alertController, animated: true, completion: nil)
            self.indicator.stopAnimating()
        }
    }
}
