//
//  MoviesSearchFlowCoordinator.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import UIKit

protocol WatchedMoviesFlowCoordinatorDependencies {
    func makeLandingPageViewController(actions: LandingPageViewModelActions) -> LandingPageViewController
    func makeSettingsViewController(actions: SettingsViewModelActions) -> SettingsViewController
    func makeGenreSelectionViewController(actions: GenreSelectionViewModelActions) -> GenreSelectionViewController
    func makeMoviesSearchViewController(genre: Genre,
                                        actions: MoviesSearchViewModelActions) -> MoviesSearchViewController
    func makeReviewWritingViewController(genre: Genre,
                                         movie: Movie,
                                         actions: ReviewWritingViewModelActions) -> ReviewWritingViewController
    func makeWatchedMoviesViewController(genre: Genre) -> WatchedMoviesViewController
}

final class WatchedMoviesFlowCoordinator {
    private weak var tabBarController: UITabBarController?
    private let dependencies: WatchedMoviesFlowCoordinatorDependencies
    
    private weak var landingPageVC: LandingPageViewController?
    private weak var settingVC: SettingsViewController?
    private weak var watchListNavigationVC: UINavigationController?
    private weak var settingsNavigationVC: UINavigationController?
    private weak var genreSelectionVC: GenreSelectionViewController?
    private weak var moviesSearchViewController: MoviesSearchViewController?
    private weak var reviewWritingViewController: ReviewWritingViewController?
    
    init(tabBarController: UITabBarController,
         dependencies: WatchedMoviesFlowCoordinatorDependencies) {
        self.tabBarController = tabBarController
        self.dependencies = dependencies
    }
    
    func start() {
        let landingPageActions = LandingPageViewModelActions(showGenreSelection: showGenreSelection,
                                                             showWatchedMovies: showWatchedMovies)
        let landingPageViewController = dependencies.makeLandingPageViewController(actions: landingPageActions)
        watchListNavigationVC = createNavigationController(for: landingPageViewController,
                                                              title: "기록",
                                                              image: UIImage(named: "list"))
        tabBarController?.viewControllers = [
            watchListNavigationVC ?? UIViewController(),
            createNavigationController(for: UIViewController(), title: "설정", image: UIImage(named: "setting"))
        ]
        landingPageVC = landingPageViewController
        
        let settingsActions = SettingsViewModelActions(showAddGenreAlert: showAddGenreAlert)
        let settingsViewController = dependencies.makeSettingsViewController(actions: settingsActions)
        settingsNavigationVC = createNavigationController(for: settingsViewController,
                                                             title: "설정",
                                                             image: UIImage(named: "setting"))
        tabBarController?.viewControllers = [
            watchListNavigationVC ?? UIViewController(),
            settingsNavigationVC ?? UIViewController()
        ]
        settingVC = settingsViewController
    }
    
    private func showGenreSelection() {
        let actions = GenreSelectionViewModelActions(showMovieSearchPage: showMovieSearchPage)
        let viewController = dependencies.makeGenreSelectionViewController(actions: actions)
        viewController.hidesBottomBarWhenPushed = true
        watchListNavigationVC?.pushViewController(viewController, animated: true)
        genreSelectionVC = viewController
    }
    
    private func showMovieSearchPage(genre: Genre) {
        let actions = MoviesSearchViewModelActions(showReviewWriting: showReviewWriting)
        let viewController = dependencies.makeMoviesSearchViewController(genre: genre, actions: actions)
        genreSelectionVC?.navigationController?.pushViewController(viewController, animated: true)
        moviesSearchViewController = viewController
    }
    
    private func showAddGenreAlert(alert: UIAlertController) {
        settingVC?.present(alert, animated: true, completion: nil)
    }
    
    private func showWatchedMovies(genre: Genre) {
        let viewController = dependencies.makeWatchedMoviesViewController(genre: genre)
        viewController.title = genre.title
        viewController.hidesBottomBarWhenPushed = true
        watchListNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    private func showReviewWriting(genre: Genre, movie: Movie) {
        let actions = ReviewWritingViewModelActions(goToLandingPage: addDataToWatchedHistory)
        let viewController = dependencies.makeReviewWritingViewController(genre: genre, movie: movie, actions: actions)
        moviesSearchViewController?.navigationController?.pushViewController(viewController, animated: true)
        reviewWritingViewController = viewController
    }
    
    private func addDataToWatchedHistory() {
        reviewWritingViewController?.navigationController?.popToRootViewController(animated: true)
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
