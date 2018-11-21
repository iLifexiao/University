//
//  CommentCell.swift
//  University
//
//  Created by 肖权 on 2018/11/21.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

@objc protocol CommentCellDelegate {
    func commentLike(likeButton: UIButton, commentLabel: UILabel, commitID: String)
}

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!    
    
    weak var delegate: CommentCellDelegate?
    var commentID: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupModel(_ comment: Comment) {
        commentID = String(comment.id ?? 0)
        headImageView.image = UIImage(named: "userHead")
        nameLabel.text = "琉璃"
        timeLabel.text = unixTime2StringDate(comment.createdAt ?? 0)
        likeLabel.text = String(comment.likeCount ?? 0)
        commentLabel.text = String(comment.content)
    }
    
    override func prepareForReuse() {
        headImageView.image = nil
        nameLabel.text = nil
        timeLabel.text = nil
        likeLabel.text = nil
        commentLabel.text = nil
    }
    
    @IBAction func likeBtnPress(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.commentLike(likeButton: sender, commentLabel: commentLabel, commitID: commentID ?? "0")
        }
    }
    
}
