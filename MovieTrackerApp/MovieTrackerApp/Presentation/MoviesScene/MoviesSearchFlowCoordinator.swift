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
    private weak var tabBarController: UITabBarController?
    private let dependencies: MoviesSearchFlowCoordinatorDependencies
    
    private weak var moviesVC: MoviesViewController?
    
    init(tabBarController: UITabBarController,
         dependencies: MoviesSearchFlowCoordinatorDependencies) {
        self.tabBarController = tabBarController
        self.dependencies = dependencies
    }
    
    func start() {
        let viewController = dependencies.makeMoviesViewController()
        if #available(iOS 13, *) {
            tabBarController?.view.backgroundColor = .systemBackground
        } else {
            tabBarController?.view.backgroundColor = .white
        }
        tabBarController?.viewControllers = [
            createNavigationController(for: viewController, title: "기록", image: UIImage(named: "list")),
            createNavigationController(for: UIViewController(), title: "설정", image: UIImage(named: "setting"))
        ]
        moviesVC = viewController
    }
    
    private func createNavigationController(for rootVC: UIViewController,
                                            title: String,
                                            image: UIImage?) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
}
