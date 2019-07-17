//
//  EventDetailViewController.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 17/07/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import UIKit
import RxSwift

class EventDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private let viewModel: EventDetailViewModel
    private let disposeBag = DisposeBag()
    
    init(eventID: String) {
        self.viewModel = EventDetailViewModel(eventID: eventID)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setScrollView()
        bindObservables()
    }
    
    private func setScrollView() {
        scrollView.delegate = self
        scrollView.addSubview(imageView)
    }
    
    private func bindObservables() {
        bindDescription()
        bindImageURL()
    }
    
    private func bindDescription() {
        viewModel.eventDescription.bindInUI({ [weak self] (description) in
            
            self?.descriptionLabel.text = description
            
        }, disposedBy: disposeBag)
    }
    
    private func bindImageURL() {
        viewModel.eventImageURL.bindInUI({ [weak self] (imageURL) in
            
            self?.imageView.loadImage(withURL: imageURL)
            
        }, disposedBy: disposeBag)
    }

}

extension EventDetailViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
}
