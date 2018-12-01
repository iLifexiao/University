//
//  AnswerCell.swift
//  University
//
//  Created by 肖权 on 2018/11/23.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class AnswerCell: UITableViewCell {
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var readCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    private var id: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupModel(_ answer: Answer) {
        id = String(answer.id ?? 0)
        headImageView.sd_setImage(with: URL(string: baseURL + (answer.profilephoto ?? "/image/head/default.png")), completed: nil)
        nameLabel.text = answer.nickname
        timeLabel.text = unixTime2StringDate(answer.createdAt ?? 0)
        answerLabel.text = answer.content
        readCountLabel.text = String(answer.readCount ?? 0) + " 阅读"
        likeCountLabel.text = String(answer.likeCount ?? 0) + " 喜欢"
        commentCountLabel.text = String(answer.commentCount ?? 0) + " 评论"
    }
    
    override func prepareForReuse() {
        headImageView.image = nil
        nameLabel.text = nil
        timeLabel.text = nil
        answerLabel.text = nil
        readCountLabel.text = nil
        likeCountLabel.text = nil
        commentCountLabel.text = nil
    }
    
}
