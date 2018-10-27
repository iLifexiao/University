//
//  CountdownCell.swift
//  University
//
//  Created by 肖权 on 2018/10/27.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class CountdownCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupData(_ model: CountdownModel) {
        dateLabel.text = model.date
        countdownLabel.text = model.event + " " + String(model.day) + " 天"
    }
}
