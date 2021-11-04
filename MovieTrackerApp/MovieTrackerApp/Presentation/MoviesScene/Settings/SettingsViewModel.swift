//
//  SettingsViewModel.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/04.
//

import Foundation
import RxSwift

struct SettingsViewModelActions {
    let showAddGenreModal: () -> Void
}

protocol SettingsViewModelInput {
    func didAddNewGenre()
}

protocol SettingsViewModelOutput {
    var items: BehaviorSubject<[GenreViewModel]> { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
}

protocol SettingsViewModel: SettingsViewModelInput, SettingsViewModelOutput {}

final class DefaultSettingsViewModel: SettingsViewModel {
    private let actions: SettingsViewModelActions?
    private var myGenres: [Genre] = []
    
    // MARK: - OUTPUT

    let items: BehaviorSubject<[GenreViewModel]> = BehaviorSubject<[GenreViewModel]>(value: [])
    let screenTitle = NSLocalizedString("장르 관리", comment: "")
    let emptyDataTitle = NSLocalizedString("카테고리를 추가해주세요.", comment: "")
    
    // MARK: - Init
    
    init(actions: SettingsViewModelActions? = nil) {
        self.actions = actions
        items.onNext(myGenres.map(GenreViewModel.init))
    }
}

// MARK: - INPUT. View event methods

extension DefaultSettingsViewModel {
    func didAddNewGenre() {
        actions?.showAddGenreModal()
    }
}
