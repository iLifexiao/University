//
//  SchoolStoreCell.swift
//  University
//
//  Created by 肖权 on 2018/11/14.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class SchoolStoreCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var introduceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupModel(_ store: SchoolStore) {
        iconImageView.sd_setImage(with: URL(string: baseURL + store.imageURL), completed: nil)
        nameLabel.text = store.name
        timeLabel.text = store.time
        typeLabel.text = store.type
        introduceLabel.text = store.content
    }
    
    override func prepareForReuse() {
        iconImageView.image = nil
        nameLabel.text = nil
        timeLabel.text = nil
        typeLabel.text = nil
        introduceLabel.text = nil
    }
}
