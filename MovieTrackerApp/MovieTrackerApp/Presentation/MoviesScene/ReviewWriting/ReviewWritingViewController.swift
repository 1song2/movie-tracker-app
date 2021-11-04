//
//  ReviewWritingViewController.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/02.
//

import UIKit
import RxSwift

class ReviewWritingViewController: UIViewController, StoryboardInstantiable {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    private var viewModel: ReviewWritingViewModel!
    private let disposeBag = DisposeBag()
    
    static func create(with viewModel: ReviewWritingViewModel) -> ReviewWritingViewController {
        let view = ReviewWritingViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        textView.rx.text.orEmpty
            .map { $0.count > 0 }
            .share(replay: 1)
            .bind(to: doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.didTapDoneButton(watchedOn: self?.datePicker.date, notes: self?.textView.text)
            }).disposed(by: disposeBag)
    }
    
    private func setupView() {
        title = viewModel.screenTitle
        doneButton.layer.cornerRadius = 15.0
        doneButton.clipsToBounds = true
        textView.layer.cornerRadius = 16.0
        textView.clipsToBounds = true
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
