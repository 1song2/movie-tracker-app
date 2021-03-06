//
//  AppDelegate.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = UITabBarController()
        
        window?.rootViewController = tabBarController
        appFlowCoordinator = AppFlowCoordinator(tabBarController: tabBarController,
                                                appDIContainer: appDIContainer)
        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
        
        return true
    }
}
