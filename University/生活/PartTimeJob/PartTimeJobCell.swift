//
//  PartTimeJobCell.swift
//  University
//
//  Created by 肖权 on 2018/11/15.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class PartTimeJobCell: UITableViewCell {

    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var introduceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupModel(_ job: PartTimeJob) {
        iconImageView.sd_setImage(with: URL(string: baseURL + job.imageURL), completed: nil)
        titleLabel.text = job.title
        priceLabel.text = "￥" + String(job.price)
        introduceLabel.text = job.introduce
    }
    
    override func prepareForReuse() {
        iconImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        introduceLabel.text = nil

    }
    
}
