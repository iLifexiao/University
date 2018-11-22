//
//  NewsCell.swift
//  University
//
//  Created by 肖权 on 2018/10/24.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class NewsCell: UICollectionViewCell {

    
    @IBOutlet weak var newsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setNews(_ news: String) {
        newsLabel.text = news
    }
}
