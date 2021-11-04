//
//  SortingViewModel.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/04.
//

import Foundation
import RxSwift

struct SortingViewModelActions {
    let sendDataToWatchedMovies: (SortingBy) -> Void
}

protocol SortingViewModelInput {
    func didSelectItem(at index: Int)
}

protocol SortingViewModelOutput {
    var items: [SortingBy] { get }
    var selectingSortingBy: SortingBy { get }
}

protocol SortingViewModel: SortingViewModelInput, SortingViewModelOutput {}

final class DefaultSortingViewModel: SortingViewModel {
    private let actions: SortingViewModelActions?
    
    // MARK: - OUTPUT
    
    var items = [
        SortingBy(title: "기록 생성 순", keyPath: "recordedOn"),
        SortingBy(title: "영화 본 날짜 순", keyPath: "watchedOn"),
        SortingBy(title: "개봉년도 순", keyPath: "releaseYear")
    ]
    var selectingSortingBy = SortingBy(title: "기록 생성 순", keyPath: "recordedOn")
    
    // MARK: - Init
    
    init(sortingBy: SortingBy?,
         actions: SortingViewModelActions? = nil) {
        self.actions = actions
        if let sortingBy = sortingBy {
            self.selectingSortingBy = sortingBy
        }
    }
}

// MARK: - INPUT. View event methods

extension DefaultSortingViewModel {
    func didSelectItem(at index: Int) {
        selectingSortingBy = items[index]
        actions?.sendDataToWatchedMovies(selectingSortingBy)
    }
}

struct SortingBy {
    let title: String
    let keyPath: String
}
