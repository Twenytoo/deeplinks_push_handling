//
//  AppState.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 25.08.2023.
//

import Combine
import UIKit

public enum AppState {
  
  case background
  case foreground
  
  public static func publisher() -> AnyPublisher<AppState, Never> {
    let foregroundPublisher = NotificationCenter.default
      .publisher(for: UIApplication.didBecomeActiveNotification)
      .map { _ in AppState.foreground }
    let backgroundPublisher = NotificationCenter.default
      .publisher(for: UIApplication.willResignActiveNotification)
      .map { _ in AppState.background }
    
    return foregroundPublisher.merge(with: backgroundPublisher)
      .eraseToAnyPublisher()
  }
  
}
