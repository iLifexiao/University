//
//  LostAndFoundCell.swift
//  University
//
//  Created by 肖权 on 2018/11/13.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

@objc protocol LostAndFoundCellDelegate {
    func sendMessageTo(userID: Int)
}

class LostAndFoundCell: UICollectionViewCell {

    @IBOutlet weak var userHeadButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sendTimeLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var contentLabel: UITextView!
    
    private var userID = 0
    weak var delegate: LostAndFoundCellDelegate?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupModel(_ lost: LostAndFound) {
        userID = lost.userID
        userHeadButton.setImage(UIImage.fromURL(baseURL + (lost.profilephoto ?? "/image/head/default.png")), for: .normal)
        nameLabel.text = lost.nickname
        sendTimeLabel.text = friendDateByUnixTime(lost.createdAt ?? 0)
        
        iconImageView.sd_setImage(with: URL(string: baseURL + (lost.imageURL?[0])!), completed: nil)
        titleLabel.text = lost.title
        timeLabel.text = lost.time
        siteLabel.text = lost.site
        contentLabel.text = lost.content
        contentLabel.layoutManager.allowsNonContiguousLayout = false
    }
    
    override func prepareForReuse() {
        userHeadButton.setImage(nil, for: .normal)
        nameLabel.text = nil
        sendTimeLabel.text = nil
        iconImageView.image = nil
        titleLabel.text = nil
        timeLabel.text = nil
        siteLabel.text = nil
        contentLabel.text = nil
    }
    
    
    @IBAction func userHeadPress(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.sendMessageTo(userID: userID)
        }
    }
}
