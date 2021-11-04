//
//  SettingsViewModel.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/04.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm

struct SettingsViewModelActions {
    let showAddGenreAlert: (UIAlertController) -> Void
}

protocol SettingsViewModelInput {
    func didAddNewGenre()
}

protocol SettingsViewModelOutput {
    var items: Observable<Results<Genre>> { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
}

protocol SettingsViewModel: SettingsViewModelInput, SettingsViewModelOutput {}

final class DefaultSettingsViewModel: SettingsViewModel {
    private let realm = try! Realm()
    private let actions: SettingsViewModelActions?
    private var myGenres: Results<Genre>
    
    // MARK: - OUTPUT

    let items: Observable<Results<Genre>>
    let screenTitle = NSLocalizedString("장르 관리", comment: "")
    let emptyDataTitle = NSLocalizedString("카테고리를 추가해주세요.", comment: "")
    
    // MARK: - Init
    
    init(actions: SettingsViewModelActions? = nil) {
        self.actions = actions
        myGenres = realm.objects(Genre.self)
        items = Observable.collection(from: myGenres)
    }
}

// MARK: - INPUT. View event methods

extension DefaultSettingsViewModel {
    func didAddNewGenre() {
        var textField = UITextField()
        let alert = UIAlertController(title: "카테고리 추가", message: nil, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "완료", style: .default) { [weak self] _ in
            let newCategory = Genre()
            newCategory.title = textField.text ?? ""
            do {
                try self?.realm.write {
                    self?.realm.add(newCategory)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "카테고리 이름을 입력하세요."
            textField = alertTextField
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        actions?.showAddGenreAlert(alert)
    }
}
