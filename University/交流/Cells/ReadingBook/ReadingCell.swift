//
//  ReadingCell.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class ReadingCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var readCountLabel: UILabel!
    @IBOutlet weak var bookPagesLabel: UILabel!
    @IBOutlet weak var bookDetailLabel: UILabel!
    
    private var id: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupData(_ model: ReadingModel) {
        id = model.id
        iconImageView.image = model.icon
        bookNameLabel.text = model.name
        authorLabel.text = model.author
        readCountLabel.text = String(model.readCount) + " 阅读"
        bookPagesLabel.text = String(model.bookPages) + " 页"
        bookDetailLabel.text = model.detail
    }
    
}
