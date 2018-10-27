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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(_ model: ADModel) {
        iconImageView.image = model.icon
        titleLabel.text = model.title
        contentLabel.text = model.content
        typeButton.setTitle(model.type, for: .normal)
    }
    
    func setTypeColor(_ color: UIColor) {
        typeButton.backgroundColor = color
    }
    
    override func prepareForReuse() {
        iconImageView.image = nil
        titleLabel.text = nil
        contentLabel.text = nil
        typeButton.setTitle("工具", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
