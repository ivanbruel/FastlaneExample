//
//  AppDelegate.swift
//  FastlaneExample
//
//  Created by Ivan Bruel on 30/05/2017.
//  Copyright © 2017 Swift Aveiro. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow? = {
    let window = UIWindow(frame: UIScreen.main.bounds)
    let networking = ProcessInfo.processInfo.environment["UI_TESTING"] == nil ?
      GitHubNetworking.newNetworking() : GitHubNetworking.newStubbedNetworking()
    let repositoriesViewController =
      RepositoriesViewController(viewModel: RepositoriesViewModel(networking: networking))
    window.rootViewController = UINavigationController(rootViewController: repositoriesViewController)
    return window
  }()

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window?.makeKeyAndVisible()
    return true
  }
}
