//
//  BlackViewController.swift
//  ios-training-Ryosuke
//
//  Created by 須崎 良祐 on 2023/06/19.
//

import Foundation
import UIKit

class BlackViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 画面表示直後の処理を書く
        let storyboard = UIStoryboard(name: "WeatherView", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "WeatherView")
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true, completion: nil)
    }
}