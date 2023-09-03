//
//  RedViewController.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 24.08.2023.
//

import UIKit

class RedViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  private func setupView() {
    title = "Red Controller"
    view.backgroundColor = .red
  }

}
