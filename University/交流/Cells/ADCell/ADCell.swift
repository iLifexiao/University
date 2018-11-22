//
//  ADCell.swift
//  University
//
//  Created by 肖权 on 2018/10/23.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class ADCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var readLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupModel(_ resource: Resource) {
        iconImageView.sd_setImage(with: URL(string: baseURL + resource.imageURL), completed: nil)
        titleLabel.text = resource.name
        contentLabel.text = resource.introduce
        typeButton.setTitle(resource.type, for: .normal)
        // 排序：阅读、喜欢、评论
        readLabel.text = String(resource.readCount ?? 0) + " 阅读"
        likeLabel.text = String(resource.likeCount ?? 0) + " 喜欢"
        commentLabel.text = String(resource.commentCount ?? 0) + " 评论"
    }
    
    func setTypeColor(_ color: UIColor) {
        typeButton.backgroundColor = color
    }
    
    override func prepareForReuse() {
        iconImageView.image = nil
        titleLabel.text = nil
        contentLabel.text = nil
        typeButton.setTitle("工具", for: .normal)
        readLabel.text = nil
        likeLabel.text = nil
        commentLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
