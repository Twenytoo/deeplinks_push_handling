//
//  InvitationLinkError.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 24.08.2023.
//

import Foundation

public enum InvitationLinkError: Error {
  
  case invalid
  
}

extension InvitationLinkError: LocalizedError {
  
  public var errorDescription: String? {
    switch self {
    case .invalid:
      return "The link is invalid."
    }
  }
  
}
