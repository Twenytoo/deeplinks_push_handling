//
//  PresentBlueControllerHandler.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 24.08.2023.
//

import Foundation

public final class PresentBlueControllerHandler: InternalEventHandler {
  
  // Present Blue view controller
  private let handler: () -> Void
  
  public init(handler: @escaping () -> Void) {
    self.handler = handler
  }
  
  public func canHandle(_ event: Event.InternalEvent) -> Bool {
    switch event {
    case .presentBlue:
      return true
      
    default:
      return false
    }
  }
  
  public func handle(_ event: Event.InternalEvent) {
    switch event {
    case .presentBlue:
      handler()
      
    default:
      break
    }
  }
  
}
