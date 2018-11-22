//
//  ExperienceCell.swift
//  University
//
//  Created by 肖权 on 2018/11/14.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class ExperienceCell: UITableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupModel(_ exp: Experience) {
        headImageView.image = UIImage(named: "userHead")
        nameLabel.text = "雨后"
        timeLabel.text = unixTime2StringDate(exp.createdAt ?? 0, format: "yyyy-MM-dd")
        titleLabel.text = exp.title
        contentLabel.text = exp.content
        readLabel.text = String(exp.readCount ?? 0) + " 阅读"
        likeLabel.text = String(exp.likeCount ?? 0) + " 喜欢"
        commentLabel.text = String(exp.commentCount ?? 0) + " 评论"
        typeLabel.text = exp.type
    }
    
    override func prepareForReuse() {
        headImageView.image = nil
        nameLabel.text = nil
        timeLabel.text = nil
        titleLabel.text = nil
        contentLabel.text = nil
        commentLabel.text = nil
        likeLabel.text = nil
        typeLabel.text = nil
    }    
}
