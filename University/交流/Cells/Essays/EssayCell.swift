//
//  EssayCell.swift
//  University
//
//  Created by 肖权 on 2018/10/25.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

@objc protocol EssayCellDelegate {
    func showMoreInfoAboutEssay(_ id: String?)
    func showSameTypeEssay(_ type: String?)
}

class EssayCell: UITableViewCell {

    @IBOutlet weak var userHeadImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var essayPostTimeLabel: UILabel!
    @IBOutlet weak var essayTypeButton: UIButton!
    @IBOutlet weak var essayTitleLabel: UILabel!
    @IBOutlet weak var essayContentLabel: UILabel!
    @IBOutlet weak var essaySeeCountLabel: UILabel!
    @IBOutlet weak var essayLikeCountLabel: UILabel!
    @IBOutlet weak var essayCommitCountLabel: UILabel!
    
    // 保存文章的唯一标识
    private var essayID: String?
    
    weak var delegate: EssayCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(_ model: EssayModel) {
        essayID = model.essayID
        
        userHeadImageView.image = model.userHeadImage
        userNameLabel.text = model.userName
        essayPostTimeLabel.text = model.postTime
        essayTypeButton.setTitle(model.type, for: .normal)
        essayTitleLabel.text = model.title
        essayContentLabel.text = model.content
        essaySeeCountLabel.text = String(model.readCount)
        essayLikeCountLabel.text = String(model.likeCount)
        essayCommitCountLabel.text = String(model.commitCount)
        
    }
    
    // show more info about essay
    // 如何标识文章的唯一性（id）
    @IBAction func aboutEssayPress(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.showMoreInfoAboutEssay(essayID)
        }
    }
    
    // show the same type essay
    @IBAction func showSameTypeEssay(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.showSameTypeEssay(sender.currentTitle)
        }
    }
    
    
}
