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
        setupBindings()
    }
    
    private func setupBindings() {
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .filter { [weak self] _ in self?.presentedViewController == nil }
            .sink { [weak self] _ in
                Task {
                    await self?.weatherViewModel.fetchWeatherCondition()
                }
            }
            .store(in: &cancellables)

        weatherViewModel.$weatherCondition
            .receive(on: DispatchQueue.main)
            .sink { [weak self] condition in
                guard let self = self, let condition = condition else {
                    self?.weatherImage.image = nil
                    return
                }
                self.updateWeatherImage(for: condition)
            }
            .store(in: &cancellables)
        
        weatherViewModel.$maxTemperature
            .receive(on: DispatchQueue.main)
            .sink { [weak self] temp in
                guard let self = self, let temp = temp else {
                    self?.maxTemperatureLabel.text = "--"
                    return
                }
                self.maxTemperatureLabel.text = "\(temp)"
            }
            .store(in: &cancellables)
        
        weatherViewModel.$minTemperature
            .receive(on: DispatchQueue.main)
            .sink { [weak self] temp in
                guard let self = self, let temp = temp else {
                    self?.minTemperatureLabel.text = "--"
                    return
                }
                self.minTemperatureLabel.text = "\(temp)"
            }
            .store(in: &cancellables)
        
        weatherViewModel.$isError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isError in
                if isError {
                    guard let self = self else {
                        return
                    }
                    self.present(self.makeAlertController(), animated: true, completion: nil)
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
            await weatherViewModel.fetchWeatherCondition()
            self.indicator.stopAnimating()
        }
    }
    // swiftlint:enable private_action
    
    private func updateWeatherImage(for condition: WeatherCondition) {
        weatherImage.image = UIImage(named: condition.rawValue)?.withRenderingMode(.alwaysTemplate)
        switch condition {
        case .sunny:
            weatherImage.tintColor = .red
        case .cloudy:
            weatherImage.tintColor = .gray
        case .rainy:
            weatherImage.tintColor = .blue
        }
    }

    private func makeAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: "予期せぬエラー", message: "OKボタンを押して下さい", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        return alertController
    }
}
