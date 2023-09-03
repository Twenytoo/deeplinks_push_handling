//
//  BlueViewController.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 24.08.2023.
//

import UIKit

class BlueViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  private func setupView() {
    title = "Blue Controller"
    view.backgroundColor = .blue
  }


}

