//
//  GenreSelectionViewController.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/02.
//

import UIKit
import RxSwift

class GenreSelectionViewController: UITableViewController {
    private let disposeBag = DisposeBag()
    
    static func create() -> GenreSelectionViewController {
        return GenreSelectionViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let genres = [
            "전체", "드라마", "판타지", "서부", "공포", "로맨스", "모험", "스릴러", "느와르", "컬트", "다큐멘터리", "코미디", "가족", "미스터리",
            "전쟁", "애니메이션", "범죄", "뮤지컬", "SF", "액션", "무협", "에로", "서스펜스", "서사", "블랙코미디", "실험", "영화카툰", "영화음악",
            "영화패러디포스터"
        ]
        
        tableView.dataSource = nil
        Observable.just(genres).bind(to: self.tableView.rx.items(cellIdentifier: "Cell",
                                                                 cellType: UITableViewCell.self)) { _, item, cell in
            cell.textLabel?.text = item
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] in
                let viewController = MoviesSearchViewController.create()
                viewController.title = "영화 이름이 무엇인가요?" // viewModel.screenTitle
                viewController.navigationItem.prompt = genres[$0.row]
                self?.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: disposeBag)
    }
}
