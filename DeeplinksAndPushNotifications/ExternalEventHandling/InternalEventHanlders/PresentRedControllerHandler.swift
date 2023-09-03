//
//  PresentRedControllerHandler.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 24.08.2023.
//

import Foundation

public final class PresentRedControllerHandler: InternalEventHandler {
  
  // Present Red view controller
  private let handler: () -> Void
  
  public init(handler: @escaping () -> Void) {
    self.handler = handler
  }
  
  public func canHandle(_ event: Event.InternalEvent) -> Bool {
    switch event {
    case .presentRed:
      return true
      
    default:
      return false
    }
  }
  
  public func handle(_ event: Event.InternalEvent) {
    switch event {
    case .presentRed:
      handler()
      
    default:
      break
    }
  }
  
}
