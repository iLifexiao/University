//
//  DateHeaderView.swift
//  University
//
//  Created by 肖权 on 2018/10/23.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class DateHeaderView: UIView {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupTitle(icon: UIImage?, title: String) {
        iconImageView.image = icon
        titleLabel.text = title
    }
    
    func setWeek(_ week: String) {
        weekLabel.text = week
    }
    
    func setDate(_ date: String) {
        dateLabel.text = date
    }
}
