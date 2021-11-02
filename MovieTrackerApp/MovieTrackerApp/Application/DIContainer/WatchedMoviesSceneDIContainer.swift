//
//  MoviesSceneDIContainer.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import UIKit

final class WatchedMoviesSceneDIContainer {
    struct Dependencies {
        let apiClient: APIClient
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - My Genres
    func makeMyGenresViewController() -> MyGenresViewController {
        return MyGenresViewController.create()
    }
    
    // MARK: - Flow Coordinators
    func makeWatchedMoviesFlowCoordinator(tabBarController: UITabBarController) -> WatchedMoviesFlowCoordinator {
        return WatchedMoviesFlowCoordinator(tabBarController: tabBarController,
                                            dependencies: self)
    }
}

extension WatchedMoviesSceneDIContainer: WatchedMoviesFlowCoordinatorDependencies {}
