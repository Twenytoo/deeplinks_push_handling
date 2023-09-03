//
//  YellowViewController.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 24.08.2023.
//

import UIKit

class YellowViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  private func setupView() {
    title = "Yellow Controller"
    view.backgroundColor = .yellow
  }

}
