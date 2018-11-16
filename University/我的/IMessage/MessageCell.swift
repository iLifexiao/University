//
//  MessageCell.swift
//  University
//
//  Created by 肖权 on 2018/11/16.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupModel(_ message: Message) {
//        headImageView.sd_setImage(with: URL(string: baseURL + message.imageURL), completed: nil)
        headImageView.image = UIImage(named: "userHead")
        userNameLabel.text = "雨后"
        contentLabel.text = message.content
        timeLabel.text = unixTime2StringDate(message.createdAt ?? 0, format: "yyyy-MM-dd")
    }
    
}
