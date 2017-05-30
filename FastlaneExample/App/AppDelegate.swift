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
    let repositoriesViewController = RepositoriesViewController(viewModel: RepositoriesViewModel(networking: .newNetworking()))
    window.rootViewController = UINavigationController(rootViewController: repositoriesViewController)
    return window
  }()


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    window?.makeKeyAndVisible()
    return true
  }
}
