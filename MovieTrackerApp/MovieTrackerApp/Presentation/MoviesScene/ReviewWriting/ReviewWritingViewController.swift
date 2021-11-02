//
//  ReviewWritingViewController.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/02.
//

import UIKit

class ReviewWritingViewController: UIViewController, StoryboardInstantiable {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    static func create() -> ReviewWritingViewController {
        let view = ReviewWritingViewController.instantiateViewController()
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
