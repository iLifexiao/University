//
//  RaceTableViewCell.swift
//  University
//
//  Created by 肖权 on 2018/11/12.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class RaceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupModel(_ race: Race) {
        iconImageView.sd_setImage(with: URL(string: baseURL + race.imageURL), completed: nil)
        nameLabel.text = race.name
        timeLabel.text = race.time
        typeLabel.text = race.type        
    }
    
    override func prepareForReuse() {
        iconImageView.image = nil
        nameLabel.text = nil
        timeLabel.text = nil
        typeLabel.text = nil
    }
}
