//
//  EventTableViewCell.swift
//  ASD
//
//  Created by Guillem Budia Tirado on 17/03/2019.
//  Copyright © 2019 Guillem Budia Tirado. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell, NibLoadableView {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var auxLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func set(with event: Event) {
        eventImageView.loadImage(withURL: event.getImageURL())
        titleLabel.text = event.getEntityDescription()
        auxLabel.text = "\(event.created)"
    }

   
}
