//
//  AppFlowCoordinator.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import UIKit

final class AppFlowCoordinator {
    var tabBarController: UITabBarController
    private let appDIContainer: AppDIContainer
    
    init(tabBarController: UITabBarController,
         appDIContainer: AppDIContainer) {
        self.tabBarController = tabBarController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let watchedMoviesSceneDIContainer = appDIContainer.makeWatchedMoviesSceneDIContainer()
        let flow = watchedMoviesSceneDIContainer.makeWatchedMoviesFlowCoordinator(tabBarController: tabBarController)
        flow.start()
    }
}
