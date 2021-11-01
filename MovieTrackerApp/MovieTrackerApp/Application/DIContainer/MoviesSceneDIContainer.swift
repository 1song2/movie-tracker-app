//
//  MoviesSceneDIContainer.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import UIKit

final class MoviesSceneDIContainer {
    struct Dependencies {
        let apiClient: APIClient
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Movies List
    
    func makeMoviesViewController() -> MoviesViewController {
        return MoviesViewController.create()
    }
    
    // MARK: - Flow Coordinators
    func makeMoviesSearchFlowCoordinator(tabBarController: UITabBarController) -> MoviesSearchFlowCoordinator {
        return MoviesSearchFlowCoordinator(tabBarController: tabBarController,
                                           dependencies: self)
    }
}

extension MoviesSceneDIContainer: MoviesSearchFlowCoordinatorDependencies {}
