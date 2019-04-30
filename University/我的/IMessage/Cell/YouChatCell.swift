//
//  YouChatCell.swift
//  University
//
//  Created by 肖权 on 2018/11/28.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class YouChatCell: UITableViewCell {
    
    
    @IBOutlet weak var userHeadImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupModel(_ msg: Message) {
        userHeadImageView.sd_setImage(with: URL(string: baseURL + (msg.profilephoto ?? "/image/head/default.png")), completed: nil)
        timeLabel.text = friendDateByUnixTime(msg.createdAt ?? 0)
        contentLabel.text = msg.content
    }
    
    override func prepareForReuse() {
        timeLabel.text = nil
        contentLabel.text = nil
    }
    
}
