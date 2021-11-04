//
//  SortingView.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/02.
//

import UIKit
import RxSwift
import RxCocoa

class SortingView: ContainerView {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: SortingViewModel? {
        didSet {
            commonInit()
        }
    }
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
        commonInit()
    }
    
    required init(with viewModel: SortingViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.viewModel = viewModel
    }
    
    private func loadNib() {
        if let view = Bundle.main.loadNibNamed(String(describing: Self.self),
                                               owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            addSubview(view)
        }
    }
    
    private func commonInit() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.dataSource = nil
        tableView.isScrollEnabled = false
        
        Observable.just(viewModel?.items ?? [])
            .bind(to: tableView.rx.items(cellIdentifier: "Cell",
                                         cellType: UITableViewCell.self)) { _, item, cell in
                cell.textLabel?.text = item.title
                cell.selectionStyle = .none
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] in
                self?.viewModel?.didSelectItem(at: $0.row)
                self?.tableView.cellForRow(at: $0)?.accessoryType = .checkmark
            }).disposed(by: disposeBag)
        
        tableView.rx.itemDeselected
            .subscribe(onNext: { [weak self] in
                self?.tableView.cellForRow(at: $0)?.accessoryType = .none
            }).disposed(by: disposeBag)
    }
}
