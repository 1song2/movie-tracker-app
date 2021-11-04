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
    func makeWatchedMoviesViewController(genre: Genre,
                                         actions: WatchedMoviesViewModelActions) -> WatchedMoviesViewController
}

final class WatchedMoviesFlowCoordinator {
    private weak var tabBarController: UITabBarController?
    private let dependencies: WatchedMoviesFlowCoordinatorDependencies
    
    private weak var watchedMoviesNavigationVC: UINavigationController?
    private weak var landingPageVC: LandingPageViewController?
    private weak var settingsNavigationVC: UINavigationController?
    private weak var settingsVC: SettingsViewController?
    private weak var genreSelectionVC: GenreSelectionViewController?
    private weak var moviesSearchVC: MoviesSearchViewController?
    private weak var reviewWritingVC: ReviewWritingViewController?
    private weak var watchedMoviesVC: WatchedMoviesViewController?
    
    init(tabBarController: UITabBarController,
         dependencies: WatchedMoviesFlowCoordinatorDependencies) {
        self.tabBarController = tabBarController
        self.dependencies = dependencies
    }
    
    func start() {
        let landingPageActions = LandingPageViewModelActions(showGenreSelection: showGenreSelection,
                                                             showWatchedMovies: showWatchedMovies)
        let landingPageViewController = dependencies.makeLandingPageViewController(actions: landingPageActions)
        watchedMoviesNavigationVC = createNavigationController(for: landingPageViewController,
                                                              title: "기록",
                                                              image: UIImage(named: "list"))
        tabBarController?.viewControllers = [
            watchedMoviesNavigationVC ?? UIViewController(),
            createNavigationController(for: UIViewController(), title: "설정", image: UIImage(named: "setting"))
        ]
        landingPageVC = landingPageViewController
        
        let settingsActions = SettingsViewModelActions(showAddGenreAlert: showAddGenreAlert)
        let settingsViewController = dependencies.makeSettingsViewController(actions: settingsActions)
        settingsNavigationVC = createNavigationController(for: settingsViewController,
                                                             title: "설정",
                                                             image: UIImage(named: "setting"))
        tabBarController?.viewControllers = [
            watchedMoviesNavigationVC ?? UIViewController(),
            settingsNavigationVC ?? UIViewController()
        ]
        settingsVC = settingsViewController
    }
    
    private func showGenreSelection() {
        let actions = GenreSelectionViewModelActions(showMovieSearchPage: showMovieSearchPage)
        let viewController = dependencies.makeGenreSelectionViewController(actions: actions)
        viewController.hidesBottomBarWhenPushed = true
        watchedMoviesNavigationVC?.pushViewController(viewController, animated: true)
        genreSelectionVC = viewController
    }
    
    private func showMovieSearchPage(genre: Genre) {
        let actions = MoviesSearchViewModelActions(showReviewWriting: showReviewWriting)
        let viewController = dependencies.makeMoviesSearchViewController(genre: genre, actions: actions)
        genreSelectionVC?.navigationController?.pushViewController(viewController, animated: true)
        moviesSearchVC = viewController
    }
    
    private func showAddGenreAlert(alert: UIAlertController) {
        settingsVC?.present(alert, animated: true, completion: nil)
    }
    
    private func showWatchedMovies(genre: Genre) {
        let actions = WatchedMoviesViewModelActions(showSortingModal: showSortingModal)
        let viewController = dependencies.makeWatchedMoviesViewController(genre: genre, actions: actions)
        viewController.title = genre.title
        viewController.hidesBottomBarWhenPushed = true
        watchedMoviesNavigationVC?.pushViewController(viewController, animated: true)
        watchedMoviesVC = viewController
    }
    
    private func showSortingModal(selectedSortingBy: SortingBy?) {
        // let actions = SortingViewModelActions(sendDataToWatchedMovies: sendDataToWatchedMovies)
        let viewModel = DefaultSortingViewModel(sortingBy: selectedSortingBy)
        let viewController = ModalViewController.create(with: viewModel)
        viewController.modalPresentationStyle = .overCurrentContext
        watchedMoviesVC?.present(viewController, animated: false)
        viewController.delegate = watchedMoviesVC?.viewModel
    }
    
//     private func sendDataToWatchedMovies(sortingBy: SortingBy) {
//         viewController.delegate = watchedMoviesVC
//     }
    
    private func showReviewWriting(genre: Genre, movie: Movie) {
        let actions = ReviewWritingViewModelActions(goToLandingPage: addDataToWatchedHistory)
        let viewController = dependencies.makeReviewWritingViewController(genre: genre, movie: movie, actions: actions)
        moviesSearchVC?.navigationController?.pushViewController(viewController, animated: true)
        reviewWritingVC = viewController
    }
    
    private func addDataToWatchedHistory() {
        reviewWritingVC?.navigationController?.popToRootViewController(animated: true)
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
