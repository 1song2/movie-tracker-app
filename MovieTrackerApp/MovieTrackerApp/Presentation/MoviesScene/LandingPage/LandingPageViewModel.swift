//
//  LandingPageViewModel.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/02.
//

import Foundation

struct LandingPageViewModelActions {
    let showGenreSelection: () -> Void
    let showWatchlist: (Genre) -> Void
}

protocol LandingPageViewModelInput {
    func didSelectGenre(at index: Int)
    func didAddNewData()
}

protocol LandingPageViewModelOutput {
    var items: [GenreViewModel] { get }
    var screenTitle: String { get }
}

protocol LandingPageViewModel: LandingPageViewModelInput, LandingPageViewModelOutput {}

final class DefaultLandingPageViewModel: LandingPageViewModel {
    private let actions: LandingPageViewModelActions?
    private var myGenres: [Genre] = []
    
    // MARK: - OUTPUT

    let items: [GenreViewModel]
    let screenTitle = NSLocalizedString("나의 영화 노트", comment: "")
    
    // MARK: - Init
    
    init(actions: LandingPageViewModelActions? = nil) {
        self.actions = actions
        items = myGenres.map(GenreViewModel.init)
    }
}

// MARK: - INPUT. View event methods

extension DefaultLandingPageViewModel {
    func didSelectGenre(at index: Int) {
        actions?.showWatchlist(myGenres[index])
    }
    
    func didAddNewData() {
        actions?.showGenreSelection()
    }
}
