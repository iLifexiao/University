//
//  IdleGoodCell.swift
//  University
//
//  Created by 肖权 on 2018/11/14.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class IdleGoodCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UITextView!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var originPriceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupModel(_ idleGood: IdleGood) {
        iconImageView.sd_setImage(with: URL(string: baseURL + (idleGood.imageURLs?[0])!), completed: nil)
        titleLabel.text = idleGood.title
        contentLabel.text = idleGood.content
        typeButton.setTitle(idleGood.type, for: .normal)
        priceLabel.text = String(idleGood.price)
        originPriceLabel.text = String(idleGood.originalPrice)
    }
    
    override func prepareForReuse() {
        iconImageView.image = nil
        titleLabel.text = nil
        contentLabel.text = nil
        typeButton.setTitle("暂无", for: .normal)
        priceLabel.text = nil
        originPriceLabel.text = nil
    }

}
