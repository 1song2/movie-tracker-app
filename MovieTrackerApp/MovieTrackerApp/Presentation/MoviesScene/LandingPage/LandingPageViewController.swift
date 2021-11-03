//
//  ViewController.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import UIKit
import RxSwift

class LandingPageViewController: UITableViewController {
    private var viewModel: LandingPageViewModel!
    private let disposeBag = DisposeBag()
    
    static func create(with viewModel: LandingPageViewModel) -> LandingPageViewController {
        let view = LandingPageViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.screenTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.didAddNewData()
            }).disposed(by: disposeBag)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.dataSource = nil
        Observable.just(viewModel.items)
            .bind(to: self.tableView.rx.items(cellIdentifier: "Cell",
                                              cellType: UITableViewCell.self)) { _, item, cell in
                cell.textLabel?.text = item.name
                cell.accessoryType = .disclosureIndicator
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] in
                self?.viewModel.didSelectGenre(at: $0.row)
            }).disposed(by: disposeBag)
    }
}
