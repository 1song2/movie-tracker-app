//
//  MoviesSearchFlowCoordinator.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import UIKit

protocol WatchedMoviesFlowCoordinatorDependencies {
    func makeLandingPageViewController(actions: LandingPageViewModelActions) -> LandingPageViewController
}

final class WatchedMoviesFlowCoordinator {
    private weak var tabBarController: UITabBarController?
    private let dependencies: WatchedMoviesFlowCoordinatorDependencies
    
    private weak var landingPageVC: LandingPageViewController?
    private weak var watchListNavigationVC: UINavigationController?
    private weak var settingsNavigationVC: UINavigationController?
    
    init(tabBarController: UITabBarController,
         dependencies: WatchedMoviesFlowCoordinatorDependencies) {
        self.tabBarController = tabBarController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = LandingPageViewModelActions(showGenreSelection: showGenreSelection,
                                                  showWatchlist: showWatchlist)
        let viewController = dependencies.makeLandingPageViewController(actions: actions)
        watchListNavigationVC = createNavigationController(for: viewController,
                                                              title: "기록",
                                                              image: UIImage(named: "list"))
        tabBarController?.viewControllers = [
            watchListNavigationVC ?? UIViewController(),
            createNavigationController(for: UIViewController(), title: "설정", image: UIImage(named: "setting"))
        ]
        landingPageVC = viewController
    }
    
    private func showGenreSelection() {
        let viewController = GenreSelectionViewController.create()
        viewController.hidesBottomBarWhenPushed = true
        watchListNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    private func showWatchlist(genre: Genre) {
        let viewController = WatchedMoviesViewController.create()
        // viewController.title = genre[$0.row]
        viewController.hidesBottomBarWhenPushed = true
        watchListNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    private func createNavigationController(for rootVC: UIViewController,
                                            title: String,
                                            image: UIImage?) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
}
