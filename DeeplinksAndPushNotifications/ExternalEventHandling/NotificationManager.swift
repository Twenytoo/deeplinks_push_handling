//
//  NotificationManager.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 03.09.2023.
//

import UIKit
import Combine

protocol NotificationManagerDelegate: AnyObject {
  
  func processPushNotification(_ notification: UNNotification, completion: @escaping () -> Void)
  
}

final class NotificationManager: NSObject {
  
  weak var delegate: NotificationManagerDelegate?
  
  private weak var application: UIApplication?

  override init() {
    super.init()
    
    UNUserNotificationCenter.current().delegate = self
  }
  
  func didFinishLaunching(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    self.application = application
  }

  func registerPushNotifications() {
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, error in
      if let error = error {
        print("oops: \(error.localizedDescription)")
      } else {
        DispatchQueue.main.async {
          self.application?.registerForRemoteNotifications()
        }
      }
    }
  }
  
}

extension NotificationManager: UNUserNotificationCenterDelegate {
  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    delegate?.processPushNotification(notification, completion: {
      completionHandler([.sound, .badge, .banner])
    })
  }
  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    delegate?.processPushNotification(response.notification, completion: completionHandler)
  }
  
}
