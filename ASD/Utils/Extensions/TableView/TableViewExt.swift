//
//  TableViewExt.swift
//  MonkingMe
//
//  Created by Guillem Budia Tirado on 11/06/2018.
//  Copyright © 2018 Guillem Budia Tirado. All rights reserved.
//

import RxRealm


//RxRealm
extension UITableView {
    func applyChangeset(_ changes: RealmChangeset, forSection section: Int = 0) {
        beginUpdates()
        deleteRows(at: changes.deleted.map { IndexPath(row: $0, section: section) }, with: .automatic)
        insertRows(at: changes.inserted.map { IndexPath(row: $0, section: section) }, with: .automatic)
        reloadRows(at: changes.updated.map { IndexPath(row: $0, section: section) }, with: .automatic)
        endUpdates()
    }
    
    func applyChangesetOrReload(_ changes: RealmChangeset?, forSection section: Int = 0) {
        if let changes = changes {
            applyChangeset(changes, forSection: section)
        } else {
            reloadData()
        }
    }
}

extension UITableView {
    
    func registerNib<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        print(T.nibName)
        register(UINib(nibName: T.nibName, bundle: nil), forCellReuseIdentifier: T.nibName)
    }
        
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableView, T: NibLoadableView {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.nibName, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
}
