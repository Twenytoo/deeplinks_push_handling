//
//  InternalEventHandler.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 24.08.2023.
//

import Foundation

public protocol InternalEventHandler: AnyObject {
  
  var shouldBeRemoved: Bool { get }
  
  func canHandle(_ event: Event.InternalEvent) -> Bool
  func handle(_ event: Event.InternalEvent)
  
}

public extension InternalEventHandler {
  
  var shouldBeRemoved: Bool {
    false
  }
  
}

extension WeakRefContainer: InternalEventHandler where T: InternalEventHandler {
  
  public var shouldBeRemoved: Bool {
    object == nil
  }
  
  public func canHandle(_ event: Event.InternalEvent) -> Bool {
    object?.canHandle(event) ?? false
  }
  
  public func handle(_ event: Event.InternalEvent) {
    object.handle(event)
  }
  
}
