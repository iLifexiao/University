//
//  HonorCell.swift
//  University
//
//  Created by 肖权 on 2018/11/16.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class HonorCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupModel(_ honor: Honor) {
        nameLabel.text = honor.name
        rankLabel.text = honor.rank
        timeLabel.text = honor.time
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        rankLabel.text = nil
        timeLabel.text = nil
    }
}
