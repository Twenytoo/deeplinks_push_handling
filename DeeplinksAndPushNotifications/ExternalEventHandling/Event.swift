//
//  Event.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 24.08.2023.
//

import Foundation
import UserNotifications

public enum ExternalEventType {
  
  case universalLink(URL)
  case pushNotification(UNNotification)
  
}

public enum Event: Equatable {
  
  public enum ExternalEvent {
    
    case deeplink(path: String)
    case notification(userInfo: [AnyHashable: Any])
    
  }
  
  public enum InternalEvent {
    
    case presentBlue
    case presentRed
    case presentYellow
    case notFound
  
  }
  
  case externalEvent(event: ExternalEvent)
  case internalEvent(event: InternalEvent)
  
  public static func == (lhs: Event, rhs: Event) -> Bool {
    switch (lhs, rhs) {
    case (.externalEvent(event: .notification), .externalEvent(event: .notification)),
      (.externalEvent(event: .deeplink), .externalEvent(event: .deeplink)):
      return true
      
    default:
      return false
    }
  }
  
}
