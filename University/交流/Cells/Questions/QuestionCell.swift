//
//  QuestionCell.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

//@objc protocol QuestionCellDelegate {
//    func showMoreInfoAboutQuestion(_ id: String?)
//}

class QuestionCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerCountLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    
    private var id: String?
//    weak var delegate: QuestionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupModel(_ question: Question) {
        id = String(question.id ?? 0)
        questionLabel.text = question.title
        answerCountLabel.text = String(question.answerCount ?? 0) + " 条回答"
        typeLabel.text = question.type
        fromLabel.text = question.from
        postTimeLabel.text = friendDateByUnixTime(question.createdAt ?? 0)
    }
    
    override func prepareForReuse() {
        questionLabel.text = nil
        answerCountLabel.text = nil
        typeLabel.text = nil
        fromLabel.text = nil
        postTimeLabel.text = nil
    }
    
//    @IBAction func moreAboutQuestion(_ sender: UIButton) {
//        if let delegate = delegate {
//            delegate.showMoreInfoAboutQuestion(id)
//        }
//    }
}
