//
//  DeeplinkPreprocessor.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 24.08.2023.
//

import Foundation

final class DeeplinkPreprocessor: EventPreprocessor {
  
  // There is some logic is going here
  // For example, fetching data for further processing
  public func preprocess(_ event: Event) async throws -> Event {
    switch event {
    case .externalEvent(event: .deeplink(path: let path)):
      switch path {
      case "blue":
        return .internalEvent(event: .presentBlue)
        
      case "red":
        return .internalEvent(event: .presentRed)
        
      case "yellow":
        return .internalEvent(event: .presentYellow)
        
      default:
        return event
      }
      
    default:
      return event
    }
  }
    
}
