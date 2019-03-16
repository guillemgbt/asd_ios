//
//  AreaTableViewCell.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 15/03/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import UIKit

class AreaTableViewCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var auxLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func set(with area: Area) {
        self.titleLabel.text = area.getTitle()
        self.auxLabel.text = area.getLoactionDescription()
    }
    
}
