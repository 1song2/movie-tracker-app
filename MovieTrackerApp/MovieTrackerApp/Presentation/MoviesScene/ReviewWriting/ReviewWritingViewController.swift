//
//  ReviewWritingViewController.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/02.
//

import UIKit
import RxSwift

class ReviewWritingViewController: UIViewController, StoryboardInstantiable {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    static func create() -> ReviewWritingViewController {
        let view = ReviewWritingViewController.instantiateViewController()
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
                self?.navigationController?.popToRootViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func setupView() {
        doneButton.layer.cornerRadius = 15.0
        doneButton.clipsToBounds = true
        textView.layer.cornerRadius = 16.0
        textView.clipsToBounds = true
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
