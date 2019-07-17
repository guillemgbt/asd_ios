//
//  PreviousAreasViewController.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 07/03/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import UIKit
import PullUpController
import RxSwift
import RxRealm

protocol AreaPresenter: class {
    func areaPresenter(didSelect area: Area)
}

class PreviousAreasViewController: PullUpController {
    
    @IBOutlet weak var topBar: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    weak var presenter: AreaPresenter?
    
    let bag = DisposeBag()
    
    let viewModel: PreviousAreasViewModel = PreviousAreasViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        
        bindView()

        viewModel.fetchAreas()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setUILayout()
    }
    
    private func setTableView() {
        tableView.registerNib(AreaTableViewCell.self)
    }
    
    private func setUILayout() {
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        
        topBar.makeCircular()
    }
    
    
    private func bindView() {
        
        bindTitle()
        bindIsLoading()
        bindAreas()
        bindAreaSelection()
    }
    
    private func bindTitle() {
        
        viewModel.title.bindInUI({ [weak self] (title) in
            
            self?.titleLabel.text = title
            
        }, disposedBy: bag)
    }
    
    private func bindIsLoading() {
        
        viewModel.isLoading.bindInUI({ [weak self] (isLoading) in
            
            isLoading ? self?.activityIndicator.startAnimating() :
                        self?.activityIndicator.stopAnimating()
            
        }, disposedBy: bag)
    }
    
    private func bindAreas() {
        
        Observable.collection(from: viewModel.areas)
            .bind(to: tableView.rx.items) {tableView, row, area in
                
                let cell: AreaTableViewCell = tableView.dequeueReusableCell(for: IndexPath(row: row, section: 0))
                cell.set(with: area)
                return cell
            }
            .disposed(by: bag)
    }
    
    private func bindAreaSelection() {
        self.tableView.delegate = self
    }
    
    

}

extension PreviousAreasViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        presenter?.areaPresenter(didSelect: viewModel.areas[indexPath.row])
    }
}
