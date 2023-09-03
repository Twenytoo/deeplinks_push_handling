//
//  AppDelegate.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 03.08.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var applicationFlowCoordinator: ApplicationFlowCoordinator!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    applicationFlowCoordinator = ApplicationFlowCoordinator()
    applicationFlowCoordinator.didFinishLaunching(application: application, launchOptions: launchOptions)
    
    return true
  }

}

