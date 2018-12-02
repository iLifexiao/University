//
//  MyLostCell.swift
//  University
//
//  Created by 肖权 on 2018/12/2.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class MyLostCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
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
    
    func setupModel(_ lost: LostAndFound) {
        iconImageView.sd_setImage(with: URL(string: baseURL + (lost.imageURL?[0])!), completed: nil)
        titleLabel.text = lost.title
        timeLabel.text = lost.time
        contentLabel.text = lost.content
    }
    
    override func prepareForReuse() {
        iconImageView.image = nil
        titleLabel.text = nil
        timeLabel.text = nil
        contentLabel.text = nil
    }
    
}
