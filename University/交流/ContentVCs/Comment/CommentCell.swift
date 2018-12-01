//
//  CommentCell.swift
//  University
//
//  Created by 肖权 on 2018/11/21.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

@objc protocol CommentCellDelegate {
    func commentLike(likeButton: UIButton, likeLabel: UILabel, commentID: String)
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
        headImageView.sd_setImage(with: URL(string: baseURL + (comment.profilephoto ?? "/image/head/default.png")), completed: nil)
        nameLabel.text = comment.nickname
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
            delegate.commentLike(likeButton: sender, likeLabel: likeLabel, commentID: commentID ?? "0")
        }
    }
    
}
