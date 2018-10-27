//
//  CampusFuncCell.swift
//  University
//
//  Created by 肖权 on 2018/10/23.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class CampusFuncCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // image本来就是为nil
    func setupData(_ campus: CampusFuncModel) {
        nameLabel.text = campus.name
        iconImageView.image = campus.icon
    }
}
