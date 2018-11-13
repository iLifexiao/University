//
//  RaceDetailCell.swift
//  University
//
//  Created by 肖权 on 2018/11/13.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class RaceDetailCell: UITableViewCell {

    @IBOutlet weak var contentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupModel(_ race: Race) {
        contentTextView.text = race.content
    }
    
    override func prepareForReuse() {
        contentTextView.text = nil
    }
    
}
