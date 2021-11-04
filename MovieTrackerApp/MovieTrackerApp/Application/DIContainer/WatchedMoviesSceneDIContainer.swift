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
    
    // MARK: - Landing Page
    func makeLandingPageViewController(actions: LandingPageViewModelActions) -> LandingPageViewController {
        return LandingPageViewController.create(with: makeLandingPageViewModel(actions: actions))
    }
    
    func makeLandingPageViewModel(actions: LandingPageViewModelActions) -> LandingPageViewModel {
        return DefaultLandingPageViewModel(actions: actions)
    }
    
    // MARK: - Settings
    func makeSettingsViewController(actions: SettingsViewModelActions) -> SettingsViewController {
        return SettingsViewController.create(with: makeSettingsViewModel(actions: actions))
    }
    
    func makeSettingsViewModel(actions: SettingsViewModelActions) -> SettingsViewModel {
        return DefaultSettingsViewModel(actions: actions)
    }
    
    // MARK: - Genre Selection
    func makeGenreSelectionViewController(actions: GenreSelectionViewModelActions) -> GenreSelectionViewController {
        return GenreSelectionViewController.create(with: makeGenreSelectionViewModel(actions: actions))
    }
    
    func makeGenreSelectionViewModel(actions: GenreSelectionViewModelActions) -> GenreSelectionViewModel {
        return DefaultGenreSelectionViewModel(actions: actions)
    }
    
    // MARK: - Movies Search
    func makeMoviesSearchViewController(genre: Genre,
                                        actions: MoviesSearchViewModelActions) -> MoviesSearchViewController {
        return MoviesSearchViewController.create(with: makeMoviesSearchViewModel(genre: genre, actions: actions))
    }
    
    func makeMoviesSearchViewModel(genre: Genre,
                                   actions: MoviesSearchViewModelActions) -> MoviesSearchViewModel {
        return DefaultMoviesSearchViewModel(genre: genre, apiClient: dependencies.apiClient, actions: actions)
    }
    
    // MARK: - Review Writing
    func makeReviewWritingViewController(genre: Genre,
                                         movie: Movie,
                                         actions: ReviewWritingViewModelActions) -> ReviewWritingViewController {
        return ReviewWritingViewController.create(with: makeReviewWritingViewModel(genre: genre,
                                                                                   movie: movie,
                                                                                   actions: actions))
    }
    
    func makeReviewWritingViewModel(genre: Genre,
                                    movie: Movie,
                                    actions: ReviewWritingViewModelActions) -> ReviewWritingViewModel {
        return DefaultReviewWritingViewModel(genre: genre, movie: movie, actions: actions)
    }
    
    // MARK: - Watched Movies
    func makeWatchedMoviesViewController(genre: Genre,
                                         actions: WatchedMoviesViewModelActions) -> WatchedMoviesViewController {
        return WatchedMoviesViewController.create(with: makeWatchedMoviesViewModel(genre: genre, actions: actions))
    }
    
    func makeWatchedMoviesViewModel(genre: Genre,
                                    actions: WatchedMoviesViewModelActions) -> WatchedMoviesViewModel {
        return DefaultWatchedMoviesViewModel(genre: genre, actions: actions)
    }
    
    // MARK: - Flow Coordinators
    func makeWatchedMoviesFlowCoordinator(tabBarController: UITabBarController) -> WatchedMoviesFlowCoordinator {
        return WatchedMoviesFlowCoordinator(tabBarController: tabBarController,
                                            dependencies: self)
    }
}

extension WatchedMoviesSceneDIContainer: WatchedMoviesFlowCoordinatorDependencies {}
