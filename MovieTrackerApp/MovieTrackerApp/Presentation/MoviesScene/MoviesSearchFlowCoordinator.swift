//
//  MoviesSearchFlowCoordinator.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import UIKit

protocol MoviesSearchFlowCoordinatorDependencies {
    func makeMoviesViewController() -> MoviesViewController
}

final class MoviesSearchFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: MoviesSearchFlowCoordinatorDependencies

    private weak var moviesVC: MoviesViewController?

    init(navigationController: UINavigationController,
         dependencies: MoviesSearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let viewController = dependencies.makeMoviesViewController()

        navigationController?.pushViewController(viewController, animated: false)
        moviesVC = viewController
    }
}
