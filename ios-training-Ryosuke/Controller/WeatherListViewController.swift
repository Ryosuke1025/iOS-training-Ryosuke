//
//  WeatherListViewController.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/07/18.
//

import UIKit

class WeatherListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var response: [FetchWeatherResponse] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var weatherModel: WeatherModelProtocol
    
    init?(coder: NSCoder, weatherModel: WeatherModelProtocol) {
        self.weatherModel = weatherModel
        super.init(coder: coder)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("WeatherListViewController is deinit")
    }
    
    static func getInstance(weatherModel: WeatherModelProtocol) -> WeatherListViewController? {
        let storyboard = UIStoryboard(name: "WeatherListView", bundle: nil)
        let weatherListViewController = storyboard.instantiateInitialViewController { coder in
            WeatherListViewController(coder: coder, weatherModel: weatherModel)
        }
        return weatherListViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWeatherCondition()
    }
}

extension WeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "WeatherDetailView", bundle: nil)
        let nextVC = storyboard.instantiateInitialViewController { [self] coder in
            WeatherDetailViewController(coder: coder, response: response[indexPath.row])
        }
        guard let safenextVC = nextVC else { return }
        present(safenextVC, animated: true, completion: nil)
    }
}

extension WeatherListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell else {
            fatalError("Unable to dequeue a CustomCell.")
        }
        cell.weatherImage.image = UIImage(named: response[indexPath.row].info.weatherCondition.rawValue)?.withRenderingMode(.alwaysTemplate)
        cell.weatherImage.tintColor = response[indexPath.row].info.weatherCondition.color
        cell.cityLabel.text = response[indexPath.row].area
        cell.maxTemperatureLabel.text = String(response[indexPath.row].info.maxTemperature)
        cell.minTemperatureLabel.text = String(response[indexPath.row].info.minTemperature)
        return cell
    }
}

extension WeatherListViewController {
    func updateWeatherCondition() {
        do {
            response = try weatherModel.fetchWeatherCondition()
        } catch {
            DispatchQueue.main.async {
                let alertController = self.makeAlertController()
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func makeAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: "予期せぬエラー", message: "OKボタンを押して下さい", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        return alertController
    }
}
