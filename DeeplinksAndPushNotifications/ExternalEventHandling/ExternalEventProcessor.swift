//
//  ExternalEventProcessor.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 24.08.2023.
//

import Foundation
import UserNotifications

private struct Constants {
  
  static let invitePathComponent = "deeplink"
  static let hostURL = "https://some_url"
  
}

public struct PushNotificationConfig {
  
  let notification: UNNotification
  let completion: () -> Void
  
  public init(
    notification: UNNotification,
    completion: @escaping () -> Void
  ) {
    self.notification = notification
    self.completion = completion
  }
  
}

public final class ExternalEventProcessor {
  
  private var eventHandlers: [InternalEventHandler]
  private let eventPreprocessors: [EventPreprocessor]
  
  public init(
    eventHandlers: [InternalEventHandler],
    eventPreprocessors: [EventPreprocessor]
  ) {
    self.eventHandlers = eventHandlers
    self.eventPreprocessors = eventPreprocessors
  }
  
  public func process(_ externalEventType: ExternalEventType) {
    switch externalEventType {
    case .universalLink(let url):
      processUniversalLink(url)
      
    case let .pushNotification(configuration):
      processRemoteNotification(
        configuration.notification,
        completion: configuration.completion
      )
    }
  }
  
  private func processRemoteNotification(_ notification: UNNotification, completion: @escaping () -> Void) {
    Task {
      do {
        let event: Event = .externalEvent(event: .notification(userInfo: notification.request.content.userInfo))
        let preprocessedEvent = try await preprocessEvent(event)
        
        await MainActor.run {
          handleEvent(preprocessedEvent, completion: completion)
        }
      }
    }
  }
  
  private func processUniversalLink(_ link: URL) {
    Task {
      do {
        let parsedEvent = try parse(link)
        let preprocessedEvent = try await preprocessEvent(parsedEvent)

        await MainActor.run {
          handleEvent(preprocessedEvent)
        }
      } catch {
        // handle error
        print(error)
        
      }
    }
  }
  
  private func preprocessEvent(_ event: Event) async throws -> Event {
      var processingEvent = event
      for processor in eventPreprocessors {
        let processedEvent = try await processor.preprocess(processingEvent)
        processingEvent = processedEvent
      }
      
      return processingEvent
  }
  
  private func handleEvent(_ event: Event, completion: (() -> Void)? = nil) {
//     Updating the list of handlers before processing a new event.
    eventHandlers = eventHandlers.filter { !$0.shouldBeRemoved }
    guard
      case .internalEvent(let event) = event,
      let handler = eventHandlers.last(where: { $0.canHandle(event) })
    else {
      completion?()
      
      return
    }
     
    handler.handle(event)
  }
  
  // Parsing universal link
  private func parse(_ url: URL) throws -> Event {
    guard url.host?.lowercased() == Constants.hostURL.lowercased() else {
      throw InvitationLinkError.invalid
    }
    
    guard let path = url.pathComponents.last else {
      throw InvitationLinkError.invalid
    }
    
    if let invitePathComponent = url.pathComponents.first(where: { $0 != "/" }),
       invitePathComponent == Constants.invitePathComponent {
      return .externalEvent(event: .deeplink(path: path))
    }
    
    throw InvitationLinkError.invalid
  }
  
}

extension ExternalEventProcessor: InternalEventsHandlersRegistry {
  
  public func register(_ eventHandler: InternalEventHandler) {
    eventHandlers.append(eventHandler)
  }
  
}
