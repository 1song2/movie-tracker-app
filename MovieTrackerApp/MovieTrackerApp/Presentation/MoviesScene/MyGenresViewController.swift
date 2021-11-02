//
//  ViewController.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import UIKit
import RxSwift

class MyGenresViewController: UITableViewController {
    private let disposeBag = DisposeBag()
    
    static func create() -> MyGenresViewController {
        return MyGenresViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "나의 영화 노트" // viewModel.screenTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                let viewController = GenreSelectionViewController.create()
                viewController.title = "카테고리가 무엇인가요?" // viewModel.screenTitle
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: disposeBag)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let genre = ["스릴러", "액션", "로맨스"]
        tableView.dataSource = nil
        Observable.just(genre).bind(to: self.tableView.rx.items(cellIdentifier: "Cell",
                                                                cellType: UITableViewCell.self)) { _, item, cell in
            cell.textLabel?.text = item
            cell.accessoryType = .disclosureIndicator
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] in
                let viewController = WatchedMoviesViewController.create()
                viewController.title = genre[$0.row]
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: disposeBag)
    }
}
