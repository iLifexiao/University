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
    
    func setupModel(_ msg: Message, unReadCount: Int) {
        userHeadImageView.sd_setImage(with: URL(string: baseURL + (msg.profilephoto ?? "/image/head/default.png")), completed: nil)
        nameLabel.text = msg.nickname
        contentLabel.text = msg.content
        timeLabel.text = friendDateByUnixTime(msg.createdAt ?? 0)
        
        if unReadCount != 0 {
            newMessageLabel.isHidden = false
            newMessageLabel.text = String(unReadCount)
        } else {
            newMessageLabel.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        userHeadImageView.image = nil
        nameLabel.text = nil
        contentLabel.text = nil
        timeLabel.text = nil
        newMessageLabel.text = nil
    }
}
