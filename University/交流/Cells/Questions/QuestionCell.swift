//
//  QuestionCell.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerCountLabel: UILabel!
    
    private var id: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(_ model: QuestionModel) {
        id = model.id
        questionLabel.text = model.question
        answerCountLabel.text = String(model.answerCount) + " 条回答"
    }
    
    @IBAction func moreAboutQuestion(_ sender: UIButton) {
        
    }
}
