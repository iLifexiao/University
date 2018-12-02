//
//  MyIdleGoodCell.swift
//  University
//
//  Created by 肖权 on 2018/12/2.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class MyIdleGoodCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupModel(_ idleGood: IdleGood) {
        iconImageView.sd_setImage(with: URL(string: baseURL + (idleGood.imageURLs?.first ?? "/image/idlegoods/default.png")), completed: nil)
        titleLabel.text = idleGood.title
        priceLabel.text = "¥ " + String(idleGood.price)
        originalPriceLabel.text = String(idleGood.originalPrice)
        contentLabel.text = idleGood.content
    }
    
    override func prepareForReuse() {
        iconImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        originalPriceLabel.text = nil
        contentLabel.text = nil
    }
}
