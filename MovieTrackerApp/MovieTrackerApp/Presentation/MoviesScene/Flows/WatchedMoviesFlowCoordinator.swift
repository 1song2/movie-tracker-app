//
//  MoviesSearchFlowCoordinator.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import UIKit

protocol WatchedMoviesFlowCoordinatorDependencies {
    func makeMyGenresViewController() -> MyGenresViewController
}

final class WatchedMoviesFlowCoordinator {
    private weak var tabBarController: UITabBarController?
    private let dependencies: WatchedMoviesFlowCoordinatorDependencies
    
    private weak var myGenresVC: MyGenresViewController?
    
    init(tabBarController: UITabBarController,
         dependencies: WatchedMoviesFlowCoordinatorDependencies) {
        self.tabBarController = tabBarController
        self.dependencies = dependencies
    }
    
    func start() {
        let viewController = dependencies.makeMyGenresViewController()
        if #available(iOS 13, *) {
            tabBarController?.view.backgroundColor = .systemBackground
        } else {
            tabBarController?.view.backgroundColor = .white
        }
        tabBarController?.viewControllers = [
            createNavigationController(for: viewController, title: "기록", image: UIImage(named: "list")),
            createNavigationController(for: UIViewController(), title: "설정", image: UIImage(named: "setting"))
        ]
        myGenresVC = viewController
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
