//
//  CampusNewsCell.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class CampusNewsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var originalLabel: UILabel!
    @IBOutlet weak var readCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    private var id: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(_ model: CampusNewsModel) {
        self.id = model.id
        titleLabel.text = model.title
        originalLabel.text = model.original
        readCountLabel.text = String(model.readCount) + " 阅读"
        dateLabel.text = model.postDate
        newsImageView.image = model.newsImage
    }
    
}
