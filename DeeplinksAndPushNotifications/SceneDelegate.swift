//
//  SceneDelegate.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 03.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  var applicationFlowCoordinator: ApplicationFlowCoordinator? {
    (UIApplication.shared.delegate as? AppDelegate)?.applicationFlowCoordinator
  }

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    self.window = window
    
    applicationFlowCoordinator?.start(on: window)
    
    // Handle Universal links when the app launches
    if
      let userActivity = connectionOptions.userActivities.first,
      userActivity.activityType == NSUserActivityTypeBrowsingWeb,
      let incomingURL = userActivity.webpageURL
    {
      applicationFlowCoordinator?.receiveUniversalLink(incomingURL)
    }
  }
  
  // Handle Universal links
  func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
          let incomingURL = userActivity.webpageURL else {
      return
    }
    
    applicationFlowCoordinator?.receiveUniversalLink(incomingURL)
  }

}

