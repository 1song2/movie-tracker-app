//
//  ReviewWritingViewModel.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/03.
//

import Foundation

struct ReviewWritingViewModelActions {
    let addDataToWatchedHistory: (WatchedMovieData) -> Void
}

protocol ReviewWritingViewModelInput {
    func didTapDoneButton(watchedOn: Date?, notes: String?)
}

protocol ReviewWritingViewModelOutput {
    var screenTitle: String { get }
}

protocol ReviewWritingViewModel: ReviewWritingViewModelInput, ReviewWritingViewModelOutput {}

final class DefaultReviewWritingViewModel: ReviewWritingViewModel {
    private let actions: ReviewWritingViewModelActions?
    private var movie: Movie
    
    // MARK: - OUTPUT
    
    let screenTitle: String
    
    // MARK: - Init
    
    init(movie: Movie,
         actions: ReviewWritingViewModelActions? = nil) {
        self.screenTitle = movie.title ?? ""
        self.movie = movie
        self.actions = actions
    }
}

// MARK: - INPUT. View event methods

extension DefaultReviewWritingViewModel {
    func didTapDoneButton(watchedOn: Date?, notes: String?) {
        actions?.addDataToWatchedHistory(WatchedMovieData(movie: movie,
                                                          watchedOn: watchedOn ?? Date(),
                                                          notes: notes ?? ""))
    }
}

struct WatchedMovieData {
    let movie: Movie
    let watchedOn: Date
    let notes: String
}
