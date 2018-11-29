//
//  IMCell.swift
//  University
//
//  Created by 肖权 on 2018/11/28.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class IMCell: UITableViewCell {
    
    @IBOutlet weak var userHeadImageView: UIImageView!
    @IBOutlet weak var newMessageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupModel(_ msg: Message) {
        userHeadImageView.image = #imageLiteral(resourceName: "addressList")
        nameLabel.text = String(msg.friendID)
        contentLabel.text = msg.content
        timeLabel.text = unixTime2StringDate(msg.createdAt ?? 0)
    }
    
    override func prepareForReuse() {
        userHeadImageView.image = nil
        nameLabel.text = nil
        contentLabel.text = nil
        timeLabel.text = nil
    }
}
