//
//  ExaminationCell.swift
//  University
//
//  Created by 肖权 on 2018/11/13.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class ExaminationCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupModel(_ examination: Examination) {
        nameLabel.text = examination.name
        majorLabel.text = examination.major
        timeLabel.text = examination.time
        siteLabel.text = examination.site
        yearLabel.text = examination.year
        teacherLabel.text = examination.teacher
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        majorLabel.text = nil
        timeLabel.text = nil
        siteLabel.text = nil
        yearLabel.text = nil
        teacherLabel.text = nil
    }
    
}
