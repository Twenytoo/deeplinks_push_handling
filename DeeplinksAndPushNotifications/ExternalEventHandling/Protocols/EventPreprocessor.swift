//
//  EventPreprocessor.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 24.08.2023.
//

import Foundation

public protocol EventPreprocessor {
  
  func preprocess(_ event: Event) async throws -> Event
  
}
