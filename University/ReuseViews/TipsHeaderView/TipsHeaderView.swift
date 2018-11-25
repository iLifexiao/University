//
//  TipsHeaderView.swift
//  University
//
//  Created by 肖权 on 2018/10/23.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class TipsHeaderView: UIView {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setTips(title: String, icon: UIImage? = nil) {
        titleLabel.text = title
        if icon != nil {
            iconImageView.image = icon
        }
    }
}
