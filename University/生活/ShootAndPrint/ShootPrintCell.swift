//
//  ShootPrintCell.swift
//  University
//
//  Created by 肖权 on 2018/11/14.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class ShootPrintCell: UITableViewCell {
    
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!    
    @IBOutlet weak var introduceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupModel(_ shop: ShootAndPrint) {
        iconImageView.sd_setImage(with: URL(string: baseURL + shop.imageURL), completed: nil)
        nameLabel.text = shop.name
        introduceLabel.text = shop.introduce
    }
    
    override func prepareForReuse() {
        iconImageView.image = nil
        nameLabel.text = nil
        introduceLabel.text = nil
    }
    
}
