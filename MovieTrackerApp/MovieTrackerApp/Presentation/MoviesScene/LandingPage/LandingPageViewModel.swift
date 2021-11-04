//
//  LandingPageViewModel.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/02.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm

struct LandingPageViewModelActions {
    let showGenreSelection: () -> Void
    let showWatchlist: (Genre) -> Void
}

protocol LandingPageViewModelInput {
    func didSelectGenre(at index: Int)
    func didAddNewData()
}

protocol LandingPageViewModelOutput {
    var items: Observable<Results<Genre>> { get }
    var screenTitle: String { get }
}

protocol LandingPageViewModel: LandingPageViewModelInput, LandingPageViewModelOutput {}

final class DefaultLandingPageViewModel: LandingPageViewModel {
    private let realm = try! Realm()
    private let actions: LandingPageViewModelActions?
    private var myGenres: Results<Genre>
    
    // MARK: - OUTPUT

    let items: Observable<Results<Genre>>
    let screenTitle = NSLocalizedString("나의 영화 노트", comment: "")
    
    // MARK: - Init
    
    init(actions: LandingPageViewModelActions? = nil) {
        self.actions = actions
        myGenres = realm.objects(Genre.self)
        items = Observable.collection(from: myGenres)
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
