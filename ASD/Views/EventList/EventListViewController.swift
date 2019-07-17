//
//  EventListViewController.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 17/03/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import UIKit
import RxSwift
import RxRealm

class EventListViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var controlsStackView: UIStackView!
    
    let viewModel: EventListViewModel
    let bag = DisposeBag()
    
    init(areaID: String) {
        self.viewModel = EventListViewModel(areaID: areaID)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        
        setNavigatoinItems()
        
        bindView()
        
        viewModel.fetchEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar()
    }
    
    
    @IBAction func scanButtonAction(_ sender: Any) {
        
        viewModel.handleScanAction()
    }
    
    func setNavigatoinItems() {
        
        let item = UIBarButtonItem(customView: controlsStackView)
                
        self.navigationItem.setRightBarButton(item, animated: false)
    }
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setTableView() {
        tableView.registerNib(EventTableViewCell.self)
        
        tableView.rowHeight = UITableView.automaticDimension

        setRefreshControl()
    }
    
    private func setRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self,
                                 action: #selector(EventListViewController.onRefreshAction),
                                 for: .valueChanged)
        
        self.tableView.refreshControl = refreshControl
    }
    
    @objc func onRefreshAction() {
        viewModel.handleRefresh()
    }
    
    private func bindView() {
        
        bindTitle()
        bindIsLoading()
        bindEvents()
        bindEventSelection()
        bindButtonText()
        bindButtonEnabled()
    }
    
    private func bindTitle() {
        
        viewModel.title.bindInUI({ [weak self] (title) in
            
            self?.title = title
            
        }, disposedBy: bag)
    }
    
    private func bindButtonText() {
        
        viewModel.buttonText.bindInUI({ [weak self] (text) in
            
            self?.scanButton.setTitle(text, for: .normal)
            
        }, disposedBy: bag)
    }
    
    private func bindButtonEnabled() {
        
        viewModel.scanButtonEnabled.bindInUI({ [weak self] (enabled) in
            
            self?.scanButton.isEnabled = enabled
            self?.scanButton.setTitleColor(enabled ? UIColor.blue : UIColor.lightGray, for: .normal)
            
        }, disposedBy: bag)
    }
    
    
    private func bindIsLoading() {
        viewModel.isLoading.bindInUI({ [weak self] (isLoading) in
            
            isLoading ? self?.activityIndicator.startAnimating()
                : self?.activityIndicator.stopAnimating()
            
            if !isLoading && self?.tableView.refreshControl?.isRefreshing ?? false {
                self?.tableView.refreshControl?.endRefreshing()
            }
            
        }, disposedBy: bag)
    }
    
    private func bindEvents() {
        
        Observable.collection( from: viewModel.events )
            .bind(to: tableView.rx.items) {tableView, row, event in
                
                let cell: EventTableViewCell = tableView.dequeueReusableCell(for: IndexPath(row: row, section: 0))
                cell.set(with: event)
                return cell
            }
            .disposed(by: bag)
    }
    
    private func bindEventSelection() {
       self.tableView.delegate = self
    }

}

extension EventListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventID = self.viewModel.events[indexPath.row].getPK()
        self.navigationController?.pushViewController(EventDetailViewController(eventID: eventID), animated: true)
    }
    
}
