//
//  CampusNewsCell.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class CampusNewsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var originalLabel: UILabel!
    @IBOutlet weak var readCountLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    private var id: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupModel(_ campusNews: CampusNews) {
        self.id = String(campusNews.id ?? 0)
        titleLabel.text = campusNews.title
        originalLabel.text = campusNews.from
        readCountLabel.text = String(campusNews.readCount ?? 0) + " 阅读"
        typeLabel.text = campusNews.type
        dateLabel.text = unixTime2StringDate(campusNews.createdAt ?? 0, format: "yyyy-MM-dd")
        newsImageView.sd_setImage(with: URL(string: baseURL + campusNews.imageURL), completed: nil)
    }
    
}
