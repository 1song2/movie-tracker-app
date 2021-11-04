//
//  GenreSelectionViewModel.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/03.
//

import Foundation

struct GenreSelectionViewModelActions {
    let showMovieSearchPage: (Genre) -> Void
}

protocol GenreSelectionViewModelInput {
    func didSelectItem(at index: Int)
}

protocol GenreSelectionViewModelOutput {
    var items: [GenreViewModel] { get }
    var screenTitle: String { get }
}

protocol GenreSelectionViewModel: GenreSelectionViewModelInput, GenreSelectionViewModelOutput {}

final class DefaultGenreSelectionViewModel: GenreSelectionViewModel {
    private let actions: GenreSelectionViewModelActions?
    private var genres: [Genre] = []
    
    // MARK: - OUTPUT
    
    let items: [GenreViewModel]
    let screenTitle = NSLocalizedString("카테고리가 무엇인가요?", comment: "")
    
    // MARK: - Init
    
    init(actions: GenreSelectionViewModelActions? = nil) {
        self.actions = actions
        items = genres.map(GenreViewModel.init)
    }
}

// MARK: - INPUT. View event methods

extension DefaultGenreSelectionViewModel {
    func didSelectItem(at index: Int) {
        actions?.showMovieSearchPage(genres[index])
    }
}
