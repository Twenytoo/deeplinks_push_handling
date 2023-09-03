//
//  ApplicationFlowCoordinator.swift
//  DeeplinksAndPushNotifications
//
//  Created by Artem Lushchan on 03.08.2023.
//

import UIKit
import Combine

final class ApplicationFlowCoordinator: NSObject {
  
  weak var presentedViewController: UIViewController?
  
  let externalEventPublisher = PassthroughSubject<ExternalEventType, Never>()
 
  var rootViewController: UIViewController? {
    window.rootViewController
  }
  
  private(set) var window: UIWindow!
  
  private var subscriptions = Set<AnyCancellable>()
  
  private var notificationManager: NotificationManager!
  private var externalEventProcessor: ExternalEventProcessor!
  private let onApplicationFinishedStartingPublisher = PassthroughSubject<Bool, Never>()
  
  override init() {
    super.init()
    
    notificationManager = NotificationManager()
    notificationManager.delegate = self
    
    externalEventProcessor = ExternalEventProcessor(
      eventHandlers: [
        PresentBlueControllerHandler(handler: { [unowned self] in
          let controller = UINavigationController(rootViewController: BlueViewController())
          controller.navigationBar.prefersLargeTitles = true
          rootViewController?.present(controller, animated: true)
        }),
        PresentRedControllerHandler(handler: { [unowned self] in
          let controller = UINavigationController(rootViewController: RedViewController())
          controller.navigationBar.prefersLargeTitles = true
          rootViewController?.present(controller, animated: true)
        }),
        PresentYellowControllerHandler(handler: { [unowned self] in
          let controller = UINavigationController(rootViewController: YellowViewController())
          controller.navigationBar.prefersLargeTitles = true
          rootViewController?.present(controller, animated: true)
        })
      ],
      eventPreprocessors: [
        DeeplinkPreprocessor(),
        PushNotificationPreprocessor()
      ]
    )
    
    setupBindings()
  }
  
  func start(on window: UIWindow) {
    self.window = window
    
    let mainController = MainViewController()

    let navigationController = UINavigationController(rootViewController: mainController)
    navigationController.navigationBar.prefersLargeTitles = true
    
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    notificationManager.registerPushNotifications()
    onApplicationFinishedStartingPublisher.send(true)
  }
  
  func receiveUniversalLink(_ url: URL) {
    externalEventPublisher.send(.universalLink(url))
  }
  
  private func setupBindings() {
    /// `externalEventPublisher` events should be processed only under next conditions:
    /// 1. Application has finished its initialization (started all services + presented initial flow)
    /// 2. Application is in foreground state (it's impossible to process event in background since usually it requires some network activity)
    /// Thats why it requires complex logic to process events from `externalEventPublisher`
    /// only under required conditions.
    /// Used additional `externalEventsReceivingQueue` to process events from `externalEventPublisher`.
    /// Used additional `AppStatePublisher` and `onApplicationFinishedStartingPublisher`
    /// to observe current app state + app launch finished event  and manage queue state accordingly.
    let isAllowedToProcessExternalEvents = AppState.publisher()
      .combineLatest(onApplicationFinishedStartingPublisher)
      .map { $0.0 == .foreground && $0.1 }
      .removeDuplicates()
      .eraseToAnyPublisher()
    
    let externalEventsReceivingQueue = DispatchQueue(label: "com.loop.externalEventsReceivingQueue")
    externalEventsReceivingQueue.suspend()
    isAllowedToProcessExternalEvents.sink { isAllowed in
      if isAllowed {
        externalEventsReceivingQueue.resume()
      } else {
        externalEventsReceivingQueue.suspend()
      }
    }.store(in: &subscriptions)
    
    externalEventPublisher
      .receive(on: externalEventsReceivingQueue)
      .sink { [weak self] event in
        self?.externalEventProcessor.process(event)
      }
      .store(in: &subscriptions)
  }
  
}

extension ApplicationFlowCoordinator {
  
  func didFinishLaunching(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    notificationManager.didFinishLaunching(application: application, launchOptions: launchOptions)
  }
 
}

extension ApplicationFlowCoordinator: NotificationManagerDelegate {

  func processPushNotification(_ notification: UNNotification, completion: @escaping () -> Void) {
    let handler: PushNotificationConfig = .init(notification: notification, completion: completion)
    externalEventPublisher.send(.pushNotification(handler))
  }

}
