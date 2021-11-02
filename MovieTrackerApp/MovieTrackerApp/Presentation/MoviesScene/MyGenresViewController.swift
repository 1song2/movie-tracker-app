//
//  ViewController.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import UIKit
import RxSwift
import RxCocoa

class MoviesViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    static func create() -> MoviesViewController {
        return MoviesViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "나의 영화 노트" // viewModel.screenTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: {
                print("button tapped")
            }).disposed(by: disposeBag)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let genre = ["스릴러", "액션", "로맨스"]
        tableView.dataSource = nil
        Observable.just(genre).bind(to: self.tableView.rx.items(cellIdentifier: "Cell",
                                                                cellType: UITableViewCell.self)) { _, item, cell in
            cell.textLabel?.text = item
            cell.accessoryType = .disclosureIndicator
        }.disposed(by: disposeBag)
    }
}
