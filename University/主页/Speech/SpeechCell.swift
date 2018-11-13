//
//  SpeechCell.swift
//  University
//
//  Created by 肖权 on 2018/11/13.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class SpeechCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speakerLabel: UILabel!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupModel(_ speech: Speech) {
        nameLabel.text = speech.title
        speakerLabel.text = speech.speaker
        siteLabel.text = speech.site
        timeLabel.text = speech.time
        companyLabel.text = speech.company
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        speakerLabel.text = nil
        siteLabel.text = nil
        timeLabel.text = nil
        companyLabel.text = nil
    }
}
