//
//  AppDelegate.swift
//  PokeTCG
//
//  Created by Kevin Jonathan on 18/03/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController.init()
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator?.start()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        setupGlobalTheme()
        
        return true
    }
    
    func setupGlobalTheme() {
        window?.tintColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().isTranslucent = true
    }

}

