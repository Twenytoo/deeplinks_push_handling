//
//  Event.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 24.08.2023.
//

import Foundation

public enum ExternalEventType {
  
  case universalLink(URL)
  case pushNotification(PushNotificationConfig)
  
}

public enum Event: Equatable {
  
  public enum ExternalEvent {
    
    case deeplink(path: String)
    /// In case when app in foreground state 'Coordinator' first who is able to handle event,
    /// then we have to pass event handling to model if it's ready.
    
    /// Otherwise, a notification banner will be displayed.
    /// After processing the banner, the 'isBannerTapped' attribute will be 'true',
    /// which means that the event can be processed at the 'Coordinator' level
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
