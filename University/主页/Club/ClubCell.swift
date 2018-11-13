//
//  ClubCell.swift
//  University
//
//  Created by 肖权 on 2018/11/13.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class ClubCell: UITableViewCell {

    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupModel(_ club: Club) {
        iconImageView.sd_setImage(with: URL(string: baseURL + club.imageURL), completed: nil)
        nameLabel.text = club.name
        typeLabel.text = club.type
        timeLabel.text = club.time
        if club.rank == "院" {
            rankLabel.backgroundColor = .blue
        } else {
            rankLabel.backgroundColor = XQColor(r: 34, g: 197, b: 203)
        }
        rankLabel.text = club.rank
    }
    
    override func prepareForReuse() {
        iconImageView.image = nil
        nameLabel.text = nil
        typeLabel.text = nil
        timeLabel.text = nil
        rankLabel.text = nil
    }
    
}
