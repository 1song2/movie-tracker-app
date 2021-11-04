//
//  GenreSelectionViewModel.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/03.
//

import Foundation
import RealmSwift

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
    private let realm = try! Realm()
    private let actions: GenreSelectionViewModelActions?
    private var myGenres: Results<Genre>
    
    // MARK: - OUTPUT
    
    let items: [GenreViewModel]
    let screenTitle = NSLocalizedString("카테고리가 무엇인가요?", comment: "")
    
    // MARK: - Init
    
    init(actions: GenreSelectionViewModelActions? = nil) {
        self.actions = actions
        myGenres = realm.objects(Genre.self)
        items = myGenres.map(GenreViewModel.init)
    }
}

// MARK: - INPUT. View event methods

extension DefaultGenreSelectionViewModel {
    func didSelectItem(at index: Int) {
        actions?.showMovieSearchPage(myGenres[index])
    }
}
