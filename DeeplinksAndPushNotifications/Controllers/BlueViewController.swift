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
  
  func handleEvent() {
    let imageView = UIImageView(image: UIImage(named: "cat"))
    imageView.frame = .init(x: 70, y: 250, width: 300, height: 300)
    
    view.addSubview(imageView)
  }
  
  private func setupView() {
    title = "Blue Controller"
    view.backgroundColor = UIColor(red: 0, green: 0.8235, blue: 0.9882, alpha: 1.0)
  }

}

// You need to implement it for all possible handlers.
extension BlueViewController: InternalEventHandler {
  
  func canHandle(_ event: Event.InternalEvent) -> Bool {
    switch event {
    case .presentBlue, .presentRed:
      return true
      
    default:
      return false
    }
  }
  
  func handle(_ event: Event.InternalEvent) {
    switch event {
    case .presentBlue, .presentRed:
      handleEvent()
      
    default:
      break
    }
  }
  
}
