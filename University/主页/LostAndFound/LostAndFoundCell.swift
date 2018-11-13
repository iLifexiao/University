//
//  LostAndFoundCell.swift
//  University
//
//  Created by 肖权 on 2018/11/13.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class LostAndFoundCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var contentLabel: UITextView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupModel(_ lost: LostAndFound) {
        iconImageView.sd_setImage(with: URL(string: baseURL + (lost.imageURL?[0])!), completed: nil)
        titleLabel.text = lost.title
        timeLabel.text = lost.time
        siteLabel.text = lost.site
        contentLabel.text = lost.content
    }

}
