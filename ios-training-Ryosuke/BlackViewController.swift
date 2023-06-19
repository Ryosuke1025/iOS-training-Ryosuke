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
        self.dismiss(animated: true, completion: nil)
    }
}
