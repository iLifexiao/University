//
//  IdleGoodCell.swift
//  University
//
//  Created by 肖权 on 2018/11/14.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

@objc protocol IdleGoodCellDelegate {
    func sendMessageTo(userID: Int)
}

class IdleGoodCell: UICollectionViewCell {
    
    
    @IBOutlet weak var userHeadButton: UIButton!    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sendTimeLabel: UILabel!    

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UITextView!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var originPriceLabel: UILabel!
    
    private var userID = 0
    weak var delegate: IdleGoodCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupModel(_ idleGood: IdleGood) {
        userID = idleGood.userID
        userHeadButton.setImage(UIImage.fromURL(baseURL + (idleGood.profilephoto ?? "/image/head/default.png")), for: .normal)
        nameLabel.text = idleGood.nickname
        sendTimeLabel.text = unixTime2StringDate(idleGood.createdAt ?? 0)
        
        iconImageView.sd_setImage(with: URL(string: baseURL + (idleGood.imageURLs?[0])!), completed: nil)
        titleLabel.text = idleGood.title
        contentLabel.text = idleGood.content
        contentLabel.layoutManager.allowsNonContiguousLayout = false
        typeButton.setTitle(idleGood.type, for: .normal)
        priceLabel.text = String(Int(idleGood.price))
        originPriceLabel.text = String(Int(idleGood.originalPrice))
    }
    
    override func prepareForReuse() {
        userHeadButton.setImage(nil, for: .normal)
        nameLabel.text = nil
        sendTimeLabel.text = nil
        iconImageView.image = nil
        titleLabel.text = nil
        contentLabel.text = nil
        typeButton.setTitle("暂无", for: .normal)
        priceLabel.text = nil
        originPriceLabel.text = nil
    }
    
    @IBAction func userHeadPress(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.sendMessageTo(userID: userID)
        }
    }
}
