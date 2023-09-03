//
//  InternalEventsHandlersRegistry.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 24.08.2023.
//

import Foundation

public protocol InternalEventsHandlersRegistry {
  
  func register(_ eventHandler: InternalEventHandler)
  
}
