//
//  GenreSelectionViewController.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/02.
//

import UIKit
import RxSwift

class GenreSelectionViewController: UITableViewController {
    private var viewModel: GenreSelectionViewModel!
    private let disposeBag = DisposeBag()
    
    static func create(with viewModel: GenreSelectionViewModel) -> GenreSelectionViewController {
        let view = GenreSelectionViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.screenTitle
        navigationItem.largeTitleDisplayMode = .never
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.dataSource = nil
        Observable.just(viewModel.items)
            .bind(to: self.tableView.rx.items(cellIdentifier: "Cell",
                                              cellType: UITableViewCell.self)) { _, item, cell in
                cell.textLabel?.text = item.name
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] in
                self?.viewModel.didSelectItem(at: $0.row)
            }).disposed(by: disposeBag)
    }
}
