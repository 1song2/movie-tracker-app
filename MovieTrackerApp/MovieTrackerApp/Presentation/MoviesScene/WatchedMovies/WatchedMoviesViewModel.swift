//
//  WatchedMoviesViewModel.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/04.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm
import RxRelay

struct WatchedMoviesViewModelActions {
    let showItemDetails: (Item) -> Void
    let showSortingModal: (SortingBy?) -> Void
}

protocol WatchedMoviesViewModelInput {
    func didSelectItem(at index: Int)
    func didTapSortingButton(sortingBy: SortingBy?)
}

protocol WatchedMoviesViewModelOutput {
    var items: Observable<Results<Item>> { get }
    var screenTitle: String { get }
    var selectedSortingBy: BehaviorRelay<SortingBy> { get }
}

protocol WatchedMoviesViewModel: WatchedMoviesViewModelInput, WatchedMoviesViewModelOutput, SortingModalDelegate {}

final class DefaultWatchedMoviesViewModel: WatchedMoviesViewModel {
    private let realm = try! Realm()
    private let actions: WatchedMoviesViewModelActions?
    private var watchedMoviesLog: Results<Item>
    private var selectedGenre: Genre
    
    // MARK: - OUTPUT
    
    let items: Observable<Results<Item>>
    let screenTitle: String
    var selectedSortingBy: BehaviorRelay<SortingBy> = BehaviorRelay<SortingBy>(value: SortingBy(title: "기록 생성 순",
                                                                                                keyPath: "recordedOn"))
    
    // MARK: - Init
    
    init(genre: Genre,
         actions: WatchedMoviesViewModelActions? = nil) {
        self.actions = actions
        self.screenTitle = genre.title
        selectedGenre = genre
        watchedMoviesLog = selectedGenre.items.sorted(byKeyPath: "recordedOn", ascending: true)
        items = Observable.collection(from: watchedMoviesLog)
    }
    
    func dismissModal(sortingBy: SortingBy) {
        selectedSortingBy.accept(sortingBy)
    }
}

// MARK: - INPUT. View event methods

extension DefaultWatchedMoviesViewModel {
    func didSelectItem(at index: Int) {
        actions?.showItemDetails(watchedMoviesLog[index])
    }
    
    func didTapSortingButton(sortingBy: SortingBy?) {
        actions?.showSortingModal(sortingBy)
    }
}
