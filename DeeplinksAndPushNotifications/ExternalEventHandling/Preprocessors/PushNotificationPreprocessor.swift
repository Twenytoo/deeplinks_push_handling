//
//  PushNotificationPreprocessor.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 24.08.2023.
//

import Foundation

final class PushNotificationPreprocessor: EventPreprocessor {
  
  // Transforming the external event - push notification into internal event
  func preprocess(_ event: Event) async throws -> Event {
    switch event {
    case .externalEvent(event: .notification(let payload)):
      if payload["aps"] as? [String: Any] != nil {
        return try await processEvent(event, payload: payload)
      }
      
      return .internalEvent(event: .notFound)
      
    default:
      return event
    }
  }
  
  private func processEvent(
    _ event: Event,
    payload: [AnyHashable: Any]
  ) async throws -> Event {
    guard let path = (payload["screen"] as? String) else {
      
      return .internalEvent(event: .notFound)
    }
    
    switch path {
    case "blue":
      return .internalEvent(event: .presentBlue)
      
    case "red":
      return .internalEvent(event: .presentRed)
      
    case "yellow":
      return .internalEvent(event: .presentYellow)
      
    default:
      return .internalEvent(event: .notFound)
    }
  }
  
}
